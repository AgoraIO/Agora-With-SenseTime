//
//  STBmpStrengthView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/13.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STBmpStrengthViewDelegate <NSObject>

- (void)sliderValueDidChange:(float)value;

@end

@interface STBmpStrengthView : UIView

@property (nonatomic, weak) id<STBmpStrengthViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateSliderValue:(float)value;

@end

