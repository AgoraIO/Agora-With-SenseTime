//
//  EFDataSourceGenerator.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/3.
//

#import "EFDataSourceGenerator.h"
#import "NSDictionary+jsonFile.h"
#import "EFStatusManager.h" // FIXME: 测试用
#import "EFRemoteDataSourceHelper.h"
#import "NSObject+dictionary.h"
#import "EFMachineVersion.h"

typedef NSString * EFSuffixType NS_EXTENSIBLE_STRING_ENUM;

static EFSuffixType const EFSuffixTypeBundle = @"bundle";
static EFSuffixType const EFSuffixTypeZip = @"zip";
static EFSuffixType const EFSuffixTypeModel = @"model";
static EFSuffixType const EFSuffixTypePng = @"png";
static EFSuffixType const EFSuffixTypeJpg = @"jpg";

static NSString * const EFDefaultBeautyParametersKey = @"EFDefaultBeautyParametersKey";

@interface EFDataSourceGenerator ()

@property (nonatomic, readwrite, strong) EFDataSourceModel * efDataSourceModel;
@property (nonatomic, readwrite, strong) NSArray * efDefaultStatusArray;
@property (nonatomic, readwrite, strong) NSArray * efTryonDatasource;

@end

@implementation EFDataSourceGenerator

#pragma mark - pubulic methods
+(instancetype)sharedInstance {
    static EFDataSourceGenerator * _sharedGenerator = nil;
    static dispatch_once_t generatorOnceToken;
    dispatch_once(&generatorOnceToken, ^{
        _sharedGenerator = [[self alloc] init];
    });
    return _sharedGenerator;
}

/// 生成所有数据
/// @param callback 生成回调 在返回model的efSubDataSources数据中获取所有分类数据
-(void)efGeneratAllDataSourceWithCallback:(EFDataSourceGeneratorCallback)callback {
    if (_efDataSourceModel) {
        if (callback) callback(_efDataSourceModel);
        return;
    }
    
    // 1. 生成所有大类数组
    NSString *jsonFileName = ENABLE_MULTI_STICKER_TAB ? @"all_categories" : @"all_categories_without_multi";
    NSDictionary * rootDict = [NSDictionary efTakeOutDatasourceFromJson:jsonFileName];
    __block EFDataSourceModel * rootModel = [EFDataSourceModel yy_modelWithDictionary:rootDict];
    
    if (![EFMachineVersion canShowCartonOfEffcts0805]) {
        NSMutableArray * effectArray = [[rootModel.efSubDataSources[3] efSubDataSources] mutableCopy];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"漫画脸"];
        NSArray * cartoonFilterArray = [effectArray filteredArrayUsingPredicate:predicate];
        [effectArray removeObjectsInArray:cartoonFilterArray];
        ((EFDataSourceModel *)rootModel.efSubDataSources[3]).efSubDataSources = effectArray.copy;
    }
    
    dispatch_group_t group = dispatch_group_create();
    // e. 获取所有服务器上素材包（特效+美妆）
    __block NSArray <SenseArMaterialGroup *> * materialGroups = [NSArray array];
    dispatch_group_enter(group);
    [EFRemoteDataSourceHelper efFetchAllRemoteGroupsWithMaterialsOnSuccess:^(NSArray<SenseArMaterialGroup *> *arrMaterialGroups) {
        materialGroups = arrMaterialGroups;
        dispatch_group_leave(group);
    } onFailure:^(int iErrorCode, NSString *strMessage) {
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // x. 组装数据源
        
        // 2. 组装滤镜数据源 bundle 位置：/SenseMeEffects/SenseMeEffects/resources/Filters
        [self _efPackagingAllFiltersDatasource:&rootModel];
        
        // 3. 组装美妆数据源 bundle+service 位置：/SenseMeEffects/SenseMeEffects/resources/Makeup
        [self _efPackagingAllMakeupsDatasource:&rootModel withMaterialGroups:materialGroups];
        
        // 4. 组装特效数据源 service + 本地沙盒
        [self _efPackagingAllEffectsDatasource:&rootModel withMaterialGroups:materialGroups];
        
        // 5. 组装风格数据源 bundle + service
        [self _efPackagingAllStyleDatasource:&rootModel withMaterialGroups:materialGroups];
        
        // 6. 组装Avatar数据源 service
        [self _efPackagingAllAvatarDatasource:&rootModel withMaterialGroups:materialGroups];
        
        [self _efPackagingAllTryOnDatasource:&rootModel withMaterialGroups:materialGroups];
        
        self.efDataSourceModel = rootModel;

        if (callback) callback(rootModel);
    });
}

