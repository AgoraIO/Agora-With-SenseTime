//
//  EFStorageHelper.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/30.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStorageHelper.h"
#import "st_mobile_effect.h"

@interface EFStorageHelper ()

@property (nonatomic, readwrite, strong) NSArray *efSpecialTypes;
@property (nonatomic, readwrite, strong) NSArray *efSpecial3DNames;

@end

@implementation EFStorageHelper
{
    /// 前一次获取时的over lap数组
    NSArray * _oldOverlapArray;
    /// 刚刚是否添加过贴纸/风格
    BOOL _isManualSetNotGet;
}

//    判断是不是 贴纸 - 美妆 - 滤镜 - 美颜 - 风格

//    贴纸：单个添加 - 可添加多个
//    美妆：染发 - 口红 -腮红 - 修容 - 眉毛 - 眼影 - 眼线 - 眼睫毛 - 美瞳 （可以同时存在）
//    滤镜：同一时间只能一个生效
//    美颜：单个二级菜单可能存在互斥的情况（比如 美白1-3是互斥的）；单个二级菜单也存在多个同时生效的问题（比如基础美颜选中了美白同时选中了磨皮…）；多个二级菜单下的美颜效果可以同时生效；
//    风格：只有一个可以生效（全部互斥）


-(void)efSelectModel:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    [self efSelectModel:targetModel withStrength:-CGFLOAT_MAX withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
}

