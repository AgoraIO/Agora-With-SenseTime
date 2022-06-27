//
//  EFMaterialDownloadStatusManager.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMaterialDownloadStatusManager.h"
#import "EFRemoteDataSourceHelper.h"
#import "NSObject+dictionary.h"

static NSString * const EFMaterialDownloadStatusManagerCodingStatusDownloadingStorageKey = @"com.sensetime.damen_EFMaterialDownloadStatusManagerCodingStatusDownloadingStorageKey";
static NSString * const EFMaterialDownloadStatusManagerCodingStatusDownloadedStorageKey = @"com.sensetime.damen_EFMaterialDownloadStatusManagerCodingStatusDownloadedStorageKey";


@interface EFMaterialDownloadStatusManager ()

@property (nonatomic, readwrite, strong) NSMutableDictionary * downloadingStorage;
@property (nonatomic, readwrite, strong) NSMutableDictionary * downloadedStorage;

@end

static NSString * efCachePath;

@implementation EFMaterialDownloadStatusManager
{
    /// 基础数据
    NSMutableArray<SenseArMaterial *> * _helperArrMaterials;
}

+(instancetype)sharedInstance {
    static EFMaterialDownloadStatusManager * _sharedDownloadStatusManager = nil;
    static dispatch_once_t materialDownloadStatusManagerOnceToken;
    dispatch_once(&materialDownloadStatusManagerOnceToken, ^{
        efCachePath = [NSHomeDirectory() stringByAppendingString: @"/Documents/EFMaterialDownloadStatusManager"];
        _sharedDownloadStatusManager = [EFMaterialDownloadStatusManager _efLoadCache];
        if (!_sharedDownloadStatusManager) _sharedDownloadStatusManager = [[self alloc] init];
    });
    return _sharedDownloadStatusManager;
}

# pragma mark - public
/// 获取当前model的下载状态
/// @param model target model
-(EFMaterialDownloadStatus)efDownloadStatus:(id<EFDataSourcing>)model {
    if (![model isMemberOfClass:[EFDataSourceMaterialModel class]]) return EFMaterialDownloadStatusDownloaded;
    EFDataSourceMaterialModel * modelx = (EFDataSourceMaterialModel *)model;
    if (modelx.efIsLocal) {
        _downloadingStorage[modelx.strID] = modelx;
        return EFMaterialDownloadStatusDownloaded;
    }
        
    if (_downloadingStorage[modelx.strID]) return EFMaterialDownloadStatusDownloading;
    if (![[SenseArMaterialService sharedInstance] isMaterialDownloaded:modelx]) return EFMaterialDownloadStatusNotDownload;
    if (_downloadedStorage[modelx.strID]) return EFMaterialDownloadStatusDownloaded;
    return EFMaterialDownloadStatusNotDownload;
}

/// 开始下载
/// @param model 选中的model
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
-(void)efStartDownload:(id<EFDataSourcing>)model onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure {
    EFDataSourceMaterialModel * modelx = (EFDataSourceMaterialModel *)model;
    
    if (![modelx yy_modelToJSONObject]) return;
    
    self.downloadingStorage[modelx.strID] = [modelx yy_modelToJSONObject];
    __weak typeof(self) weakself = self;
    [self _prepareRequestDatasourceWithCallback:^{
        __strong typeof(weakself) strongself = weakself;
        SenseArMaterial * remoteMaterialModel = [strongself _modelTransformFrom:modelx];
        if (remoteMaterialModel == nil) {
            return;
        }
        [[SenseArMaterialService sharedInstance] downloadMaterial:remoteMaterialModel onSuccess:^(SenseArMaterial *material) {
            @synchronized (strongself) {
                EFDataSourceMaterialModel * materialModel = [strongself _modelFromRemoteModel:material andOriginModel:modelx];
                [strongself.downloadingStorage removeObjectForKey:modelx.strID];
                if ([materialModel yy_modelToJSONObject]) {
                    strongself.downloadedStorage[modelx.strID] = [materialModel yy_modelToJSONObject];
                    [strongself _efCache];
                }
                if (completeSuccess) completeSuccess(materialModel);
            }
        } onFailure:^(SenseArMaterial *material, int iErrorCode, NSString *strMessage) {
            EFDataSourceMaterialModel * materialModel = [strongself _modelFromRemoteModel:material andOriginModel:modelx];
            [strongself.downloadingStorage removeObjectForKey:modelx.strID];
            if (completeFailure) completeFailure(materialModel, iErrorCode, strMessage);
        } onProgress:^(SenseArMaterial *material, float fProgress, int64_t iSize) {
            EFDataSourceMaterialModel * materialModel = [strongself _modelFromRemoteModel:material andOriginModel:modelx];
            if (processingCallBack) processingCallBack(materialModel, fProgress, iSize);
        }];
    }];
}

