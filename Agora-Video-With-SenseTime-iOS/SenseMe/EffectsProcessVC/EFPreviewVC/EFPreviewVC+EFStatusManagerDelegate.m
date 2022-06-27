//
//  EFPreviewVC+EFStatusManagerDelegate.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/28.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFPreviewVC+EFStatusManagerDelegate.h"
#import "EFGlobalSingleton.h"
#import "EffectsImageUtils.h"

@implementation EFPreviewVC (EFStatusManagerDelegate)

#pragma mark - EFStatusManagerDelegate
-(void)efStatusManager:(EFStatusManager *)statusManager statusChanged:(EFRenderModel *)renderModel {
    struct EFDatasourceTypeStruct typeStruct = efConvertType(renderModel.efType);
    NSUInteger realTypeValue = typeStruct.real_type;
    BOOL hasPath = typeStruct.has_path;
    NSUInteger mode = typeStruct.has_mode;
    NSUInteger specialMode = 0;
    if (mode > 0) {
        specialMode = typeStruct.mode_type;
    };
    
    if (realTypeValue == 3) { // 贴纸
        if ((renderModel.efRoute & _k12_mask) == 67698688) { // 通用物体跟踪
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageNamed:renderModel.efName];
                [self addCommonObject:image filePath:nil];
            });
        } else {
            if (renderModel.efAction == EFRenderModelActionSelect) {
                weakSelf(self)
                
                [self.effectsProcess addStickerWithPath:renderModel.efPath callBackCustomEventIncluded:^(st_result_t state, int stickerId, uint64_t action, uint64_t customEvent) {
                    renderModel.efId = stickerId;
                    [weakself showTriggerAction:action andCustomAction:customEvent];
                    if ([renderModel.efStickerId isEqualToString:@"20211221152305770599802"]) {
                        weakself.packageID = stickerId;
                    } else {
                        weakself.packageID = -1;
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.showPhotoStripView = [renderModel.efStickerId isEqualToString:@"20211221152305770599802"];
                });
            } else {
                [self.effectsProcess removeSticker:(int)renderModel.efId];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.showPhotoStripView = NO;
                });
                
                self.packageID = -1;
            }
        }
    } else if (realTypeValue == 4) { // 风格
        if (renderModel.efAction == EFRenderModelActionSelect) {
            __weak typeof(self) weakself = self;
            DLog(@"%@", renderModel.efName);
            [self.effectsProcess addStickerWithPath:renderModel.efPath callBack:^(st_result_t state, int stickerId, uint64_t action) {
                renderModel.efId = stickerId;
                __strong typeof(weakself) strongself = weakself;
                NSUInteger strength = renderModel.efStrength;
                CGFloat filterStrength = strength >> 8;
                CGFloat makeupStrength = strength & 0b11111111;
                [strongself.effectsProcess setPackageId:(int)renderModel.efId groupType:EFFECT_BEAUTY_GROUP_FILTER strength:filterStrength / 100.0];
                [strongself.effectsProcess setPackageId:(int)renderModel.efId groupType:EFFECT_BEAUTY_GROUP_MAKEUP strength:makeupStrength / 100.0];
                if (!strongself._isNotFirst) {
                    strongself._isNotFirst = YES;
                }
            }];
            
        } else if (renderModel.efAction == EFRenderModelActionStrengthChanged) {
            NSUInteger strength = renderModel.efStrength;
            CGFloat filterStrength = strength >> 8;
            CGFloat makeupStrength = strength & 0b11111111;
            DLog(@"%f", filterStrength);
            DLog(@"%f", makeupStrength);
            [self.effectsProcess setPackageId:(int)renderModel.efId groupType:EFFECT_BEAUTY_GROUP_FILTER strength:filterStrength / 100.0];
            [self.effectsProcess setPackageId:(int)renderModel.efId groupType:EFFECT_BEAUTY_GROUP_MAKEUP strength:makeupStrength / 100.0];

        } else {
            [self.effectsProcess removeSticker:(int)renderModel.efId];
        }
    }
    else if (realTypeValue == EFFECT_BEAUTY_3D_MICRO_PLASTIC) { // 3D微整形
        if (renderModel.efAction == EFRenderModelActionDeselect) { // 取消逻辑
            int val;
            st_result_t get3dResult = [self.effectsProcess get3dBeautyPartsSize:&val];
            if (get3dResult != ST_OK) {
                return;
            }
            st_effect_3D_beauty_part_info_t parts[val];
            get3dResult = [self.effectsProcess get3dBeautyParts:parts fromSize:val];
            int index = [self getCurrent3DBeautyInfoIndexFrom:parts andCount:val byRenderModel:renderModel];
            st_effect_3D_beauty_part_info_t current = parts[index];
            current.strength = renderModel.efStrength / 100.0;
            DLog(@"%@ - %f", renderModel.efName, renderModel.efStrength / 100.0);
            parts[index] = current;
            [self.effectsProcess set3dBeautyPartsStrength:parts andVal:val];
        } else {
            int val;
            st_result_t get3dResult = [self.effectsProcess get3dBeautyPartsSize:&val];
            
            st_effect_3D_beauty_part_info_t parts[val];
            get3dResult = [self.effectsProcess get3dBeautyParts:parts fromSize:val];
            
            int index = [self getCurrent3DBeautyInfoIndexFrom:parts andCount:val byRenderModel:renderModel];
            st_effect_3D_beauty_part_info_t current = parts[index];
            current.strength = renderModel.efStrength / 100.0;
            parts[index] = current;
            [self.effectsProcess f_set3dBeautyPartsStrength:parts andVal:val];
        }
    }
    else { // 滤镜、美妆、美颜
        if (renderModel.efAction == EFRenderModelActionDeselect) { // 取消逻辑
            [self.effectsProcess setEffectType:(st_effect_beauty_type_t)realTypeValue path:nil];
            [self.effectsProcess setEffectType:(st_effect_beauty_type_t)realTypeValue value:renderModel.efStrength / 100.0];
            
            if ([renderModel.efName isEqualToString:@"美白3"] && [EFGlobalSingleton sharedInstance].efHasSegmentCapability) {
                [self.effectsProcess setBeautyParam:EFFECT_BEAUTY_PARAM_ENABLE_WHITEN_SKIN_MASK andVal:0];
            }
        } else {
            if (mode) {
                [self.effectsProcess setEffectType:(st_effect_beauty_type_t)realTypeValue model:(int)specialMode];
            }
            if (hasPath && (renderModel.efAction == EFRenderModelActionSelect || renderModel.efAction == EFRenderModelActionUnactive)) {
                [self.effectsProcess setEffectType:(st_effect_beauty_type_t)realTypeValue path:renderModel.efPath];
            }
            
            if ([renderModel.efName isEqualToString:@"美白3"] && (renderModel.efAction == EFRenderModelActionSelect || renderModel.efAction == EFRenderModelActionUnactive || renderModel.efAction == EFRenderModelActionEffectsOnly)) { // 开始皮肤分割
                [self.effectsProcess setBeautyParam:EFFECT_BEAUTY_PARAM_ENABLE_WHITEN_SKIN_MASK andVal:1];
            }
            
            DLog(@"%@ - %d - %f", renderModel.efName, realTypeValue, renderModel.efStrength / 100.0);
            [self.effectsProcess setEffectType:(st_effect_beauty_type_t)realTypeValue value:(realTypeValue==EFFECT_BEAUTY_MAKEUP_HAIR_DYE) ? renderModel.efStrength / 100.0 * 0.22 : renderModel.efStrength / 100.0];
        }
    }
}