-(void)efSelectModel:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels **)currentStorage andCacheStorage:(EFStatusModels **)cacheStorage {
    if (_efIsSticker(targetModel)) { // 贴纸
        [self _efSelecteStiker:targetModel withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
        _oldOverlapArray = nil;
    } else if (_efIsMakeup(targetModel)) { // 美妆
        [self _efSelecteMakeup:targetModel withStrength:strength withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
    } else if (_efIsFilter(targetModel)) { // 滤镜
        [self _efSelecteFilter:targetModel withStrength:strength withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
    } else if (_efIsBeauty(targetModel)) { // 美颜 有默认美颜且不能取消
        [self _efSelecteBeauty:targetModel withStrength:strength withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
    } else if (_efIsStyle(targetModel)) { // 风格 有默认风格
        [self _efSelecteStyle:targetModel withStrength:strength withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
        _oldOverlapArray = nil;
    } else if (_efIsTrack(targetModel)) {
        [self _efSelecteStiker:targetModel withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
    } else {
        DLog(@"选中了未知类型");
    }
    DLog(@"%@", targetModel.efName);
}

- (EFRenderModel *)efHasSelectedTargetModel:(id<EFDataSourcing>)targetModel byCurrentStorage:(EFStatusModels **)currentStorage {
    return [self _efUIHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
}

/// 清零事件
/// @param targetModel 需要被清零的targetModel
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)efClear:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 直接移除掉当前type全部model的类型
    if (_efIsSticker(targetModel) || _efIsFilter(targetModel) || _efIsStyle(targetModel)) { // 贴纸/滤镜/风格类型
        // 从current中移除所有的已选中models 清空对应的一级route
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efRoute & %lx == %ud", _k1_mask, targetModel.efRoute & _k1_mask];
        NSArray * currentTypeModels = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
        if (currentTypeModels && currentTypeModels.count > 0) {
            for (EFRenderModel * model in currentTypeModels) {
                // 清空已选中对应models
                [(*currentStorage).efCachedStatusModels removeObject:model];
                model.efAction = EFRenderModelActionDeselect;
                // 回调 渲染
                [self _efCallbak:model];
            }
        }
        if (_efIsSticker(targetModel)) {
            //            [(*currentStorage).efCachedStatusModels removeAllObjects];
            [self efRestoreAllMakeupParametersWithCurrentStorage:currentStorage andCacheStorage:cacheStorage];
        } else {
            // 取消状态透传到cache
            NSArray * cachedTypeModels = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
            for (EFRenderModel * model in cachedTypeModels) {
                model.efAction = EFRenderModelActionDeselect;
                [self _efCallbak:model];
            }
            if (cachedTypeModels && cachedTypeModels.count > 0) {
                [(*cacheStorage).efCachedStatusModels removeObjectsInArray:cachedTypeModels];
            }
        }
        if (_efIsStyle(targetModel) || _efIsSticker(targetModel)) { // 移除掉风格 恢复美妆+滤镜的选中状态
            //            [self efSetNeedsUpdateOverLap:NO];
            // 筛选出cache中所有的美妆和滤镜 并添加到current中
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud || (SELF.efType >> 5 >= %d && SELF.efType >> 5 < %d)", 501, 400, 500];
            NSArray * makeupAndFilter = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
            [(*currentStorage).efCachedStatusModels addObjectsFromArray:makeupAndFilter];
        }
    } else if (_efIsMakeup(targetModel)) { // 美妆
        NSArray * otherMakeupModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage]; // 获取到所有当前类型下所有选中的效果
        if (otherMakeupModels && otherMakeupModels.count > 0) { // 在current中移除有所的当前效果类型model
            for (EFRenderModel * model in otherMakeupModels) {
                // 清空已选中对应models
                [(*currentStorage).efCachedStatusModels removeObject:model];
                model.efAction = EFRenderModelActionDeselect;
                // 回调 渲染
                [self _efCallbak:model];
            }
        }
        // 取消状态透传到cache
        NSArray * cachedMakeupModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
        for (EFRenderModel * model in cachedMakeupModels) {
            model.efAction = EFRenderModelActionDeselect;
            [self _efCallbak:model];
        }
        if (cachedMakeupModels && cachedMakeupModels.count > 0) {
            [(*cacheStorage).efCachedStatusModels removeObjectsInArray:cachedMakeupModels];
        }
    } else if (_efIsBeauty(targetModel)) { // 美颜
        // 获取当前route l2所有被选中的models
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efRoute & %lx == %lx", _k12_mask, targetModel.efRoute & _k12_mask];
        NSArray * currentTypeModels = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
        
        if (currentTypeModels && currentTypeModels.count > 0) {
            if (_efIs3DBeauty(targetModel)) { // 3d微整形
                for (EFRenderModel * model in currentTypeModels) {
                    model.efAction = EFRenderModelActionDeselect;
                    model.efStrength = 0;
                }
                [self _ef3DClearAndResetCallbak:currentTypeModels isClear:YES];
            } else {
                for (EFRenderModel * model in currentTypeModels) {
                    model.efAction = EFRenderModelActionDeselect;
                    model.efStrength = 0;
                    [self _efCallbak:model];
                }
            }
        }
        
        // 透传到cache
        NSArray * cachedTypeModels = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
        if (cachedTypeModels && cachedTypeModels.count > 0) {
            for (EFRenderModel * model in cachedTypeModels) {
                model.efAction = EFRenderModelActionDeselect;
                model.efStrength = 0;
            }
        }
    }
}

-(CGFloat)efStrengthOfModel:(id<EFDataSourcing>)model byCurrentStorage:(EFStatusModels *)currentStorage {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud || SELF.efName == %@", model.efRoute, model.efName];
    if (_efIsStyle(model)) {
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", model.efRoute];
    }
    NSArray * filterArray = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    if (filterArray.count > 1) {
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", model.efRoute];
        filterArray = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    }
    EFRenderModel * renderModel = filterArray.firstObject;
    if (!renderModel) return 0;
    return [self _efRenderModel:renderModel restoreStrengthToUIStrength:renderModel.efStrength];
}

/// 重置事件
/// @param targetModel targetModel
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)efReset:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage cacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage andDefault:(EFStatusModels *)defaultModels {
    // 如果不是美颜类型，走清零逻辑
    if (!_efIsBeauty(targetModel)) [self efClear:targetModel withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
    // 获取current与default中的route2
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efRoute & %lx == %ud", _k12_mask, targetModel.efRoute & _k12_mask];
    NSArray <EFRenderModel *> * currentFiltersModel = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
    NSArray <EFRenderModel *> * defaultFiltersModel = [defaultModels.efCachedStatusModels filteredArrayUsingPredicate:predicate];
    NSArray <EFRenderModel *> * cachedFiltersModel = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
    
    //    if (_efIs3DBeauty(targetModel)) {
    //        for (NSInteger i = 0; i < currentFiltersModel.count; i ++) {
    //            currentFiltersModel[i].efAction = defaultFiltersModel[i].efAction;
    //            currentFiltersModel[i].efStrength = defaultFiltersModel[i].efStrength;
    //
    //            cachedFiltersModel[i].efAction = defaultFiltersModel[i].efAction;
    //            cachedFiltersModel[i].efStrength = defaultFiltersModel[i].efStrength;
    //        }
    //        [self _ef3DClearAndResetCallbak:currentFiltersModel isClear:YES];
    //    } else {
    for (NSInteger i = 0; i < currentFiltersModel.count; i ++) {
        currentFiltersModel[i].efAction = defaultFiltersModel[i].efAction;
        currentFiltersModel[i].efStrength = defaultFiltersModel[i].efStrength;
        
        cachedFiltersModel[i].efAction = defaultFiltersModel[i].efAction;
        cachedFiltersModel[i].efStrength = defaultFiltersModel[i].efStrength;
        
        [self _efCallbak:currentFiltersModel[i]];
    }
    //    }
}

/// 判断是否需要通过重新获取over lap来更新UI
/// @param newOverlapArray 新的over lap数组
-(BOOL)efIfNeedUpdateOverLap:(NSArray *)newOverlapArray {
    if (!_oldOverlapArray || _oldOverlapArray.count == 0) {
        _oldOverlapArray = [newOverlapArray copy];
        return YES;
    } else if (newOverlapArray.count != _oldOverlapArray.count) {
        _oldOverlapArray = [newOverlapArray copy];
        return YES;
    }
    return NO;
}

/// 移除current storage中所有的贴纸效果
/// @param currentStorage current storage
-(void)efRemoveAllStickerFromCurrentStorageOnly:(EFStatusModels *__autoreleasing *)currentStorage {
    EFDataSourceModel * model = [[EFDataSourceModel alloc] init]; // 移除掉所有的贴纸
    model.efRoute = 262410;
    model.efType = 112;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efRoute & %lx == %ud", _k1_mask, model.efRoute & _k1_mask];
    NSArray * currentTypeModels = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate];
    [(*currentStorage).efCachedStatusModels removeObjectsInArray:currentTypeModels];
}

/// 将美颜参数从cache恢复到current
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)efRestoreAllMakeupParametersWithCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    for (NSInteger i = 0; i < (*currentStorage).efCachedStatusModels.count; i ++) {
        NSInteger j = (*currentStorage).efCachedStatusModels[i].efRoute & _k1_mask;
        if (j != 65536) {
            continue;
        }
        (*currentStorage).efCachedStatusModels[i] = [(*cacheStorage).efCachedStatusModels[i] copy];
    }
}

#pragma mark - helper
/// 选中了贴纸
/// @param targetModel 贴纸model
/// @param currentStorage current storage
/// @param cacheStorage cacheStorage
-(void)_efSelecteStiker:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 1. 判断当前model是否已经被选中了
    EFRenderModel * storageModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
    if (storageModel) { // 被选中（反选逻辑）
        // 2-1. 将model从current storage中移除
        [(*currentStorage).efCachedStatusModels removeObject:storageModel];
        if ([self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage].count == 0) { // 判断当前是否仍有贴纸被选中
            // 如果没有贴纸被选中了，则将current从cache中恢复
            [self efClear:targetModel withCurrentStorage:currentStorage andCacheStorage:cacheStorage];
        }
        storageModel.efAction = EFRenderModelActionDeselect;
    } else { // 没有被选中
        //        _isAddedStickerJustNow = YES;
        NSArray * otherStickerModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage]; // 判断当前是否仍有贴纸被选中
        // 2-2. 是否为本地多贴纸
        if (targetModel.efIsMulti) { // 多贴纸
            if (otherStickerModels) { // 2-2-1. 是否有其他贴纸
                // 是否有其他的多贴纸类型（从其他贴纸中筛选出不是多贴纸的）
                NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efIsMulti == %d", NO];
                NSArray * otherTypeStickers = [otherStickerModels filteredArrayUsingPredicate:filterPredicate];
                if (otherTypeStickers && otherTypeStickers.count > 0) { // 有其他类型（非多贴纸类型）贴纸
                    // 2-2-2. 将current中贴纸清空
                    [(*currentStorage).efCachedStatusModels removeObjectsInArray:otherStickerModels];
                    for (EFRenderModel * model in otherStickerModels) {
                        model.efAction = EFRenderModelActionDeselect;
                        [self _efCallbak:model];
                    }
                }
            }
        } else if ((targetModel.efRoute & _k2_mask) == 589824) { // 2-3. 是否为通用物体跟踪
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud && SELF.efRoute & %lx == %ld", targetModel.efType >> 5, _k2_mask, 589824];
            otherStickerModels = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
            if (otherStickerModels) { // 2-2-1. 是否有其他贴纸
                // 2-2-2. 将current中贴纸清空
                [(*currentStorage).efCachedStatusModels removeObjectsInArray:otherStickerModels];
                for (EFRenderModel * model in otherStickerModels) {
                    model.efAction = EFRenderModelActionDeselect;
                    [self _efCallbak:model];
                }
            }
        } else { // 不是多贴纸 需要替换掉贴纸
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud && SELF.efRoute & %lx != %ld", targetModel.efType >> 5, _k2_mask, 589824];
            otherStickerModels = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
            if (otherStickerModels) { // 2-2-1. 是否有其他贴纸
                // 2-2-2. 将current中贴纸清空
                [(*currentStorage).efCachedStatusModels removeObjectsInArray:otherStickerModels];
                for (EFRenderModel * model in otherStickerModels) {
                    model.efAction = EFRenderModelActionDeselect;
                    [self _efCallbak:model];
                }
            }
        }
        // 2-3. 将model存入current
        [self _efTransformFromTargetModel:targetModel toRenderModelP:&storageModel];
        [(*currentStorage).efCachedStatusModels addObject:storageModel];
    }
    // 回调通知渲染
    [self _efCallbak:storageModel];
}

