//
//  STPlayerControlBar.h
//  SenseMeEffects
//
//  Created by Sunshine on 2018/5/23.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPlayerControlBar : UIView

@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *totalTimeLabel;

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;


@end
