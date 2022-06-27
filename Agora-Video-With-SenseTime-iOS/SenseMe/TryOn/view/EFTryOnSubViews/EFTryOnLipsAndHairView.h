//
//  EFTryOnLipsAndHairView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "st_mobile_effect.h"
#import "TryOnDataElement.h"

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnLipsAndHairView;

@protocol EFTryOnLipsAndHairViewDelegate <NSObject>

@optional
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView onTinting:(NSInteger)index;
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView selectedModel:(EFRenderModel *)renderModel withTryonType:(st_effect_beauty_type_t)tryonType;
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView selectedColorModel:(EFRenderModel *)renderModel withTryonType:(st_effect_beauty_type_t)tryonType;
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowColorStrength:(BOOL)isShow;
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowBrightnessStrength:(BOOL)isShow;
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowHairColorStrength:(BOOL)isShow;
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowHairStrength:(BOOL)isShow;
//

/// 选中了try on素材包
/// @param tryonView tryonView
/// @param material 素材包model
/// @param beautyType try on type
-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView selectedMaterial:(SenseArMaterial *)material andBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(id<TryOnDataElementInterface>)dataSource;

/// 取消指定try on效果
/// @param tryonView tryonView
/// @param beautyType try on type
-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView cancelTryOnBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(id<TryOnDataElementInterface>)dataSource;

/// 修改try on info后回调
/// @param tryonView tryonView
/// @param tryOnBeautyInfo 修改后的try on info
-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType;

-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView isShowColorWheel:(BOOL)isShow andDatasource:(id<TryOnDataElementInterface>)dataSource;
-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView showToast:(NSString *)toast;

@end

@interface EFTryOnLipsAndHairView : UIView

@property (nonatomic, strong) id<TryOnDataElementInterface> dataSource;
@property (nonatomic, weak) id<EFTryOnLipsAndHairViewDelegate> delegate;
@property (nonatomic, assign) st_effect_beauty_type_t tryonType;
@property (nonatomic, assign) st_effect_lipstick_finish_t lipstick; // 设置口红质地（get出来后反馈到ui）

@end

NS_ASSUME_NONNULL_END