/// 选中了美妆
/// @param targetModel 美妆model
/// @param strength 设置美妆强度
/// @param currentStorage current storage
/// @param cacheStorage cacheStorage
-(void)_efSelecteMakeup:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 当前美妆是否已经选中
    EFRenderModel * storageModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
    if (storageModel) { // 如果已经被选中了，反选逻辑
        // 判断当前是否有美妆的强度设置
        if (strength > -CGFLOAT_MAX) { // 有强度 改变强度逻辑
            // 将model强度调整为设置的值
            storageModel.efStrength = strength;
            storageModel.efAction = EFRenderModelActionStrengthChanged;
            // 穿透到cache
            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
            cacheStorageFilterModel.efStrength = strength;
            
        } else { // 没有强度 反选逻辑
            // 将model从current中移除
            [(*currentStorage).efCachedStatusModels removeObject:storageModel];
            // 穿透到cache
            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
            [(*cacheStorage).efCachedStatusModels removeObject:cacheStorageFilterModel];
            storageModel.efAction = EFRenderModelActionDeselect;
        }
        // 回调
        [self _efCallbak:storageModel];
        
    } else { // 没有被选中，添加/替换逻辑
        // 当前target model类型是否有其他效果已经被选中
        CGFloat currentStrength = 80.0;
        NSArray * sameTypeModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage];
        if (sameTypeModels && sameTypeModels.count > 0) { // 有其他被选中
            // 将互斥类型models移出current
            [(*currentStorage).efCachedStatusModels removeObjectsInArray:sameTypeModels];
            // 移除状态透传到cache
            NSArray * sameTypeCacheModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
            [(*cacheStorage).efCachedStatusModels removeObjectsInArray:sameTypeCacheModels];
            for (EFRenderModel * selectedModel in sameTypeModels) {
                // 回调取消状态
                selectedModel.efAction = EFRenderModelActionDeselect;
                currentStrength = selectedModel.efStrength;
                [self _efCallbak:selectedModel];
            }
        }
        // 将model加入current,添加逻辑
        [self _efTransformFromTargetModel:targetModel toRenderModelP:&storageModel];
        storageModel.efStrength = currentStrength;
        [(*currentStorage).efCachedStatusModels addObject:storageModel];
        
        // 先从cache中筛选中其他的被选中的同类型美妆 并移除
        NSArray * sameMakeupsInCache = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
        [(*cacheStorage).efCachedStatusModels removeObjectsInArray:sameMakeupsInCache];
        // 穿透到cache
        [(*cacheStorage).efCachedStatusModels addObject:[storageModel copy]];
        // 回调
        [self _efCallbak:storageModel];
        
        _isManualSetNotGet = YES;
    }
    
    //    [self _efJudgeHadStyleAndSetUnactiveWithCurrentStorage:currentStorage andCacheStorage:cacheStorage];
}

