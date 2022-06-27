//
//  EFTryOnViewController+tryonViewDelegate.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/10.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "EFTryOnViewController+tryonViewDelegate.h"
#import "TryOnBeautyDataElement.h"

@implementation EFTryOnViewController (tryonViewDelegate)

#pragma mark - EFTryOnViewDelegate
-(void)tryOnShotBy:(UIView *)tryOnView { // 拍照 保存到相册
    self.bTakePhoto = YES;
}

/// 选中美颜
/// @param tryOnView tryOnView description
/// @param model model description
-(void)tryOnView:(EFTryOnView *)tryOnView beautySelected:(id<TryOnBeautyItemInterface>)model {
    if (![model isKindOfClass:[TryOnBeautyItem class]]) {
        return;
    }
    TryOnBeautyItem *beautyItem = (TryOnBeautyItem *)model;
    NSArray<TryOnBeautyParam *> *params = beautyItem.params;
    if (params) {
        for (TryOnBeautyParam *param in params) {
            if (param.mode) {
                [self.effectsProcess setEffectType:param.type model:param.mode];
            }
            if (param.path) {
                [self.effectsProcess setEffectType:param.type path:param.path];
            }
            if (param.otherBeautyParam) {
                [self.effectsProcess setBeautyParam:param.otherBeautyParam andVal:1];
            }
            [self.effectsProcess setEffectType:param.type value:param.strength / 100.0];
        }
    }
}

/// 反选美颜
/// @param tryOnView tryOnView description
/// @param model model description
-(void)tryOnView:(EFTryOnView *)tryOnView beautyDeselected:(id<TryOnBeautyItemInterface>)model {
    if (![model isKindOfClass:[TryOnBeautyItem class]]) {
        return;
    }
    TryOnBeautyItem *beautyItem = (TryOnBeautyItem *)model;
    NSArray<TryOnBeautyParam *> *params = beautyItem.params;
    if (params) {
        for (TryOnBeautyParam *param in params) {
            if (param.path) {
                [self.effectsProcess setEffectType:param.type path:nil];
            }
            if (param.otherBeautyParam) {
                [self.effectsProcess setBeautyParam:param.otherBeautyParam andVal:0];
            }
            [self.effectsProcess setEffectType:param.type value:0];
        }
    }
}

/// 切换try on素材包
/// @param tryonView tryonView description
/// @param material 素材包model
/// @param beautyType try on beauty type
-(void)tryOnView:(EFTryOnView *)tryonView selectedMaterial:(SenseArMaterial *)material andBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(nonnull id<TryOnDataElementInterface>)dataSource {
    [self.effectsProcess setEffectType:beautyType path:material.strMaterialPath];
    [self getTryonInfoBy:beautyType andDataSource:dataSource];
}

/// 取消指定try on效果
/// @param tryonView tryonView description
/// @param beautyType 需取消的try on type
-(void)tryOnView:(EFTryOnView *)tryonView cancelTryOnBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(nonnull id<TryOnDataElementInterface>)dataSource {
    [self.effectsProcess setEffectType:beautyType path:nil];
    dataSource.tryonInfo = nil;
}

#pragma mark - 获取tryon参数
-(void)getTryonInfoBy:(st_effect_beauty_type_t)tryonType andDataSource:(id<TryOnDataElementInterface>)dataSource {
    if (!dataSource.tryonInfo) {
        dataSource.tryonInfo = malloc(sizeof(st_effect_tryon_info_t));
    }
    [self.effectsProcess getTryon:dataSource.tryonInfo andTryonType:tryonType];
}

/// 修改try on info后回调
/// @param tryonView tryonView
/// @param tryOnBeautyInfo 修改后的try on info
-(void)tryOnView:(EFTryOnView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType {
    [self.effectsProcess setTryon:tryOnBeautyInfo andTryonType:beautyType];
}

-(void)tryOnView:(UIView *)tryOnView showToast:(NSString *)toast {
    [self toast:toast];
}

@end
