//
//  STBeautySlider.h
//  SenseMeEffects
//
//  Created by Sunshine on 2019/2/11.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EFBeautySliderDelegate <NSObject>

- (CGFloat)currentSliderValue:(float)value slider:(UISlider *_Nullable)slider;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EFBeautySlider : UISlider

@property (nonatomic, weak) id<EFBeautySliderDelegate> delegate;
@property (nonatomic, strong) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