/// 选中滤镜
/// @param targetModel 所选中的滤镜model
/// @param strength 设置滤镜强度
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)_efSelecteFilter:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 当前滤镜是否已经选中
    EFRenderModel * storageModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
    if (storageModel) { // 如果被选中
        // 判断是否有手动设置强度
        if (strength > -CGFLOAT_MAX) { // yes
            // 将model强度调整为设置的值
            storageModel.efStrength = strength;
            storageModel.efAction = EFRenderModelActionStrengthChanged;
            // 穿透到cache
            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
            cacheStorageFilterModel.efStrength = strength;
        } else { // no - 反选流程
            // 将model从current中移除
            [(*currentStorage).efCachedStatusModels removeObject:storageModel];
            // 穿透到cache
            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
            [(*cacheStorage).efCachedStatusModels removeObject:cacheStorageFilterModel];
            storageModel.efAction = EFRenderModelActionDeselect;
        }
    } else { // 没有被选中
        // 当前互斥类型是否有被选中
        NSArray * sameTypeModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage];
        CGFloat currentStrength = 80.0;
        if (sameTypeModels && sameTypeModels.count > 0) { // 有其他类型的滤镜被选中
            // 将其他滤镜移除current
            [(*currentStorage).efCachedStatusModels removeObjectsInArray:sameTypeModels];
            // 移除状态透传到cache
            NSArray * sameTypeCacheModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
            [(*cacheStorage).efCachedStatusModels removeObjectsInArray:sameTypeCacheModels];
            for (EFRenderModel * selectedModel in sameTypeModels) {
                // 回调取消状态
                currentStrength = selectedModel.efStrength;
                selectedModel.efAction = EFRenderModelActionDeselect;
                [self _efCallbak:selectedModel];
            }
        }
        // 将model加入current
        [self _efTransformFromTargetModel:targetModel toRenderModelP:&storageModel];
        // 将滤镜强度调整为设置值/默认80
        storageModel.efStrength = strength > -CGFLOAT_MAX ? strength : currentStrength;
        [(*currentStorage).efCachedStatusModels addObject:storageModel];
        // 穿透到cache
        // 先从cache中筛选中其他的被选中的同类型美妆 并移除
        NSArray * sameMakeupsInCache = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
        [(*cacheStorage).efCachedStatusModels removeObjectsInArray:sameMakeupsInCache];
        // 穿透到cache
        [(*cacheStorage).efCachedStatusModels addObject:[storageModel copy]];
        
        _isManualSetNotGet = YES;
    }
    
    // 回调 渲染
    [self _efCallbak:storageModel];
    
    //    [self _efJudgeHadStyleAndSetUnactiveWithCurrentStorage:currentStorage andCacheStorage:cacheStorage];
}