-(void)efStartDownloadTryOn:(id<EFDataSourcing>)model onProgress:(void (^)(SenseArMaterial *material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(SenseArMaterial *material))completeSuccess onFailure:(void (^)(SenseArMaterial *material , int iErrorCode , NSString *strMessage))completeFailure {
    EFDataSourceMaterialModel * modelx = (EFDataSourceMaterialModel *)model;
    
    if (![modelx yy_modelToJSONObject]) return;
    
    self.downloadingStorage[modelx.strID] = [modelx yy_modelToJSONObject];
    __weak typeof(self) weakself = self;
    [self _prepareRequestDatasourceWithCallback:^{
        __strong typeof(weakself) strongself = weakself;
        SenseArMaterial * remoteMaterialModel = [strongself _modelTransformFrom:modelx];
        if (remoteMaterialModel == nil) {
            return;
        }
        [[SenseArMaterialService sharedInstance] downloadMaterial:remoteMaterialModel onSuccess:^(SenseArMaterial *material) {
            EFDataSourceMaterialModel * materialModel = [strongself _modelFromRemoteModel:material andOriginModel:modelx];
            [strongself.downloadingStorage removeObjectForKey:modelx.strID];
            if ([materialModel yy_modelToJSONObject]) {
                strongself.downloadedStorage[modelx.strID] = [materialModel yy_modelToJSONObject];
                [strongself _efCache];
            }
            if (completeSuccess) completeSuccess(material);
        } onFailure:^(SenseArMaterial *material, int iErrorCode, NSString *strMessage) {
            [strongself.downloadingStorage removeObjectForKey:modelx.strID];
            if (completeFailure) completeFailure(material, iErrorCode, strMessage);
        } onProgress:^(SenseArMaterial *material, float fProgress, int64_t iSize) {
            if (processingCallBack) processingCallBack(material, fProgress, iSize);
        }];
    }];
}

/// 由数据源model置换出已下载素材model （如果没有下载成功则返回原model）
/// @param orginModel 数据源model
-(EFDataSourceMaterialModel *)efDisplacesWith:(EFDataSourceMaterialModel *)orginModel {
    if (![orginModel isMemberOfClass:[EFDataSourceMaterialModel class]]) return orginModel;
    NSDictionary * modelDict = self.downloadedStorage[orginModel.strID];
    if (!modelDict) return orginModel;
    EFDataSourceMaterialModel * result = [EFDataSourceMaterialModel yy_modelWithDictionary:modelDict];
    NSArray * filePathArray = [result.strMaterialPath componentsSeparatedByString:@"/"];
    NSArray * sandBoxPathArray = [NSHomeDirectory() componentsSeparatedByString:@"/"];
    NSMutableArray * fixedArray = [NSMutableArray array];
    for (NSInteger i = 0; i < filePathArray.count; i ++) {
        NSString * next = filePathArray[i];
        if (i < sandBoxPathArray.count) next = sandBoxPathArray[i];
        [fixedArray addObject:next];
    }
    result.strMaterialPath = [fixedArray componentsJoinedByString:@"/"];
    result.efType = orginModel.efType;
    result.efRoute = orginModel.efRoute;
    result.efName = orginModel.efName;
    return result;
}

#pragma mark - helper
/// 根据获取到的service material model以及原model组装成新的model
/// @param remoteModel service material model
/// @param originModel origin model
-(EFDataSourceMaterialModel *)_modelFromRemoteModel:(SenseArMaterial *)remoteModel andOriginModel:(EFDataSourceMaterialModel *)originModel {
    EFDataSourceMaterialModel * materialModel = [EFDataSourceMaterialModel yy_modelWithDictionary:[remoteModel efDictionaryValue]];
    materialModel.efName = remoteModel.strName;
    materialModel.efThumbnailDefault = remoteModel.strThumbnailURL;
    materialModel.efType = originModel.efType;
    materialModel.efMaterialPath = remoteModel.strMaterialPath;
    materialModel.efRoute = originModel.efRoute;
    return materialModel;
}

/// 根据当前model获取基础数据中的service material model
/// @param orginModel 当前model
-(SenseArMaterial *)_modelTransformFrom:(EFDataSourceMaterialModel *)orginModel {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.strID == %@", orginModel.strID];
    SenseArMaterial * currentGroup = [_helperArrMaterials filteredArrayUsingPredicate:filterPredicate].firstObject;
    return currentGroup;
}

# pragma mark - 内部流程
/// 准备基础数据（用以辅助下载素材包）
-(void)_prepareRequestDatasourceWithCallback:(void(^)(void))callback {
    if (_helperArrMaterials && _helperArrMaterials.count > 0) {
        if (callback) callback();
        return;
    }
    _helperArrMaterials = [NSMutableArray array];
    [EFRemoteDataSourceHelper efFetchAllRemoteGroupsWithMaterialsOnSuccess:^(NSArray<SenseArMaterialGroup *> * _Nonnull arrMaterialGroups) {
        for (SenseArMaterialGroup * group in arrMaterialGroups) {
            for (SenseArMaterial * material in group.materialsArray) {
                [self -> _helperArrMaterials addObject:material];
            }
        }
        if (callback) callback();
    } onFailure:^(int iErrorCode, NSString * _Nonnull strMessage) {
        [self _prepareRequestDatasourceWithCallback:callback];
    }];
}

# pragma mark - property
-(NSMutableDictionary *)downloadingStorage {
    if (!_downloadingStorage) {
        _downloadingStorage = [NSMutableDictionary dictionary];
    }
    return _downloadingStorage;
}

-(NSMutableDictionary *)downloadedStorage {
    if (!_downloadedStorage) {
        _downloadedStorage = [NSMutableDictionary dictionary];
    }
    return _downloadedStorage;
}

#pragma mark - NSSecureCoding
-(instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [self init]) {
        if (coder) {
//            _downloadingStorage = [coder decodeObjectOfClass:[NSMutableDictionary class] forKey:EFMaterialDownloadStatusManagerCodingStatusDownloadingStorageKey];
            _downloadedStorage = [coder decodeObjectOfClass:[NSMutableDictionary class] forKey:EFMaterialDownloadStatusManagerCodingStatusDownloadedStorageKey];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
//    [coder encodeObject:_downloadingStorage forKey:EFMaterialDownloadStatusManagerCodingStatusDownloadingStorageKey];
    [coder encodeObject:_downloadedStorage forKey:EFMaterialDownloadStatusManagerCodingStatusDownloadedStorageKey];
}

+(BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - cache & load
/// 当前状态缓存到本地
-(BOOL)_efCache {
    return [NSKeyedArchiver archiveRootObject:self toFile:efCachePath];
}

/// 读取本地缓存状态
+(instancetype)_efLoadCache {
    EFMaterialDownloadStatusManager * model = [NSKeyedUnarchiver unarchiveObjectWithFile:efCachePath];
    return model;
}

@end