-(NSUInteger)efRealType:(NSUInteger)originType {
    return efConvertType(originType).real_type;
}

-(void)efGeneratDefaultBeautyParametersBy:(NSUInteger)faceType {
    NSDictionary * defaultBeautyParameters = [NSDictionary efTakeOutDatasourceFromJson:@"beauties"];
    NSDictionary * root = defaultBeautyParameters[@"root"];
    NSArray * currentDefaultBeautyParameters = root[@(faceType).stringValue];
    [[NSUserDefaults standardUserDefaults] setObject:currentDefaultBeautyParameters forKey:EFDefaultBeautyParametersKey];
}

#pragma mark - datasource generators
/// 获取并组装所有的本地通用物体跟踪数据
/// @param rootModel 总数据源
-(instancetype)_efPackagingAllTrackDatasource:(EFDataSourceModel **)rootModel {
    EFDataSourceModel * stickersModel = (*rootModel).efSubDataSources[3];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"通用物体跟踪"];
    EFDataSourceModel * trackModel = [stickersModel.efSubDataSources filteredArrayUsingPredicate:predicate].firstObject;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"track" ofType:@"bundle"];
    NSFileManager * fManager = [[NSFileManager alloc] init];
    if (![fManager fileExistsAtPath:path]) [fManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray * arrFiles = [fManager contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray * result = [NSMutableArray array];
    for (NSInteger i = 0; i < arrFiles.count; i ++) {
        NSString * imageName = arrFiles[i];
        NSDictionary * filterDict = @{
            @"name": [NSString stringWithFormat:@"track.bundle/%@", imageName],
            @"imageName": [NSString stringWithFormat:@"track.bundle/%@", imageName],
            @"path": [NSString stringWithFormat:@"track.bundle/%@", imageName],
            @"type": @((trackModel.efType << 5) | (1 << 4)),
            @"route": @(trackModel.efRoute | (i + 1))
        };
        
        EFDataSourceMaterialModel * model = [EFDataSourceMaterialModel yy_modelWithDictionary:filterDict];
        model.efIsLocal = YES;
        model.efFromBundle = YES;
        [result addObject: model];
    }
    trackModel.efSubDataSources = [result copy];
    return self;
}

/// 获取并组装所有的本地贴纸素材数据
/// @param rootModel 总数据源
-(instancetype)_efPackagingAllLocalStickersDatasource:(EFDataSourceModel **)rootModel {
    EFDataSourceModel * stickersModel = (*rootModel).efSubDataSources[3];
    
    NSPredicate *localPredicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"本地"];
    NSPredicate *multiPredicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"叠加"];

    EFDataSourceModel * local2Model = [stickersModel.efSubDataSources filteredArrayUsingPredicate:multiPredicate].lastObject;
    
    EFDataSourceModel * local1Model = [stickersModel.efSubDataSources filteredArrayUsingPredicate:localPredicate].lastObject;
    
    NSArray <NSString *> * localStickerZips = [self _efTakeOutStickersFromMobilesDocumentDirectory:@"stickers"];

    NSString *strDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localStickerPath = [strDocumentsPath stringByAppendingPathComponent:@"stickers"];
    
    NSMutableArray * local1Array = [NSMutableArray array];
    NSMutableArray * local2Array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < localStickerZips.count; i ++) {
        NSString * stickerZip = localStickerZips[i];
        NSString * stickerName = [stickerZip stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        NSDictionary * local1ModelDict = @{
            @"name": stickerName,
            @"path": [NSString pathWithComponents:@[localStickerPath , stickerZip]],
            @"type": @((local1Model.efType << 5) | (1 << 4)),
            @"imageName": [self _efGeneratorImagePathBy:stickerName],
            @"route": @(local1Model.efRoute | (i + 1))
        };
        NSDictionary * local2ModelDict = @{
            @"name": stickerName,
            @"path": [NSString pathWithComponents:@[localStickerPath , stickerZip]],
            @"type": @((local2Model.efType << 5) | (1 << 4)),
            @"imageName": [self _efGeneratorImagePathBy:stickerName],
            @"route": @(local2Model.efRoute | (i + 1))
        };
        
        EFDataSourceMaterialModel * model1 = [EFDataSourceMaterialModel yy_modelWithDictionary:local1ModelDict];
        model1.efIsLocal = YES;
        [local1Array addObject:model1];
        
        EFDataSourceMaterialModel * model2 = [EFDataSourceMaterialModel yy_modelWithDictionary:local2ModelDict];
        model2.efIsLocal = YES;
        [local2Array addObject:model2];
    }
    local1Model.efSubDataSources = [local1Array copy];
    local2Model.efSubDataSources = [local2Array copy];
    
    return self;
}