/// 选中了风格
/// @param targetModel 风格model
/// @param currentStorage current storage
/// @param cacheStorage cacheStorage
-(void)_efSelecteStyle:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 当前风格是否已经选中
    EFRenderModel * storageModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
    if (storageModel) { // 如果被选中
        // 判断是否有强度
        if (strength > -CGFLOAT_MAX) { // 如果有强度 修改强度的逻辑
            // 将model强度调整为设置的值
            storageModel.efStrength = strength / 100.f;
            storageModel.efAction = EFRenderModelActionStrengthChanged;
            // 穿透到cache
            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
            cacheStorageFilterModel.efStrength = strength / 100.f;
        } else { // 没有强度 再次点击了风格 忽略
            return;
        }
        //        else { // 没有强度 反选逻辑
        //            // 将model从current中移除
        //            [(*currentStorage).efCachedStatusModels removeObject:storageModel];
        //            // 穿透到cache
        //            EFRenderModel * cacheStorageFilterModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:cacheStorage];
        //            [(*cacheStorage).efCachedStatusModels removeObject:cacheStorageFilterModel];
        //            // 反选逻辑
        //            storageModel.efAction = EFRenderModelActionDeselect;
        //        }
    } else { // 没有被选中
        // 当前互斥类型是否有被选中
        NSArray * sameTypeModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage];
        if (sameTypeModels && sameTypeModels.count > 0) { // 有其他类型的滤镜被选中
            // 将其他风格移除current
            [(*currentStorage).efCachedStatusModels removeObjectsInArray:sameTypeModels];
            // 移除状态透传到cache
            // 移除状态透传到cache
            NSArray * sameTypeCacheModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*cacheStorage];
            [(*cacheStorage).efCachedStatusModels removeObjectsInArray:sameTypeCacheModels];
            for (EFRenderModel * selectedModel in sameTypeModels) {
                // 回调取消状态
                selectedModel.efAction = EFRenderModelActionDeselect;
                [self _efCallbak:selectedModel];
            }
        }
        // 将model加入current
        [self _efTransformFromTargetModel:targetModel toRenderModelP:&storageModel];
        storageModel.efStrength = 85 << 8 | 85;
        [(*currentStorage).efCachedStatusModels addObject:storageModel];
        // 添加结果穿透到cache
        [(*cacheStorage).efCachedStatusModels addObject:[storageModel copy]];
    }
    
    // 回调 渲染
    [self _efCallbak:storageModel];
}

