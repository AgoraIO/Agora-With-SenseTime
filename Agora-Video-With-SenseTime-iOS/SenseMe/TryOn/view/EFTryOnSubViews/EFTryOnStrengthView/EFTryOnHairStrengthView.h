//
//  EFTryOnHairStrengthView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/26.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnHairStrengthView;

@protocol EFTryOnHairStrengthViewDelegate <NSObject>

-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView strengthChanged:(CGFloat)strength;
-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView brightnessChanged:(CGFloat)strength;
-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView graynessChanged:(CGFloat)strength;

@end

@interface EFTryOnHairStrengthView : UIView

@property (nonatomic, weak) id<EFTryOnHairStrengthViewDelegate> delegate;

@property (nonatomic, assign) CGFloat strength;
@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat grayness;

@end

NS_ASSUME_NONNULL_END
