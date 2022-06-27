//
//  EFTryOnHairStrengthView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/26.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnHairStrengthView.h"
#import "EFBeautySlider.h"

@interface EFTryOnHairStrengthView ()

@property (nonatomic, strong) EFBeautySlider * strengthSlider;
@property (nonatomic, strong) EFBeautySlider * brightnessSlider;
@property (nonatomic, strong) EFBeautySlider * graynessSlider;

@end

static NSInteger const efHairButtonBaseTagValue = 916291;

@implementation EFTryOnHairStrengthView
{
    NSMutableArray * _buttons;
    UIButton * _currentSelectedButton;
    EFBeautySlider * _currentSlider;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    _buttons = [NSMutableArray array];
    
    NSArray * buttonTitles = @[@"强度", @"光泽度", @"灰白度"];
    
    for (NSInteger i = 0; i < buttonTitles.count; i ++) {
        UIButton * strengthButton = [self generateDefaultButtonBy:buttonTitles[i]];
        strengthButton.tag = efHairButtonBaseTagValue + i;
        [self addSubview:strengthButton];
        
        if (i == 0) {
            [strengthButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@50);
                make.height.equalTo(@30);
                make.leading.equalTo(self).inset(10);
                make.bottom.equalTo(self);
            }];
        } else {
            UIButton * lastButton = _buttons.lastObject;
            [strengthButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(lastButton);
                make.height.equalTo(lastButton);
                make.leading.equalTo(lastButton.mas_trailing).inset(5);
                make.bottom.equalTo(lastButton);
            }];
        }
        [_buttons addObject:strengthButton];
    }
    
    UIButton * lastButton = _buttons.lastObject;
    
    [self addSubview:self.strengthSlider];
    self.strengthSlider.hidden = YES;
    [self.strengthSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lastButton.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.trailing.equalTo(self).inset(20);
    }];
    
    [self addSubview:self.brightnessSlider];
    self.brightnessSlider.hidden = YES;
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lastButton.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.trailing.equalTo(self).inset(20);
    }];
    
    [self addSubview:self.graynessSlider];
    self.graynessSlider.hidden = YES;
    [self.graynessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lastButton.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.trailing.equalTo(self).inset(20);
    }];
    
    [self onButtonClick:_buttons.firstObject];
}

-(UIButton *)generateDefaultButtonBy:(NSString *)title {
    UIButton * defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [defaultButton setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [defaultButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    defaultButton.titleLabel.font = [UIFont systemFontOfSize:11];
    defaultButton.layer.cornerRadius = 15;
    defaultButton.clipsToBounds = YES;
    [defaultButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return defaultButton;
}

#pragma mark - properties
-(EFBeautySlider *)strengthSlider {
    if (!_strengthSlider) {
        _strengthSlider = [[EFBeautySlider alloc] init];
        _strengthSlider.minimumTrackTintColor = UIColor.whiteColor;
        _strengthSlider.maximumTrackTintColor = UIColor.whiteColor;
        _strengthSlider.value = 0.6f;
        _strengthSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", _strengthSlider.value * 100];
        [_strengthSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_strengthSlider addTarget:self action:@selector(onStrengthSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _strengthSlider;
}

-(EFBeautySlider *)brightnessSlider {
    if (!_brightnessSlider) {
        _brightnessSlider = [[EFBeautySlider alloc] init];
        _brightnessSlider.minimumTrackTintColor = UIColor.whiteColor;
        _brightnessSlider.maximumTrackTintColor = UIColor.whiteColor;
        _brightnessSlider.value = 0.7f;
        _brightnessSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", _brightnessSlider.value * 100];
        [_brightnessSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_brightnessSlider addTarget:self action:@selector(onBrightnessSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _brightnessSlider;
}

-(EFBeautySlider *)graynessSlider {
    if (!_graynessSlider) {
        _graynessSlider = [[EFBeautySlider alloc] init];
        _graynessSlider.minimumTrackTintColor = UIColor.whiteColor;
        _graynessSlider.maximumTrackTintColor = UIColor.whiteColor;
        _graynessSlider.value = 0.8f;
        _graynessSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", _graynessSlider.value * 100];
        [_graynessSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_graynessSlider addTarget:self action:@selector(onGraynessSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _graynessSlider;
}

-(void)setStrength:(CGFloat)strength {
    _strength = strength;
    self.strengthSlider.value = strength;
    self.strengthSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", strength * 100];
}

-(void)setBrightness:(CGFloat)brightness {
    _brightness = brightness;
    self.brightnessSlider.value = brightness;
    self.brightnessSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", brightness * 100];
}

-(void)setGrayness:(CGFloat)grayness {
    _grayness = grayness;
    self.graynessSlider.value = grayness;
    self.graynessSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", grayness * 100];
}

#pragma mark - slider actions
-(void)onStrengthSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value * 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnHairStrengthView:strengthChanged:)]) {
        [self.delegate tryOnHairStrengthView:self strengthChanged:sender.value];
    }
}

-(void)onBrightnessSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value * 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnHairStrengthView:brightnessChanged:)]) {
        [self.delegate tryOnHairStrengthView:self brightnessChanged:sender.value];
    }
}

-(void)onGraynessSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value * 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnHairStrengthView:graynessChanged:)]) {
        [self.delegate tryOnHairStrengthView:self graynessChanged:sender.value];
    }
}

#pragma mark - button actions
-(void)onButtonClick:(UIButton *)sender {
    if (_currentSelectedButton) {
        [_currentSelectedButton setBackgroundColor:UIColor.clearColor];
    }
    
    if (_currentSlider) {
        _currentSlider.hidden = YES;
    }
    
    [sender setBackgroundColor:UIColor.lightGrayColor];
    _currentSelectedButton = sender;
    
    NSUInteger buttonTag = sender.tag - efHairButtonBaseTagValue;
    if (buttonTag == 0) {
        self.strengthSlider.hidden = NO;
        _currentSlider = self.strengthSlider;
    } else if (buttonTag == 1) {
        self.brightnessSlider.hidden = NO;
        _currentSlider = self.brightnessSlider;
    } else if (buttonTag == 2) {
        self.graynessSlider.hidden = NO;
        _currentSlider = self.graynessSlider;
    }
}

@end