/// 选中了美颜
/// @param targetModel 美颜model
/// @param currentStorage current storage
/// @param cacheStorage cacheStorage
-(void)_efSelecteBeauty:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    /**
     · 高亮状态不会穿透到cache中，cache中所有生效的效果都是EFRenderModelActionEffectsOnly状态（仅生效非高亮）
     */
    // 1 判断当前model是否已经是高亮状态？
    EFRenderModel * currentRenderModel = [self _efHasSelectedTargetModel:targetModel byCurrentStorage:currentStorage];
    if (currentRenderModel) { // 1 yes
        // 2 判断是否手动调节了强度值？
        if (strength <= -CGFLOAT_MAX) { // 2 no
            // 3 没有设置强度值忽略掉此次点击事件
            return;
        } else { // 2 yes
            // 3 手动调节强度值逻辑
            currentRenderModel.efAction = EFRenderModelActionStrengthChanged;
            currentRenderModel.efStrength = [self _efRenderModel:currentRenderModel getStrengthFromUIStrength:strength];
            
            // 4 穿透到cache
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud || SELF.efName == %@", targetModel.efRoute, targetModel.efName];
            NSArray * result = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
            EFRenderModel * cacheStorageFilterModel = result.firstObject;
            
            cacheStorageFilterModel.efAction = EFRenderModelActionEffectsOnly; // 生效但是不高亮
            cacheStorageFilterModel.efStrength = currentRenderModel.efStrength;
            
            // 5 回调、渲染
            [self _efCallbak:currentRenderModel];
        }
    } else { // 1 no
        // 2 将其他美颜效果取消高亮（置为生效不高亮状态）
        // 2 获取所有处于高亮状态的model
        NSArray <EFRenderModel *> * highlightModels = [self _efGetAllBeautysTypeModelsLike:targetModel from:*currentStorage];
        for (EFRenderModel * highlightModel in highlightModels) {
            if (highlightModel.efAction == EFRenderModelActionHighlightOnly) {
                highlightModel.efAction = EFRenderModelActionDeselect;
            } else {
                highlightModel.efAction = EFRenderModelActionEffectsOnly;
            }
        }
        // 3 判断是否有strength传入？
        if (strength <= -CGFLOAT_MAX) { // 3 no
            NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", targetModel.efRoute];
            NSArray * result = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
            currentRenderModel = result.firstObject;
            // 选中当前model
            currentRenderModel.efAction = EFRenderModelActionHighlightOnly;
        } else { // 3 yes
            // 4 互斥类型model 状态置为非选中，并将强度置为0
            // 5 将当前model置为选中+生效状态 并设置为传入的强度(默认为0)
            NSArray * sameTypeModels = [self _efFetchAllSameTypeModelsLike:targetModel from:*currentStorage];
            EFRenderModel * renderModel;
            for (EFRenderModel * sameTypeModel in sameTypeModels) {
                if (sameTypeModel.efRoute == targetModel.efRoute) { // 5
                    sameTypeModel.efAction = EFRenderModelActionSelect;
                    sameTypeModel.efStrength = [self _efRenderModel:sameTypeModel getStrengthFromUIStrength:strength];
                    renderModel = sameTypeModel;
                    
                    // 穿透到cache
                    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", sameTypeModel.efRoute];
                    NSArray *result = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
                    EFRenderModel * cacheStorageFilterModel = result.firstObject;
                    cacheStorageFilterModel.efAction = EFRenderModelActionEffectsOnly;
                    cacheStorageFilterModel.efStrength = sameTypeModel.efStrength;
                } else { // 4
                    sameTypeModel.efAction = EFRenderModelActionDeselect;
                    sameTypeModel.efStrength = [self _efRenderModel:sameTypeModel getStrengthFromUIStrength:0];
                    // 穿透到cache
                    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", sameTypeModel.efRoute];
                    NSArray *result = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
                    EFRenderModel * cacheStorageFilterModel = result.firstObject;
                    cacheStorageFilterModel.efAction = EFRenderModelActionDeselect;
                    cacheStorageFilterModel.efStrength = sameTypeModel.efStrength;
                    [self _efCallbak:sameTypeModel];
                }
            }
            if (renderModel) {
                [self _efCallbak:renderModel];
            }
        }
    }
}

/// 判断当前是否有风格被选中并将其置为非激活状态
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)_efJudgeHadStyleAndSetUnactiveWithCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage {
    // 判断当前是否有风格被选中
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == 4"];
    EFRenderModel * currentStyleModel = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate].firstObject;
    if (currentStyleModel && currentStyleModel.efAction != EFRenderModelActionUnactive) {
        // 将状态置为未激活
        currentStyleModel.efAction = EFRenderModelActionUnactive;
        // 穿透到cache
        EFRenderModel * cacheStyleModel = [(*cacheStorage).efCachedStatusModels filteredArrayUsingPredicate:predicate].firstObject;
        if (cacheStyleModel) {
            cacheStyleModel.efAction = EFRenderModelActionUnactive;
        }
    }
}

/// 回调 流程出口 通知渲染
/// @param renderModel renderModel
-(void)_efCallbak:(EFRenderModel *)renderModel { // 回调 流程出口 通知渲染
    if (self.efDelegate && [self.efDelegate respondsToSelector:@selector(efRenderAction:withRenderModel:)]) {
        [self.efDelegate efRenderAction:self withRenderModel:renderModel];
    }
}

/// 回调 流程出口 通知渲染
/// @param renderModel renderModel
-(void)_ef3DClearAndResetCallbak:(NSArray <EFRenderModel *>*)renderModels isClear:(BOOL)isClear { // 回调 流程出口 通知渲染
    if (self.efDelegate && [self.efDelegate respondsToSelector:@selector(efRenderAction:set3DBeauties:isClear:)]) {
        [self.efDelegate efRenderAction:self set3DBeauties:renderModels isClear:isClear];
    }
}