-(void)efStatusManager:(EFStatusManager *)statusManager set3DBeauties:(NSArray <EFRenderModel *> *)renderModels isClear:(BOOL)isClear {
    int val;
    st_result_t get3dResult = [self.effectsProcess get3dBeautyPartsSize:&val];
    st_effect_3D_beauty_part_info_t parts[val];
    get3dResult = [self.effectsProcess get3dBeautyParts:parts fromSize:val];
    for (EFRenderModel *renderModel in renderModels) {
        int index = [self getCurrent3DBeautyInfoIndexFrom:parts andCount:val byRenderModel:renderModel];
        st_effect_3D_beauty_part_info_t current = parts[index];
        current.strength = renderModel.efStrength / 100.0;
        parts[index] = current;
    }
    [self.effectsProcess set3dBeautyPartsStrength:parts andVal:val];
}

-(NSArray <NSDictionary *>*)efStatusManagerGetOverlapValues:(EFStatusManager *)statusManager {
    int count = 0;
    st_effect_beauty_info_t * beauty_info = [self.effectsProcess getOverlapInfo:&count];
    if (!beauty_info) return nil;
    NSMutableArray * result = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        st_effect_beauty_info_t item = beauty_info[i];
        NSDictionary * info = @{
            @"name": [NSString stringWithFormat:@"%s", item.name],
            @"type": @(item.type),
            @"strength": @(item.strength),
            @"mode": @(item.mode)
        };
        [result addObject:info];
    }
    free(beauty_info);
    return result;
}

#pragma mark - 渲染层api调用

@end
