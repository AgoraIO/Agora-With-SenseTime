//
//  EFTryOnColorWheelView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/19.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TryOnDataElementInterface.h"

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnColorWheelView;

@protocol EFTryOnColorWheelViewDelegate <NSObject>

/// 修改try on info后回调
/// @param tryonView tryonView
/// @param tryOnBeautyInfo 修改后的try on info
-(void)tryOnColorWheelView:(EFTryOnColorWheelView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType;

-(void)tryOnColorWheelViewCanceled:(EFTryOnColorWheelView *)tryOnColorWheelView;

@end

@interface EFTryOnColorWheelView : UIView

-(instancetype)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation andBrightness:(CGFloat)brightness;

@property (nonatomic, weak) id<EFTryOnColorWheelViewDelegate> delegate;
@property (nonatomic, strong) id<TryOnDataElementInterface> dataSource;

@end

NS_ASSUME_NONNULL_END
