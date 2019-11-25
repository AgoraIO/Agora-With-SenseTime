//
//  SenseTouchView.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseTouchView.h"
#import "STParamUtil.h"
#import "STCommonObjectContainerView.h"
#import "STCommonObjectView.h"

@interface SenseTouchView ()<UIGestureRecognizerDelegate> {
    UITapGestureRecognizer *_tapGesture;
}

@property (nonatomic, strong) NSTimer *ISOSliderTimer;

@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UISlider *ISOSlider;
@property (nonatomic) double currentTime;

@end

@implementation SenseTouchView

- (instancetype)init {
    if(self = [super init]){
        [self setDefaultValue];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaultValue];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = UIColor.clearColor;
    
    [self addSubview: self.focusImageView];
    [self addSubview: self.ISOSlider];
    
    [self addGestureRecoginzer];
}

- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusImageView.image = [UIImage imageNamed:@"camera_focus_red"];
        _focusImageView.alpha = 0;
    }
    return _focusImageView;
}

- (UISlider *)ISOSlider
{
    if (!_ISOSlider) {
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(0, 0, 200, 50);
        slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        slider.center= CGPointMake(SCREEN_WIDTH - 15, SCREEN_HEIGHT / 2);
        slider.maximumTrackTintColor = [UIColor whiteColor];
        slider.minimumTrackTintColor = [UIColor whiteColor];
        slider.hidden = YES;
        
        //resize image
        UIImage *imageOriginal = [UIImage imageNamed:@"亮度"];
        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
        [imageOriginal drawInRect:CGRectMake(0, 0, 40, 40)];
        imageOriginal = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [slider setThumbImage:imageOriginal forState:UIControlStateNormal];
        
        slider.minimumValue = 0;
        slider.maximumValue = 280;
        slider.value = 140;
        [slider addTarget:self action:@selector(ISOSliderValueChanging:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(ISOSliderValueDidChanged:) forControlEvents:UIControlEventTouchUpInside];
        _ISOSlider = slider;
    }
    return _ISOSlider;
}

- (void)ISOSliderValueChanging:(UISlider *)sender {
    self.currentTime = CFAbsoluteTimeGetCurrent();

    [self.senseTouchDelegate onTouchISOValueChange:sender.value];
}

- (void)ISOSliderValueDidChanged:(UISlider *)sender {
    self.currentTime = CFAbsoluteTimeGetCurrent();
}

- (void)setDefaultValue {
    self.ISOSliderTimer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!self.ISOSlider.isHidden && (CFAbsoluteTimeGetCurrent() - self.currentTime > 3.0)) {
            self.ISOSlider.hidden = YES;
        }
    }];
}

- (void)addGestureRecoginzer {
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    _tapGesture.delegate = self;
    
    [self addGestureRecognizer:_tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    
    CGPoint point = [tapGesture locationInView:self];
    
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1.0;
    
    self.ISOSlider.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.focusImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusImageView.alpha = 0;
    }];
    
    self.currentTime = CFAbsoluteTimeGetCurrent();
    
    [self.senseTouchDelegate onTouchExposurePointChange:point];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([touch.view isKindOfClass:[STCommonObjectView class]]) {
       return NO;
    }
    return YES;
}

- (void)releaseResources {
    // remove Recognizer
    if ([self.ISOSliderTimer isValid]) {
        [self.ISOSliderTimer invalidate];
    }

    [self removeGestureRecognizer:_tapGesture];
}

@end
