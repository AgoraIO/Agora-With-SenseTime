//
//  EFStatusManager.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStatusManager.h"
#import "EFSenseArMaterialDataModels.h"
#import "EFStorageHelper.h"

@interface EFStatusManager () <EFStorageHelperDelegate>

/// 已选中效果storage
@property (nonatomic, readwrite, strong) NSMutableDictionary <NSNumber *, id> * efStatusStorage;
/// 用以展示的效果（与UI联动）
@property (nonatomic, readwrite, strong) EFStatusModels * efCurrentStatusModels;
/// 用以缓存的效果（不随UI变化 只记录用户的操作）
@property (nonatomic, readwrite, strong) EFStatusModels * efStatusModels;

@property (nonatomic, readwrite, strong) EFStorageHelper * efStorageHelper;

@end

typedef NSString * EFStatusManagerCodingKey NS_EXTENSIBLE_STRING_ENUM;

static EFStatusManagerCodingKey const EFStatusManagerCodingStatusStorageKey = @"com.sensetime.damen_EFStatusManagerCodingStatusStorageKey";
static EFStatusManagerCodingKey const EFStatusManagerCodingStatusModelsKey = @"com.sensetime.damen_EFStatusManagerCodingStatusModelsKey";

@implementation EFStatusManager
{
    /// 读写队列
    dispatch_queue_t _rw_concurrent_queue;
    /// 是否开启缓存 Mode1默认开启
    BOOL _isCached;
    /// 当前mode
    EFStatusManagerSingletonMode _currentMode;
    
    void (^_currentDownloadCallback)(void);
    
    id<EFDataSourcing> shouldSelectedModel;
}

/// 缓存路径
static NSString * efCachePath;

#pragma mark - public

/// EFStatusManager的构造方法
/// @param mode 1、2、3 - 预览版/图片版/视频版应使用不同的mode
+(instancetype)sharedInstanceWith:(EFStatusManagerSingletonMode)mode {
    switch (mode) {
        case EFStatusManagerSingletonMode1:
            return [EFStatusManager sharedInstanceMode1];
            break;
        case EFStatusManagerSingletonMode2:
            return [EFStatusManager sharedInstanceMode2];
            break;
        case EFStatusManagerSingletonMode3:
            return [EFStatusManager sharedInstanceMode3];
            break;
    }
}

+(instancetype)sharedInstanceMode1 {
    static EFStatusManager * _sharedGenerator1 = nil;
    static dispatch_once_t generatorOnceToken1;
    dispatch_once(&generatorOnceToken1, ^{
        _sharedGenerator1 = [EFStatusManager _efLoadCacheByMode:EFStatusManagerSingletonMode1];
        if (!_sharedGenerator1) _sharedGenerator1 = [[self alloc] init];
        _sharedGenerator1 -> _isCached = YES;
        _sharedGenerator1 -> _currentMode = EFStatusManagerSingletonMode1;
    });
    return _sharedGenerator1;
}

+(instancetype)sharedInstanceMode2 {
    static EFStatusManager * _sharedGenerator2 = nil;
    static dispatch_once_t generatorOnceToken2;
    dispatch_once(&generatorOnceToken2, ^{
        //        _sharedGenerator2 = [EFStatusManager _efLoadCacheByMode:EFStatusManagerSingletonMode2];
        if (!_sharedGenerator2) _sharedGenerator2 = [[self alloc] init];
        _sharedGenerator2 -> _isCached = NO;
        _sharedGenerator2 -> _currentMode = EFStatusManagerSingletonMode2;
    });
    return _sharedGenerator2;
}