/// 2. 获取并组装所有的滤镜数据源
/// @param rootModel 总数据源
-(instancetype)_efPackagingAllFiltersDatasource:(EFDataSourceModel **)rootModel {
    NSArray <NSString *> * allFilterBundleNames = @[@"PortraitFilters", @"SceneryFilters", @"StillLifeFilters", @"DeliciousFoodFilters"];
    EFDataSourceModel * filterModel = (*rootModel).efSubDataSources[1];
    for (NSInteger i = 0; i < allFilterBundleNames.count; i ++) {
        NSString * bundleName = allFilterBundleNames[i];
        NSArray <NSString *> * filterStringModels = [self _efTakeOutStickersFromProjectBundle:bundleName andSuffix:EFSuffixTypeModel];
        NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:EFSuffixTypeBundle];
        NSMutableArray <EFDataSourceModel *> * filterDictArray = [NSMutableArray array];
        EFDataSourceModel * subFilterModel = filterModel.efSubDataSources[i];
        for (NSInteger i = 0; i < filterStringModels.count; i ++) {
            NSString * filterStringModel = filterStringModels[i];
            NSString * filterStringModelWithoutSuffix = [filterStringModel stringByReplacingOccurrencesOfString:@".model" withString:@""];
            NSDictionary * filterDict = @{
                @"name": [filterStringModelWithoutSuffix stringByReplacingOccurrencesOfString:@"filter_style_" withString:@""],
                @"imageName": [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@/%@.%@", bundleName, EFSuffixTypeBundle, filterStringModelWithoutSuffix, EFSuffixTypePng]] ? [NSString stringWithFormat:@"%@.%@/%@.%@", bundleName, EFSuffixTypeBundle, filterStringModelWithoutSuffix, EFSuffixTypePng] : [NSString stringWithFormat:@"%@.%@/%@.%@", bundleName, EFSuffixTypeBundle, filterStringModelWithoutSuffix, EFSuffixTypeJpg],
                @"path": [NSString pathWithComponents:@[strBundlePath , filterStringModel]],
                @"type": @((501 << 5) | (1 << 4)),
                @"route": @(subFilterModel.efRoute | i + 1)
            };
            [filterDictArray addObject: [EFDataSourceModel yy_modelWithDictionary:filterDict]];
        }
        subFilterModel.efSubDataSources = [filterDictArray copy];
    }
    return self;
}

