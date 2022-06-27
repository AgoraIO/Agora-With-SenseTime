//
//  EFColorWheelView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/19.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@class EFColorWheelView;

@protocol EFColorWheelViewDelegate <NSObject>

-(void)onColorWheelView:(EFColorWheelView *)wheelView hueValue:(CGFloat)hue;

@end

@interface EFColorWheelView : UIControl

/**
 *  The hue value.
 */
@property (nonatomic, assign) CGFloat hue;

/**
 *  The saturation value.
 */
@property (nonatomic, assign) CGFloat saturation;

@property (nonatomic, readwrite, weak) id<EFColorWheelViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
