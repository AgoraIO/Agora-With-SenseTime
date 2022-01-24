//
//  STPlayerControlBar.m
//  SenseMeEffects
//
//  Created by Sunshine on 2018/5/23.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "STPlayerControlBar.h"

@implementation STPlayerControlBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.progressView];
    [self addSubview:self.totalTimeLabel];
    
    self.currentTimeLabel.frame = CGRectMake(0, 0, 43, self.bounds.size.height);
    self.totalTimeLabel.frame = CGRectMake(self.bounds.size.width - 43, 0, 43, self.bounds.size.height);
    self.progressView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame),
                                         self.bounds.size.height / 2 - 1,
                                         CGRectGetMinX(self.totalTimeLabel.frame) - CGRectGetMaxX(self.currentTimeLabel.frame),
                                         self.bounds.size.height);
    
    self.currentTimeLabel.text = @"00:00";
    self.totalTimeLabel.text = @"00:00";
}

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    // 更新slider
    self.progressView.progress = value;
    // 更新当前播放时间
    self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _progressView.trackTintColor    = [UIColor blackColor];
    }
    return _progressView;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

@end
