//
//  EFTryOnView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "st_mobile_effect.h"
#import "EFTryOnDatasourceManager.h"

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnView;

@protocol EFTryOnViewDelegate <NSObject>

@optional
-(void)tryOnShotBy:(EFTryOnView *)tryOnView;
-(void)tryOnView:(EFTryOnView *)tryOnView beautySelected:(id<TryOnBeautyItemInterface>)model;
-(void)tryOnView:(EFTryOnView *)tryOnView beautyDeselected:(id<TryOnBeautyItemInterface>)model;
-(void)tryOnView:(EFTryOnView *)tryOnView lipsOrHairSelected:(EFRenderModel *)model withTryonType:(st_effect_beauty_type_t)tryonType;
-(void)tryOnView:(EFTryOnView *)tryOnView colorModelSelected:(EFRenderModel *)model withTryonType:(st_effect_beauty_type_t)tryonType;
-(void)tryOnView:(EFTryOnView *)tryOnView colorChanged:(UIColor *)color withTryonType:(st_effect_beauty_type_t)tryonType;
-(void)tryOnView:(EFTryOnView *)tryOnView isShowColorStrength:(BOOL)isShow;
-(void)tryOnView:(EFTryOnView *)tryOnView isShowBrightnessStrength:(BOOL)isShow;
-(void)tryOnView:(EFTryOnView *)tryOnView isShowHairColorStrength:(BOOL)isShow;
-(void)tryOnView:(EFTryOnView *)tryOnView isShowHairStrength:(BOOL)isShow;


-(UIColor *)tryOnView:(EFTryOnView *)tryOnView updateColorWheelBy:(st_effect_beauty_type_t)tryonType;

// new
/// 选中try on素材包
/// @param tryonView tryonView description
/// @param material try on素材包
/// @param beautyType type
-(void)tryOnView:(EFTryOnView *)tryonView selectedMaterial:(SenseArMaterial *)material andBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(id<TryOnDataElementInterface>)dataSource;

/// 取消指定try on效果
/// @param tryonView tryonView description
/// @param beautyType 需取消的try on type
-(void)tryOnView:(EFTryOnView *)tryonView cancelTryOnBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(id<TryOnDataElementInterface>)dataSource;

/// 修改try on info后回调
/// @param tryonView tryonView
/// @param tryOnBeautyInfo 修改后的try on info
-(void)tryOnView:(EFTryOnView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType;

-(void)tryOnView:(EFTryOnView *)tryOnView showToast:(NSString *)toast;

@end

@interface EFTryOnView : UIView

@property (nonatomic, weak) id<EFTryOnViewDelegate> delegate;
@property (nonatomic, assign) st_effect_lipstick_finish_t lipstick; // 设置口红质地（get出来后反馈到ui）
@property (nonatomic, assign) NSInteger currentTryonBeauty; // 手动设置tryon美颜素材

-(instancetype)initWithFrame:(CGRect)frame andDatasource:(EFTryOnDatasourceManager *)datasourceModel;

@end

NS_ASSUME_NONNULL_END