/// 3. 获取并组装所有的美妆数据源
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllMakeupsDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    NSDictionary <NSString *, NSString *> * makeupCategoryNameMaps = @{@"口红": @"lips", @"腮红": @"blush", @"修容": @"face", @"眉毛": @"brow", @"眼影": @"eyeshadow", @"眼睫毛": @"eyelash"};
    EFDataSourceModel * makeupCategoryModels = (*rootModel).efSubDataSources[2];
    for (EFDataSourceModel * makeupCategoryModel in makeupCategoryModels.efSubDataSources) {
        NSMutableArray <EFDataSourceModel *> * makeupModels = [NSMutableArray array];
        if (makeupCategoryNameMaps[makeupCategoryModel.efName]) { // 先组装本地美妆素材包 bundle
            NSString * makeupBundleName = makeupCategoryNameMaps[makeupCategoryModel.efName];
            NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:makeupBundleName ofType:EFSuffixTypeBundle];
            NSArray <NSString *> * makeupZips = [self _efTakeOutStickersFromProjectBundle:makeupBundleName andSuffix:EFSuffixTypeZip];
            for (NSInteger i = 0; i < makeupZips.count; i ++) {
                NSString * makeupZip = makeupZips[i];
                NSString * makeupName = [makeupZip stringByReplacingOccurrencesOfString:@".zip" withString:@""];
                NSDictionary * modelDict = @{
                    @"name": makeupName,
                    @"path": [NSString pathWithComponents:@[strBundlePath , makeupZip]],
                    @"type": @(makeupCategoryModel.efType | (1 << 4)),
                    @"imageName": [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@/%@.%@", makeupBundleName, EFSuffixTypeBundle, makeupName, EFSuffixTypePng]] ? [NSString stringWithFormat:@"%@.%@/%@.%@", makeupBundleName, EFSuffixTypeBundle, makeupName, EFSuffixTypePng] : [NSString stringWithFormat:@"%@.%@/%@.%@", makeupBundleName, EFSuffixTypeBundle, makeupName, EFSuffixTypeJpg],
                    @"route": @(makeupCategoryModel.efRoute | (i + 1))
                };
                EFDataSourceModel * model = [EFDataSourceModel yy_modelWithDictionary:modelDict];
                [makeupModels addObject:model];
            }
        }
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.strGroupName == %@", makeupCategoryModel.efName];
        SenseArMaterialGroup * currentGroup = [materialGroups filteredArrayUsingPredicate:filterPredicate].firstObject;
        NSArray <SenseArMaterial *> * remoteMakeupModels = currentGroup.materialsArray;
        NSInteger basevalue = makeupModels.count;
        for (NSInteger i = 0; i < remoteMakeupModels.count; i ++) {
            SenseArMaterial * remoteMakeupModel = remoteMakeupModels[i];
            EFDataSourceMaterialModel * materialModel = [EFDataSourceMaterialModel yy_modelWithDictionary:[remoteMakeupModel efDictionaryValue]];
            materialModel.efName = materialModel.strName;
            materialModel.efThumbnailDefault = materialModel.strThumbnailURL;
//            /// ——/—/—/———
//            /// type/path_flag/mode_flag/mode
            materialModel.efType = makeupCategoryModel.efType | (1 << 4);
            materialModel.efMaterialPath = materialModel.strMaterialURL;
            materialModel.efRoute = makeupCategoryModel.efRoute | (i + 1 + basevalue);
            [makeupModels addObject:materialModel];
        }
        makeupCategoryModel.efSubDataSources = [makeupModels copy];
    }
    
    return self;
}

/// 4. 组装所有的特效数据源 - 贴纸类
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllEffectsDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    EFDataSourceModel * firstLevelCategory = (*rootModel).efSubDataSources[3];
    for (SenseArMaterialGroup * materialGroupWithListModel in materialGroups) {
        NSArray <NSString *> * mapGroupsNames = [self _ef_helper_convertToUIGroupsFrom:materialGroupWithListModel.strGroupName];
        for (EFDataSourceModel * secondLevelCategoryModel in firstLevelCategory.efSubDataSources) {
            if ([mapGroupsNames containsObject:secondLevelCategoryModel.efName]) {
                secondLevelCategoryModel.efAlias = materialGroupWithListModel.strGroupName;
                [secondLevelCategoryModel setEfMaterials:[materialGroupWithListModel materialsArray]];
            }
        }
    }
    
    // 获取本地物体跟踪素材
    [self _efPackagingAllTrackDatasource:rootModel];
    // 获取本地沙盒中的贴纸素材
    [self _efPackagingAllLocalStickersDatasource:rootModel];
    return self;
}

