//
//  EFTryOnLipsColorStrengthView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnLipsColorStrengthView;

@protocol EFTryOnLipsColorStrengthViewDelegate <NSObject>

-(void)tryOnLipsColorStrengthView:(EFTryOnLipsColorStrengthView *)tryOnLipsColorStrengthView sliderValueChanged:(CGFloat)value;

@end

@interface EFTryOnLipsColorStrengthView : UIView

@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, weak) id<EFTryOnLipsColorStrengthViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
