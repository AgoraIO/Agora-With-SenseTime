//
//  STBeautySlider.h
//  SenseMeEffects
//
//  Created by Sunshine on 2019/2/11.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STBeautySliderDelegate <NSObject>

- (CGFloat)currentSliderValue:(float)value slider:(UISlider *)slider;

@end

NS_ASSUME_NONNULL_BEGIN

@interface STBeautySlider : UISlider

@property (nonatomic, weak) id<STBeautySliderDelegate> delegate;
@property (nonatomic, strong) UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