/// 5. 组装所有的风格
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllStyleDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    EFDataSourceModel * styleCategoryModels = (*rootModel).efSubDataSources[4];
    
    for (SenseArMaterialGroup * materialGroupWithListModel in materialGroups) {
        NSArray <NSString *> * mapGroupsNames = [self _ef_helper_convertToUIGroupsFrom:materialGroupWithListModel.strGroupName];
        for (NSInteger i = 0; i < styleCategoryModels.efSubDataSources.count; i++) {
            EFDataSourceModel * secondLevelCategoryModel = styleCategoryModels.efSubDataSources[i];
            if ([mapGroupsNames containsObject:secondLevelCategoryModel.efName]) {
                
                secondLevelCategoryModel.efAlias = materialGroupWithListModel.strGroupName;
                NSArray<SenseArMaterial *> * materialsArray = [materialGroupWithListModel materialsArray];
                [secondLevelCategoryModel setEfMaterials:materialsArray];
                if ([secondLevelCategoryModel.efName isEqualToString:@"轻妆"]) {
                    NSMutableArray * mutableSubDatasource = [secondLevelCategoryModel.efSubDataSources mutableCopy];
                    NSArray * tmp = [self _efGetStyleSourcesFromBundle:@"qingzhuang"];
                    if (tmp.count > 0) {
                        [mutableSubDatasource insertObject:tmp.firstObject atIndex:0];
                    }
                    secondLevelCategoryModel.efSubDataSources = [mutableSubDatasource copy];
                }
                
                for (NSInteger j = 0; j < secondLevelCategoryModel.efSubDataSources.count; j++) {
                    EFDataSourceMaterialModel * model = secondLevelCategoryModel.efSubDataSources[j];
                    model.efType = (secondLevelCategoryModel.efType << 5) | (1 << 4);
                    model.efRoute = secondLevelCategoryModel.efRoute | (j + 1);
                }
            }
        }
    }
    return self;
}

-(NSArray <EFDataSourceModel *> *)_efGetStyleSourcesFromBundle:(NSString *)styleBundleName {
    NSString *strBundlePath = [[NSBundle mainBundle] pathForResource:styleBundleName ofType:EFSuffixTypeBundle];
    NSArray <NSString *> * makeupZips = [self _efTakeOutStickersFromProjectBundle:styleBundleName andSuffix:EFSuffixTypeZip];
    NSMutableArray * result = [NSMutableArray array];
    for (NSInteger i = 0; i < makeupZips.count; i ++) {
        NSString * styleZip = makeupZips[i];
        NSString * styleName = [styleZip stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        NSDictionary * modelDict = @{
            @"name": styleName,
            @"path": [NSString pathWithComponents:@[strBundlePath , styleZip]],
            @"imageName": [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@/%@.%@", styleBundleName, EFSuffixTypeBundle, styleName, EFSuffixTypePng]] ? [NSString stringWithFormat:@"%@.%@/%@.%@", styleBundleName, EFSuffixTypeBundle, styleName, EFSuffixTypePng] : [NSString stringWithFormat:@"%@.%@/%@.%@", styleBundleName, EFSuffixTypeBundle, styleName, EFSuffixTypeJpg],
        };
        EFDataSourceModel * model = [EFDataSourceModel yy_modelWithDictionary:modelDict];
        [result addObject:model];
    }
    return [result copy];
}

/// 6. 组装所有的Avatar数据源 - 贴纸类
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllAvatarDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    EFDataSourceModel * firstLevelCategory = (*rootModel).efSubDataSources[5];
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.strGroupName == %@", @"avatar"];
    SenseArMaterialGroup * currentGroup = [materialGroups filteredArrayUsingPredicate:filterPredicate].firstObject;
    for (EFDataSourceModel * secondLevelCategoryModel in firstLevelCategory.efSubDataSources) {
        [secondLevelCategoryModel setEfMaterials:currentGroup.materialsArray];
    }
    return self;
}

/// 7.组装所有的GAN数据源 - 贴纸类
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllGANDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    
    return self;
}

/// x. 组装所有的Try on数据源 -
/// @param rootModel 总数据源
/// @param materialGroups 已经拉取到的远程素材列表
-(instancetype)_efPackagingAllTryOnDatasource:(EFDataSourceModel **)rootModel withMaterialGroups:(NSArray <SenseArMaterialGroup *> *)materialGroups {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.strGroupName CONTAINS %@", @"TryOn"];
    self.efTryonDatasource = [materialGroups filteredArrayUsingPredicate:filterPredicate];
    return self;
}

#pragma mark - 本地贴纸素材zip获取
/// 从工程的bundle文件中取出贴纸素材
/// @param bundleName bundle名称
/// @param callback 回调
- (instancetype)_efTakeOutStickersFromProjectBundle:(NSString *)bundleName callback: (void (^) (NSArray <NSString *> * materials))callback{
    if (callback) callback([self _efTakeOutStickersFromProjectBundle:bundleName andSuffix: EFSuffixTypeZip]);
    return self;
}

