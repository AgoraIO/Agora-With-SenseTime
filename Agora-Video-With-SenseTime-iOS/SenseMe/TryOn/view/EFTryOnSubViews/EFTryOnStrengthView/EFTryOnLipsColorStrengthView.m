//
//  EFTryOnLipsColorStrengthView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnLipsColorStrengthView.h"
#import "EFBeautySlider.h"

@interface EFTryOnLipsColorStrengthView ()

@property (nonatomic, strong) EFBeautySlider * saturationSlider;

@end

@implementation EFTryOnLipsColorStrengthView
{
    UILabel * _titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"强度";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = UIColor.whiteColor;
    [self addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).inset(30);
        make.bottom.equalTo(self).inset(5);
    }];
    
    [self addSubview:self.saturationSlider];
    [self.saturationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_titleLabel.mas_trailing).offset(20);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.trailing.equalTo(self).inset(30);
    }];
}

-(EFBeautySlider *)saturationSlider {
    if (!_saturationSlider) {
        _saturationSlider = [[EFBeautySlider alloc] init];
        _saturationSlider.minimumTrackTintColor = UIColor.whiteColor;
        _saturationSlider.maximumTrackTintColor = UIColor.whiteColor;
        _saturationSlider.value = 0.8f;
        _saturationSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", _saturationSlider.value * 100];
        [_saturationSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_saturationSlider addTarget:self action:@selector(onLipsColorSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _saturationSlider;
}

#pragma mark - slider actions
-(void)onLipsColorSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value * 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnLipsColorStrengthView:sliderValueChanged:)]) {
        [self.delegate tryOnLipsColorStrengthView:self sliderValueChanged:sender.value];
    }
}

#pragma mark - properties
-(void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

-(void)setValue:(CGFloat)value {
    _value = value;
    self.saturationSlider.value = value;
    self.saturationSlider.valueLabel.text = [NSString stringWithFormat:@"%.0f", value * 100];
}

@end