#pragma mark - helper
/// 判断当前model是否已经被选中过（route+name）
/// @param targetModel targetModel
/// @param currentStorage currentStorage
- (EFRenderModel *)_efHasSelectedTargetModel:(id<EFDataSourcing>)targetModel byCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud || SELF.efName == %@", targetModel.efRoute, targetModel.efName];
    if (_efIsSticker(targetModel) || _efIsStyle(targetModel)) {
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", targetModel.efRoute];
    }
    NSArray * result = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    EFRenderModel * resultModel = result.firstObject;
    if (!resultModel) return nil;
    if (_efIsBeauty(targetModel) && (resultModel.efAction == EFRenderModelActionDeselect || resultModel.efAction == EFRenderModelActionEffectsOnly || resultModel.efAction == EFRenderModelActionHighlightOnly)) return nil;
    return resultModel;
}

- (EFRenderModel *)_efUIHasSelectedTargetModel:(id<EFDataSourcing>)targetModel byCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud || SELF.efName == %@", targetModel.efRoute, targetModel.efName];
    if (_efIsSticker(targetModel) || _efIsStyle(targetModel)) {
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", targetModel.efRoute];
    }
    NSArray * result = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    if (result.count > 1) {
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", targetModel.efRoute];
        result = [(*currentStorage).efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    }
    EFRenderModel * resultModel = result.firstObject;
    if (!resultModel) return nil;
    if (_efIsBeauty(targetModel) && (resultModel.efAction == EFRenderModelActionDeselect || resultModel.efAction == EFRenderModelActionEffectsOnly)) return nil;
    if (_efIsStyle(targetModel) && resultModel.efAction == EFRenderModelActionUnactive) return nil;
    return resultModel;
}

/// 获取current storage中与当前类型相同的models
/// @param targetModel 当前类型model
/// @param currentStorage currentStorage
-(NSArray <EFRenderModel *>*)_efFetchAllSameTypeModelsLike:(id<EFDataSourcing>)targetModel from:(EFStatusModels *)currentStorage {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    NSPredicate * filterPredicate;
    NSArray * result;
    if (realTypeValue == EFFECT_BEAUTY_3D_MICRO_PLASTIC) { // 3d微整形
        filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute == %ud", targetModel.efRoute];
        result = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    } else {
        NSArray * seniorTypes = @[@321, @322, @323, @324];
        if ([seniorTypes containsObject:@(targetModel.efType >> 5)]) {
            filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 IN %@", seniorTypes];
            result = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
        } else {
            filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efType >> 5 == %ud", realTypeValue];
            result = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
        }
    }
    return result;
}

/// 根据传入的美颜model获取所有处于高亮状态的美颜models
/// @param targetModel 传入的美颜model
/// @param currentStorage currentStorage
-(NSArray <EFRenderModel *>*)_efGetAllBeautysTypeModelsLike:(id<EFDataSourcing>)targetModel from:(EFStatusModels *)currentStorage {
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"SELF.efRoute & %lx == %ud && (SELF.efAction == %ud || SELF.efAction == %ud || SELF.efAction == %ud)", _k1_mask, targetModel.efRoute & _k1_mask, EFRenderModelActionSelect, EFRenderModelActionStrengthChanged, EFRenderModelActionHighlightOnly];
    NSArray * result = [currentStorage.efCachedStatusModels filteredArrayUsingPredicate:filterPredicate];
    return result;
}

-(void)_efTransformFromTargetModel:(id<EFDataSourcing>)targetModel toRenderModelP:(EFRenderModel **)renderModelP {
    NSMutableDictionary * cachedDict = [(NSDictionary *)[(NSObject *)targetModel yy_modelToJSONObject] mutableCopy];
    *renderModelP = [EFRenderModel yy_modelWithDictionary:cachedDict];
    (*renderModelP).efAction = EFRenderModelActionSelect;
}

/// 判断当前model是否为贴纸
/// @param targetModel targetModel
static BOOL _efIsSticker(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue == 3;
}

/// 判断当前model是否为美妆
/// @param targetModel targetModel
static BOOL _efIsMakeup(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue >= 400 && realTypeValue < 500;
}

/// 判断当前model是否为滤镜
/// @param targetModel targetModel
static BOOL _efIsFilter(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue == 501;
}

/// 判断当前model是否为美颜
/// @param targetModel targetModel
static BOOL _efIsBeauty(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return (realTypeValue >= 100 && realTypeValue < 400) || (realTypeValue >= 600 && realTypeValue < 700) || (realTypeValue >= 800 && realTypeValue < 900);
}

/// 判断当前model是否为3d微整形
/// @param targetModel targetModel
static BOOL _efIs3DBeauty(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue == EFFECT_BEAUTY_3D_MICRO_PLASTIC;
}

/// 判断当前model是否为风格
/// @param targetModel targetModel
static BOOL _efIsStyle(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue == 4;
}