/// 从手机沙盒文件中取出贴纸素材
/// @param directoryName 文件夹名称
/// @param callback 回调
- (instancetype)_efTakeOutStickersFromMobilesDocumentDirectory:(NSString *)directoryName callback: (void (^) (NSArray <NSString *> * materials))callback {
    if (callback) [self _efTakeOutStickersFromMobilesDocumentDirectory:directoryName];
    return self;
}

/// 从工程的bundle文件中取出贴纸素材
/// @param bundleName bundle名称
- (NSArray <NSString *> *)_efTakeOutStickersFromProjectBundle:(NSString *)bundleName andSuffix:(EFSuffixType)suffix {
    if ([bundleName hasSuffix:EFSuffixTypeBundle]) bundleName = [bundleName componentsSeparatedByString:@"."].firstObject;
    if (!bundleName) return @[];
    NSString * localBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:EFSuffixTypeBundle];
    return [self _efTakeOutStickersFromPath:localBundlePath andSuffix:suffix];
}

/// 从手机沙盒文件中取出贴纸素材
/// @param directoryName 文件夹名称
- (NSArray <NSString *> *)_efTakeOutStickersFromMobilesDocumentDirectory:(NSString *)directoryName {
    if (!directoryName) return @[];
    NSString *strDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *localStickerPath = [strDocumentsPath stringByAppendingPathComponent:directoryName];
    return [self _efTakeOutStickersFromPath:localStickerPath andSuffix: EFSuffixTypeZip];
}