+(instancetype)sharedInstanceMode3 {
    static EFStatusManager * _sharedGenerator3 = nil;
    static dispatch_once_t generatorOnceToken3;
    dispatch_once(&generatorOnceToken3, ^{
        _sharedGenerator3 = [EFStatusManager _efLoadCacheByMode:EFStatusManagerSingletonMode3];
        if (!_sharedGenerator3) _sharedGenerator3 = [[self alloc] init];
        _sharedGenerator3 -> _isCached = NO;
        _sharedGenerator3 -> _currentMode = EFStatusManagerSingletonMode3;
    });
    return _sharedGenerator3;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _rw_concurrent_queue = dispatch_queue_create("read_write_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)test:(id<EFDataSourcing>)model {
    [self efModelSelected:model onProgress:nil onSuccess:^(id<EFDataSourcing> material) {
        //        DLog(@"%d", [self efDownloadStatus:model]);
        //        [self efModelSelected:model onProgress:nil onSuccess:nil onFailure:nil];
    } onFailure:^(id<EFDataSourcing> material, int iErrorCode, NSString *strMessage) {
        
    }];
}

/// 选中了model / 默认互斥
/// @param model 目标model
- (void)efModelSelected:(id<EFDataSourcing>)model {
    [self efModelSelected:model needMutex:YES];
}

/// 选中了model
/// @param model 目标model
/// @param needMutex 是否需要互斥
- (void)efModelSelected:(id<EFDataSourcing>)model needMutex:(BOOL)needMutex {
    dispatch_barrier_sync(_rw_concurrent_queue, ^{
        NSMutableDictionary * statusStorage = self.efStatusStorage;
        [self _efSaveModel:model toStorage:&statusStorage route:[_parseRoute(model.efRoute) mutableCopy] needMutex:needMutex];
        [self _efCache];
    });
}

/// 选中/点击了material model（默认互斥）
/// @param model 目标model
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
- (void)efModelSelected:(id<EFDataSourcing>)model
             onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack
              onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess
              onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure {
    
    [self efModelSelected:model needMutex:NO onProgress:processingCallBack onSuccess:completeSuccess onFailure:completeFailure];
}

- (void)efModelSelected:(id<EFDataSourcing>)model
              needMutex:(BOOL)needMutex
             onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack
              onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess
              onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure {
    static NSString * currentID;
    switch ([self efDownloadStatus:model]) {
        case EFMaterialDownloadStatusNotDownload: {
            shouldSelectedModel = model;
            currentID = ((EFDataSourceMaterialModel *)model).strID;
            [self efStartDownload:model
                       onProgress:processingCallBack
                        onSuccess:^(id<EFDataSourcing> material) {
                if (model != self->shouldSelectedModel) {
                    completeSuccess(nil);
                    return;
                } else {
                    if (completeSuccess) completeSuccess(material);
                }
                EFDataSourceMaterialModel * resultModel = (EFDataSourceMaterialModel *)material;
                if ([resultModel.strID isEqualToString:currentID]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
                    EFDataSourceModel * resultModel = [self efDisplacesWith:model];
#pragma clang diagnostic pop
                    [self efModelSelected:resultModel needMutex:needMutex];
                    if (completeSuccess) completeSuccess(resultModel);
                }
            } onFailure:completeFailure];
            break;
        }
        case  EFMaterialDownloadStatusDownloading: // TODO: 正在下载应该怎么办？
            
            break;
            
        default: { // 已经下载 / 无需下载
            shouldSelectedModel = model;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
            EFDataSourceModel * resultModel = [self efDisplacesWith:model];
#pragma clang diagnostic pop
            [self efModelSelected:resultModel needMutex:needMutex];
            if (completeSuccess) completeSuccess(resultModel);
            break;
        }
    }
}

-(void)efClear:(id<EFDataSourcing>)model {
    EFStatusModels * current = self.efCurrentStatusModels;
    EFStatusModels * cache = self.efStatusModels;
    [self.efStorageHelper efClear:model withCurrentStorage:&current andCacheStorage:&cache];
    [self _efCache];
}

-(void)efReset:(id<EFDataSourcing>)model {
    EFStatusModels * current = self.efCurrentStatusModels;
    EFStatusModels * cache = self.efStatusModels;
    [self.efStorageHelper efReset:model withCurrentStorage:&current cacheStorage:&cache andDefault: [EFStatusModels yy_modelWithDictionary:@{
        @"efCachedStatusModels": [[EFDataSourceGenerator sharedInstance] efDefaultStatusArray]
    }]];
    [self _efCache];
}

/// 判断目标model是否已经被选中
/// @param model 目标model
- (BOOL)efModelHasSelected:(id<EFDataSourcing>)model {
    __block BOOL result = NO;
    dispatch_sync(_rw_concurrent_queue, ^{
        result = [self _efFetchModelByRoute:model];
    });
    return result;
}

/// 获取model对应的强度
/// @param model 目标model
- (CGFloat)efStrengthOfModel:(id<EFDataSourcing>)model {
    __block CGFloat result = 0;
    dispatch_sync(_rw_concurrent_queue, ^{
        result = [self.efStorageHelper efStrengthOfModel:model byCurrentStorage:self.efCurrentStatusModels];
    });
    return result;
}

/// model强度发生改变 ⚠️ 需要穿透
/// @param model 目标model
/// @param newValue 变化后的强度
- (BOOL)efModel:(id<EFDataSourcing>)model strengthChanged:(CGFloat)newValue {
    dispatch_barrier_sync(_rw_concurrent_queue, ^{
        EFStatusModels * current = self.efCurrentStatusModels;
        EFStatusModels * cache = self.efStatusModels;
        [self.efStorageHelper efSelectModel:model withStrength:newValue * 100.0 withCurrentStorage:&current andCacheStorage:&cache];
        [self _efCache];
    });
    return YES;
}

/// 为当前manger 开/关缓存 - mode1默认开启 其他默认关闭
/// @param isOpenCache 设置的状态
- (BOOL)efSwitchCache:(BOOL)isOpenCache {
    return _isCached = isOpenCache;
}

/// 获取当前model的下载状态
/// @param model target model
-(EFMaterialDownloadStatus)efDownloadStatus:(id<EFDataSourcing>)model {
    return [[EFMaterialDownloadStatusManager sharedInstance] efDownloadStatus:model];
}

/// 开始下载
/// @param model 选中的model
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
-(void)efStartDownload:(id<EFDataSourcing>)model onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure {
    [[EFMaterialDownloadStatusManager sharedInstance] efStartDownload:model onProgress:processingCallBack onSuccess:completeSuccess onFailure:completeFailure];
}

/// 由数据源model置换出已下载素材model （如果没有下载成功则返回原model）
/// @param orginModel 数据源model
-(EFDataSourceMaterialModel *)efDisplacesWith:(EFDataSourceMaterialModel *)orginModel {
    return [[EFMaterialDownloadStatusManager sharedInstance] efDisplacesWith:orginModel];
}

// !!!: 获取UI需要展示的美颜参数（由于美妆贴纸的缘故，实际存储的参数可能与UI需要展示的参数有所差异，因而会有此方法的存在）
/// 从over lap更新current storage
-(void)efGetOverLapAndUpdateCurrentStorage {
    if (!self.efDelegate || ![self.efDelegate respondsToSelector:@selector(efStatusManagerGetOverlapValues:)]) return;
    // 2. 从代理中获取到over lap
    NSArray * overlapArray = [self.efDelegate efStatusManagerGetOverlapValues:self];
    
    if (![self _efIfNeedUpdateOverLap:overlapArray]) return;
    
    // 3. 移除over lap中出现的子素材
    NSMutableArray <EFRenderModel *> * overlapRenderModels = [NSMutableArray array];
    if (overlapArray.count == 0) {
        return;
    }
    
    EFStatusModels * current = self.efCurrentStatusModels;
    EFStatusModels * cache = self.efStatusModels;
    [self.efStorageHelper efRestoreAllMakeupParametersWithCurrentStorage:&current andCacheStorage:&cache];
    
    BOOL hasBeauty = NO; // 是否有美颜（如果没有美颜则从cache中恢复美颜参数）
    for (NSDictionary * overlap in overlapArray) {
        EFRenderModel * overlapRenderModel = [EFRenderModel yy_modelWithDictionary:overlap];
        // 将overlap对应的美颜类型置为0、非选中；并将对应的model置为选中并设置overlap中的强度 （美白、磨皮会有特殊处理）
        // 判断是否为美颜
        if ((overlapRenderModel.efType >= 100 && overlapRenderModel.efType < 400) || (overlapRenderModel.efType >= 600 && overlapRenderModel.efType < 700)) {
            // 找出current中对应的美颜render models
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud", overlapRenderModel.efType];
            NSArray <EFRenderModel *> * beautyRenderModels = [self.efCurrentStatusModels.efCachedStatusModels filteredArrayUsingPredicate:predicate];
//            NSArray <EFRenderModel *> * beautyRenderModels = self.efCurrentStatusModels.efCachedStatusModels;
            for (EFRenderModel * beautyRenderModel in beautyRenderModels) {
                if ((beautyRenderModel.efType & 0b111) == overlapRenderModel.efMode) {
                    beautyRenderModel.efAction = overlapRenderModel.efStrength > 0 ? EFRenderModelActionEffectsOnly : EFRenderModelActionDeselect;
                    beautyRenderModel.efStrength = overlapRenderModel.efStrength * 100.0;
                } else {
                    beautyRenderModel.efAction = EFRenderModelActionDeselect;
                    beautyRenderModel.efStrength = 0;
                }
            }
            hasBeauty = YES;
        } else if (overlapRenderModel.efType == 501) { // 判断是否有滤镜
            // 将原来存在的滤镜移除
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud", overlapRenderModel.efType];
            NSArray * result = [self.efCurrentStatusModels.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
            [self.efCurrentStatusModels.efCachedStatusModels removeObjectsInArray:result];
        } else if (overlapRenderModel.efType >= 400 && overlapRenderModel.efType < 500) { // 判断是否有美妆 移除current storage中对应类型的美妆
            NSPredicate * makeupPredicate = [NSPredicate predicateWithFormat:@"(SELF.efType >> 5) == %ud", overlapRenderModel.efType];
            NSArray * makeupModels = [self.efCurrentStatusModels.efCachedStatusModels filteredArrayUsingPredicate:makeupPredicate];
            [self.efCurrentStatusModels.efCachedStatusModels removeObjectsInArray:makeupModels];
//            for (EFRenderModel * delModel in makeupModels) {
//                DLog(@"移除了%@ - %ld - %@", delModel.efName, delModel.efType >> 5, @"");
//            }
            
        } else { // 不是以上类型直接添加到current
            overlapRenderModel.efType = overlapRenderModel.efType << 5;
            [overlapRenderModels addObject:overlapRenderModel];
        }
    }
    
    // 4. 将over lap中的参数同步到current storage中
    [self.efCurrentStatusModels.efCachedStatusModels addObjectsFromArray:overlapRenderModels];
    
//    if (!hasBeauty) { // 如果没有美颜参数则从cache恢复状态
//        EFStatusModels * current = self.efCurrentStatusModels;
//        EFStatusModels * cache = self.efStatusModels;
//        [self.efStorageHelper efRestoreAllMakeupParametersWithCurrentStorage:&current andCacheStorage:&cache];
//    }
}

/// 从cache storage还原current storage（移除所有的临时保存状态）
-(void)efRestoreCurrentStorageFromCache {
    _efStatusModels = nil;
    _efCurrentStatusModels = nil;
}

#pragma mark - 状态派发（to渲染）
/// 状态变化事件派发渲染
-(void)_efStatusChangedDistribute:(EFRenderModel *)renderModel {
    if (self.efDelegate && [self.efDelegate respondsToSelector:@selector(efStatusManager:statusChanged:)]) {
        [self.efDelegate efStatusManager:self statusChanged:renderModel];
    }
}

/// 触发所有存储的效果 （比如启动时加载已经保存的效果/首次启动加载默认效果）
- (void)efTriggerAllStorage {
    if (!self.efDelegate || ![self.efDelegate respondsToSelector:@selector(efStatusManager:statusChanged:)]) {
        return;
    }
    self.efCurrentStatusModels = nil;
    EFStatusModels * currentStorage = self.efCurrentStatusModels;
    [self.efStorageHelper efRemoveAllStickerFromCurrentStorageOnly:&currentStorage];
    
    NSArray * efCachedStatusModels = [self.efCurrentStatusModels.efCachedStatusModels copy];
    for (EFRenderModel * renderModel in efCachedStatusModels) {
        //        DLog(@"恢复：%@", renderModel.efName);
        NSUInteger realTypeValue = renderModel.efType >> 5;
        if (realTypeValue == 4) { // 风格
            renderModel.efAction = EFRenderModelActionSelect;
            [self.efDelegate efStatusManager:self statusChanged:renderModel];
        } else if ((realTypeValue >= 400 && realTypeValue < 500) || realTypeValue == 501) { // 美妆或者滤镜
            [self.efDelegate efStatusManager:self statusChanged:renderModel];
        } else {
            if (renderModel.efStrength != 0) {
                DLog(@"恢复了 %@ %f", renderModel.efName, renderModel.efStrength);
                [self.efDelegate efStatusManager:self statusChanged:renderModel];
            }
        }
    }
}

#pragma mark - helper
/// route还原
/// @param route original route value
static inline NSArray <NSNumber *> * _parseRoute(NSUInteger route) {
    return @[@(route & _k1_mask), @(route & _k2_mask), @(route & _k3_mask)];
}

/// 根据给定route来获取model
/// @param model target route
-(id)_efFetchModelByRoute:(id<EFDataSourcing>)model {
    NSUInteger route = model.efRoute;
    NSArray <NSNumber *> * keys = _parseRoute(route);
    if ([keys[1] isEqualToNumber:@0]) {
        return self.efStatusStorage[@1][@(route)];
    } else if ([keys.lastObject isEqualToNumber:@0]) {
        return self.efStatusStorage[@2][keys[0]][keys[1]];
    } else {
        EFStatusModels * current = self.efCurrentStatusModels;
        return [self.efStorageHelper efHasSelectedTargetModel:model byCurrentStorage:&current];
    }
}

/// 存储目标model / 如果已经存储则清空
/// @param model 目标model
/// @param storage 存储器
/// @param route 路径（目标model中获得）
/// @param needMutex 是否需要互斥
- (BOOL)_efSaveModel:(id<EFDataSourcing>)model toStorage:(NSMutableDictionary <NSNumber *, NSMutableDictionary *> **)storage route:(NSMutableArray <NSNumber *> *)route needMutex:(BOOL)needMutex {
    NSMutableDictionary * cachedDict = [(NSDictionary *)[(NSObject *)model yy_modelToJSONObject] mutableCopy];
    [cachedDict removeObjectForKey:@"subDataSources"];
    if ([route[1] isEqualToNumber:@0]) {
        [(*storage)[@1] removeAllObjects];
        (*storage)[@1][@(model.efRoute)] = cachedDict;
    } else if ([route.lastObject isEqualToNumber:@0]) {
        if (needMutex) [(*storage)[@2] removeObjectForKey:route.firstObject];
        (*storage)[@2][route.firstObject] = (*storage)[@2][route.firstObject] ?: [NSMutableDictionary dictionary];
        (*storage)[@2][route.firstObject][route[1]] = cachedDict;
    } else {
        EFStatusModels * current = self.efCurrentStatusModels;
        EFStatusModels * cache = self.efStatusModels;
        @synchronized (self) {
            [self.efStorageHelper efSelectModel:model withCurrentStorage:&current andCacheStorage:&cache];
        }
    }
    
    return YES;
}

/// 根据缓存mode生成缓存的路径
/// @param mode mode
NSString * _efCachePathBy(EFStatusManagerSingletonMode mode) {
    NSString * cachePath = NSHomeDirectory();
    switch (mode) {
        case EFStatusManagerSingletonMode1:
            cachePath = [cachePath stringByAppendingString: @"/Documents/EFStatusManagerSingletonMode1"];
            break;
        case EFStatusManagerSingletonMode2:
            cachePath = [cachePath stringByAppendingString: @"/Documents/EFStatusManagerSingletonMode2"];
            break;
        case EFStatusManagerSingletonMode3:
            cachePath = [cachePath stringByAppendingString: @"/Documents/EFStatusManagerSingletonMode3"];
            break;
    }
    return cachePath;
}

#pragma mark - EFStorageHelperDelegate
-(void)efRenderAction:(EFStorageHelper *)helper withRenderModel:(EFRenderModel *)renderModel {
    [self _efStatusChangedDistribute:renderModel];
}

-(void)efRenderAction:(EFStorageHelper *)helper set3DBeauties:(NSArray <EFRenderModel *> *)renderModels isClear:(BOOL)isClear {
    if (self.efDelegate && [self.efDelegate respondsToSelector:@selector(efStatusManager:set3DBeauties:isClear:)]) {
        [self.efDelegate efStatusManager:self set3DBeauties:renderModels isClear:isClear];
    }
}

/// 判断是否需要通过重新获取over lap来更新UI
/// @param newOverlapArray 新的over lap数组
-(BOOL)_efIfNeedUpdateOverLap:(NSArray *)newOverlapArray {
    return [self.efStorageHelper efIfNeedUpdateOverLap:newOverlapArray];
}

#pragma mark - properties
- (NSMutableDictionary *)efStatusStorage {
    @synchronized (self) {
        if (!_efStatusStorage) {
            _efStatusStorage = [NSMutableDictionary dictionary];
            _efStatusStorage[@1] = [NSMutableDictionary dictionary];
            _efStatusStorage[@2] = [NSMutableDictionary dictionary];
            _efStatusStorage[@3] = self.efCurrentStatusModels;
        }
        return _efStatusStorage;
    }
}

/// 重置缓存状态（默认参数）
-(void)_efResetStorage {
    @synchronized (self) {
        _efStatusModels = nil;
    }
}

-(EFStatusModels *)efStatusModels {
    @synchronized (self) {
        if (!_efStatusModels || !_efStatusModels.efCachedStatusModels) {
            _efStatusModels = [EFStatusModels yy_modelWithDictionary:@{
                @"efCachedStatusModels": [[EFDataSourceGenerator sharedInstance] efDefaultStatusArray]
            }];
        }
        return _efStatusModels;
    }
}

-(EFStatusModels *)efCurrentStatusModels {
    if (!_efCurrentStatusModels || _efCurrentStatusModels.efCachedStatusModels.count == 0) {
        _efCurrentStatusModels = [EFStatusModels yy_modelWithJSON:self.efStatusModels.yy_modelToJSONObject];
    }
    return _efCurrentStatusModels;
}

-(EFStorageHelper *)efStorageHelper {
    if (!_efStorageHelper) {
        _efStorageHelper = [[EFStorageHelper alloc] init];
        _efStorageHelper.efDelegate = self;
    }
    return _efStorageHelper;
}

-(NSArray *)efStickers {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.efType >> 5) == %d", 3];
    return [self.efCurrentStatusModels.efCachedStatusModels filteredArrayUsingPredicate:predicate];
}

#pragma mark - NSSecureCoding
-(instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [self init]) {
        if (coder) {
            _efStatusStorage = [coder decodeObjectOfClass:[NSMutableDictionary class] forKey:EFStatusManagerCodingStatusStorageKey];
            _efStatusModels = [coder decodeObjectOfClass:[EFStatusModels class] forKey:EFStatusManagerCodingStatusModelsKey];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_efStatusStorage forKey:EFStatusManagerCodingStatusStorageKey];
    [coder encodeObject:_efStatusModels forKey:EFStatusManagerCodingStatusModelsKey];
}

+(BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - others
-(NSString *)description {
    return [NSString stringWithFormat:@"%@ \n", self.efStatusStorage];
}

#pragma mark - cache & load
/// 当前状态缓存到本地
-(BOOL)_efCache {
    if (!_isCached) return NO;
    return [NSKeyedArchiver archiveRootObject:self toFile:_efCachePathBy(_currentMode)];
}

/// 读取本地缓存状态
+(instancetype)_efLoadCacheByMode:(EFStatusManagerSingletonMode)currentMode {
    EFStatusManager * model = [NSKeyedUnarchiver unarchiveObjectWithFile:_efCachePathBy(currentMode)];
    return model;
}

-(NSArray *)efSpecialTypes {
    return self.efStorageHelper.efSpecialTypes;
}

-(NSArray *)efSpecial3DNames {
    return self.efStorageHelper.efSpecial3DNames;
}

@end