/// 判断当前model是否为通用物体跟踪
/// @param targetModel targetModel
static BOOL _efIsTrack(id<EFDataSourcing> targetModel) {
    NSUInteger realTypeValue = targetModel.efType >> 5;
    return realTypeValue == 66666;
}

/// 将[0, 1]强度转化为[-1, 1]强度（用以保存和渲染）
/// @param renderModel renderModel
/// @param originStrength originStrength
-(CGFloat)_efRenderModel:(EFRenderModel *)renderModel getStrengthFromUIStrength:(CGFloat)originStrength {
    NSUInteger realType = renderModel.efType >> 5;
    /**
     下巴303/额头304/长鼻307/嘴型309/缩人中310/眼距311/眼睛角度312
     */
    NSArray * specialTypes = self.efSpecialTypes;
    NSArray *sepecial3DNames = self.efSpecial3DNames;
    if ([specialTypes containsObject:@(realType)]
        || (realType == EFFECT_BEAUTY_3D_MICRO_PLASTIC && [sepecial3DNames containsObject:renderModel.efName])
        ) {
        return originStrength * 2 - 100;
    }
    return originStrength;
}

/// 将[-1, 1]强度转化为[0, 1]强度（用以UI展示）
/// @param renderModel renderModel
/// @param renderStrength renderStrength
-(CGFloat)_efRenderModel:(EFRenderModel *)renderModel restoreStrengthToUIStrength:(CGFloat)renderStrength {
    NSUInteger realType = renderModel.efType >> 5;
    /**
     下巴303/额头304/长鼻307/嘴型309/缩人中310/眼距311/眼睛角度312
     */
    CGFloat result = renderStrength;
    NSArray * specialTypes = self.efSpecialTypes;
    NSArray *sepecial3DNames = self.efSpecial3DNames;
    if ([specialTypes containsObject:@(realType)]
        || (realType == EFFECT_BEAUTY_3D_MICRO_PLASTIC && [sepecial3DNames containsObject:renderModel.efName])
        ) {
        result = (renderStrength + 100) / 2.0;
    }
    return result;
}

-(NSArray *)efSpecialTypes {
    if (!_efSpecialTypes) {
        _efSpecialTypes = @[@303, @304, @307, @309, @310, @311, @312,
                            //                            @(EFFECT_BEAUTY_3D_EYE_SCALE),
                            //                            @(EFFECT_BEAUTY_3D_EYE_HEIGHT),
                            //                            @(EFFECT_BEAUTY_3D_EYE_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_EYE_OUTER_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_EYE_DEPTH),
                            //                            @(EFFECT_BEAUTY_3D_EYE_LOWER_DEPTH),
                            //                            @(EFFECT_BEAUTY_3D_EYE_ANGLE),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_SCALE),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_HEIGHT),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_DEPTH),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_RIDGE_UPPER),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_RIDGE_CURVE),
                            //                            @(EFFECT_BEAUTY_3D_NOSE_TIP_HEIGHT),
                            //                            @(EFFECT_BEAUTY_3D_NOSTRIL_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_MOUTH_SCALE),
                            //                            @(EFFECT_BEAUTY_3D_MOUTH_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_MOUTH_HEIGHT),
                            //                            @(EFFECT_BEAUTY_3D_MOUTH_DEPTH),
                            //                            @(EFFECT_BEAUTY_3D_LIP_THIN),
                            //                            @(EFFECT_BEAUTY_3D_HEAD_SCALE),
                            //                            @(EFFECT_BEAUTY_3D_HEAD_OUTER_WIDTH),
                            //                            @(EFFECT_BEAUTY_3D_FACE_HEAVY),
                            //                            @(EFFECT_BEAUTY_3D_FACE_ANGLE),
                            //                            @(EFFECT_BEAUTY_3D_FACE_CENTER_DEPTH)
        ];
    }
    return _efSpecialTypes;
}

-(NSArray *)efSpecial3DNames {
    if (!_efSpecial3DNames) {
        _efSpecial3DNames = @[
            @"眼睛比例",
            @"眼高",
            @"眼距",
            @"外眼角",
            @"眼睛深浅",
            @"卧蚕深浅",
            @"眼睛角度",
            @"鼻子比例",
            @"鼻宽",
            @"鼻长",
            @"鼻高",
            @"鼻根",
            @"鼻子驼峰",
            @"鼻尖",
            @"鼻翼",
            @"嘴巴比例",
            @"嘴巴宽度",
            @"嘴巴高度",
            @"嘴巴深度",
            @"嘴巴厚度",
            @"头部比例",
            @"头部宽度",
            @"脸部胖瘦",
            @"脸部角度",
        ];
    }
    return _efSpecial3DNames;
}

@end