/// 根据文件路径来获取zip素材包list
/// @param path 文件夹路径
- (NSArray <NSString *> *)_efTakeOutStickersFromPath:(NSString *)path andSuffix:(EFSuffixType)suffix {
    NSArray * result = [NSArray array];
    if (!path) return result;
    NSFileManager * fManager = [[NSFileManager alloc] init];
    if (![fManager fileExistsAtPath:path]) [fManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray * arrFiles = [fManager contentsOfDirectoryAtPath:path error:nil];
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH %@", suffix];
    result = [arrFiles filteredArrayUsingPredicate:filterPredicate];
    return result;
}

#pragma mark - helper
/// 将从服务器group name映射为UI group name
/// @param originGroupName 原group name
-(NSArray <NSString *> *)_ef_helper_convertToUIGroupsFrom:(NSString *)originGroupName {
    NSDictionary <NSString *, NSArray <NSString *> *> * groupMapRulues = [NSDictionary efTakeOutDatasourceFromJson:@"material_group_map_rulues"];
    return groupMapRulues[originGroupName] ?: @[originGroupName];
}

struct EFDatasourceTypeStruct efConvertType(NSUInteger modelType) {
    NSUInteger pathFlagMask = 0b10000;
    NSUInteger modeFlagMask = 0b1000;
    NSUInteger modeMask = 0b111;

    struct EFDatasourceTypeStruct result;
    result.real_type = modelType >> 5;
    result.has_path = (modelType & pathFlagMask) >> 4;
    result.has_mode = (modelType & modeFlagMask) >> 3;
    result.mode_type = (modelType & modeMask);
    return result;
}

bool _efImageNameExist(NSString * imageName) {
    return [UIImage imageNamed:imageName];
}

-(NSString *)_efGeneratorImagePathBy:(NSString *)stickerName {
    NSString *strDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * result;
    if ([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/stickers/%@.%@", strDocumentsPath, stickerName, EFSuffixTypePng]]) {
        result = [NSString stringWithFormat:@"stickers/%@.%@", stickerName, EFSuffixTypePng];
    } else if ([UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/stickers/%@.%@", strDocumentsPath, stickerName, EFSuffixTypeJpg]]) {
        result = [NSString stringWithFormat:@"stickers/%@.%@", stickerName, EFSuffixTypeJpg];
    } else {
        result = @"none";
    }
    return result;
}

#pragma mark - default status
-(NSArray *)efDefaultStatusArray {
    if (!_efDefaultStatusArray) {
        _efDefaultStatusArray = [self _efGeneratorDefaultStatusByRootModel:self.efDataSourceModel];
    }
    return _efDefaultStatusArray;
}

/// 生成一次当前选中状态的缓存数据源并赋予默认强度
/// @param rootModel 数据源
-(NSArray *)_efGeneratorDefaultStatusByRootModel:(EFDataSourceModel *)rootModel {
    NSMutableArray * result = [NSMutableArray array];
    // 0 美颜 [0, 33]
    EFDataSourceModel * makeupsModel = rootModel.efSubDataSources.firstObject;
    NSArray * makeupDefaultValues = [[NSUserDefaults standardUserDefaults] objectForKey:EFDefaultBeautyParametersKey];
    if (!makeupDefaultValues) {
        makeupDefaultValues = @[ // 未知类型 (自然)
            @[@0, @0, @0, @0, @0, @60],
            @[@25, @0, @50, @0, @5, @10, @20, @0, @0, @20, @0], // 第二个高阶瘦脸占位
            @[@0, @0, @0, @-15, @0, @0, @0, @0, @0, @0, @0, @20, @-20, @0, @0, @25, @69, @60, @20, @15, @0],
            @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
            @[@0, @0, @50, @20]
        ];
    }
    
    for (NSInteger i = 0; i < makeupsModel.efSubDataSources.count; i ++) {
        EFDataSourceModel * makeupModel = makeupsModel.efSubDataSources[i];
        //base beauty 6     //shape 5 + 1(4)    //micro 19 + 1 + 1    //adjust 4
        for (NSInteger j = 0; j < makeupModel.efSubDataSources.count; j ++) {
            EFDataSourceModel * detailMakeupModel = makeupModel.efSubDataSources[j];
            if (!detailMakeupModel.efSubDataSources || detailMakeupModel.efSubDataSources.count == 0) {
                NSInteger strength = [(NSNumber *)makeupDefaultValues[i][j] integerValue];
                NSMutableDictionary * datasourceDict = [@{
                    @"efName": detailMakeupModel.efName,
                    @"efType": @(detailMakeupModel.efType),
                    @"efStrength": makeupDefaultValues[i][j],
                    @"efRoute": @(detailMakeupModel.efRoute),
                    @"efAction": strength > 0 ? @5 :@0
                } mutableCopy];
                if (detailMakeupModel.efMaterialPath) {
//                    whiten_gif.zip
                    datasourceDict[@"efPath"] = [[NSBundle mainBundle]pathForResource:@"whiten_gif" ofType:@"zip"];;
                }
                [result addObject:datasourceDict];
            } else { // 高阶瘦脸参数
                for (NSInteger k = 0; k < detailMakeupModel.efSubDataSources.count; k ++) {
                    EFDataSourceModel * seniorThinFaceModel = detailMakeupModel.efSubDataSources[k];
                    NSInteger currentCount = ((NSArray *)makeupDefaultValues[i]).count;
                    NSInteger strength = [(NSNumber *)(makeupDefaultValues[i][currentCount - 4 + k]) integerValue];
                    NSMutableDictionary * datasourceDict = [@{
                        @"efName": seniorThinFaceModel.efName,
                        @"efType": @(seniorThinFaceModel.efType),
                        @"efStrength": @(strength),
                        @"efRoute": @(seniorThinFaceModel.efRoute),
                        @"efAction": strength > 0 ? @5 :@0
                    } mutableCopy];
                    if (seniorThinFaceModel.efMaterialPath) {
                        datasourceDict[@"efPath"] = [[NSBundle mainBundle]pathForResource:@"whiten_gif" ofType:@"zip"];;
                    }
                    [result addObject:datasourceDict];
                }
            }
        }
    }
    // 4 默认风格 [34] - nvshen
    EFDataSourceModel * stylesModel = rootModel.efSubDataSources[4];
    if (!stylesModel) return [result copy];
    EFDataSourceModel * styleZiranModels = stylesModel.efSubDataSources[1];
    if (!styleZiranModels) return [result copy];
    NSPredicate * nvshenPredicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"xingchen"];
    EFDataSourceModel * styleZiranDefaultModel = [styleZiranModels.efSubDataSources filteredArrayUsingPredicate:nvshenPredicate].firstObject;
    if (styleZiranDefaultModel) {
        NSDictionary * defaultStyleDict = @{
            @"efName": styleZiranDefaultModel.efName,
            @"efType": @(styleZiranDefaultModel.efType),
            @"efRoute": @(styleZiranDefaultModel.efRoute),
            @"efPath": styleZiranDefaultModel.efMaterialPath,
            @"efAction": @1,
            @"efStrength": @(85 << 8 | 85)
        };
        [result addObject:defaultStyleDict];
    }
    return [result copy];
}

@end
