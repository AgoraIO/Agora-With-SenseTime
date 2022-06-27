//
//  EFTryOnColorWheelView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/19.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnColorWheelView.h"
#import "EFColorWheelView.h"
#import "EFBeautySlider.h"
#import "EFTryOnLipsColorStrengthView.h"
#import "EFTryOnHairStrengthView.h"
#import "EFTryOnSegmentView.h"

@interface EFTryOnColorWheelView () <EFColorWheelViewDelegate, EFTryOnLipsColorStrengthViewDelegate, EFTryOnHairStrengthViewDelegate, EFTryOnSegmentViewDelegate>

@property (nonatomic, strong) EFBeautySlider * saturationSlider;
@property (nonatomic, strong) EFBeautySlider * brightnessSlider;
@property (nonatomic, strong) CAGradientLayer * saturationGradientLayer;
@property (nonatomic, strong) CAGradientLayer * brightnessGradientLayer;

@property (nonatomic, strong) UIView * saturationBackgroundView;
@property (nonatomic, strong) UIView * brightnessBackgroundView;

@property (nonatomic, strong) UIView *trickBackgroundView;

@property (nonatomic, strong) EFTryOnLipsColorStrengthView *strengthView;
@property (nonatomic, strong) EFTryOnHairStrengthView *hairColorStrenthView; // 染发特有强度view [@"强度", @"光泽度", @"灰白度"]调节

@property (nonatomic, strong) EFTryOnSegmentView *segmentView;

@property (nonatomic, assign) int currentRegionIndex;

@end

@implementation EFTryOnColorWheelView
{
    CGFloat _currentHueValue;
    CGFloat _currentSaturationValue;
    CGFloat _currentBrightnessValue;
    
    EFColorWheelView * _cv;
}

-(instancetype)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation andBrightness:(CGFloat)brightness {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _currentHueValue = hue;
        _currentSaturationValue = saturation;
        _currentBrightnessValue = brightness;
        
        [self customSubViews];
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubViews];
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

-(void)customSubViews {
    [self addSubview:self.strengthView];
    self.strengthView.hidden = YES;
    self.strengthView.delegate = self;
    [self.strengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    self.trickBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.trickBackgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.trickBackgroundView];
    
    [self.trickBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@206);
    }];
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"tryon_tinting_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).inset(13);
        make.top.equalTo(self).inset(90);
        make.height.width.equalTo(@32);
    }];
    
    self.segmentView = [[EFTryOnSegmentView alloc] initWithFrame:CGRectZero];
    self.segmentView.delegate = self;
    [self addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backButton);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self).inset(20);
        make.height.equalTo(@44);
    }];
    
    _cv = [[EFColorWheelView alloc] init];
    _cv.hue = _currentHueValue;
    _cv.saturation = 0.8;
    _cv.delegate = self;
    [self addSubview:_cv];
    [_cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).inset(50);
        make.leading.equalTo(backButton.mas_trailing).inset(13);
        make.height.width.equalTo(@130);
    }];
    
    
    [self addSubview:self.brightnessSlider];
    [self.brightnessSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_cv.mas_trailing).inset(20);
        make.top.equalTo(_cv).inset(10);
        make.trailing.equalTo(self).inset(20);
        make.height.equalTo(@40);
    }];
    
    self.brightnessBackgroundView = [[UIView alloc] init];
    self.brightnessBackgroundView.backgroundColor = UIColor.grayColor;
    [self insertSubview:self.brightnessBackgroundView belowSubview:self.brightnessSlider];
    
    [self.brightnessBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.brightnessSlider);
        make.centerY.equalTo(self.brightnessSlider).offset(10);
        make.height.equalTo(@5);
    }];
    
    [self.brightnessBackgroundView.layer addSublayer:self.brightnessGradientLayer];
    
    
    [self addSubview:self.saturationSlider];
    [self.saturationSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.brightnessSlider);
        make.bottom.equalTo(_cv).inset(10);
        make.trailing.equalTo(self.brightnessSlider);
        make.height.equalTo(self.brightnessSlider);
    }];
    
    self.saturationBackgroundView = [[UIView alloc] init];
    self.saturationBackgroundView.backgroundColor = UIColor.grayColor;
    [self insertSubview:self.saturationBackgroundView belowSubview:self.saturationSlider];
    
    [self.saturationBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.saturationSlider);
        make.centerY.equalTo(self.saturationSlider).offset(10);
        make.height.equalTo(@5);
    }];
    
    [self.saturationBackgroundView.layer addSublayer:self.saturationGradientLayer];
    
    [self layoutIfNeeded];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateSliders];
    });
}

-(void)updateColorSpace {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelView:updateTryOnInfo:withBeautyType:)]) {
        UIColor *color = [UIColor colorWithHue:_currentHueValue saturation:self.saturationSlider.value brightness:self.brightnessSlider.value alpha:1];
        const CGFloat * components = CGColorGetComponents(color.CGColor);
        st_color_t stColor = (st_color_t){components[0] * 255.0, components[1] * 255.0, components[2] * 255.0, 1};
        int regionCount = self.dataSource.tryonInfo -> region_count;
        if (regionCount > 0) { // 修改的是region color
            self.dataSource.tryonInfo -> region_info[self.currentRegionIndex].color = stColor;
        } else { // 修改的是整体color
            self.dataSource.tryonInfo -> color = stColor;
        }
        [self.delegate tryOnColorWheelView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

-(void)updateSliders {
    self.brightnessGradientLayer.frame = self.brightnessBackgroundView.bounds;
    self.brightnessGradientLayer.colors = @[(id)[UIColor colorWithHue:_currentHueValue saturation:1 brightness:0 alpha:1].CGColor,(id)[UIColor colorWithHue:_currentHueValue saturation:1 brightness:1 alpha:1].CGColor];
    
    self.saturationGradientLayer.frame = self.saturationBackgroundView.bounds;
    self.saturationGradientLayer.colors = @[(id)[UIColor colorWithHue:_currentHueValue saturation:0 brightness:1 alpha:1].CGColor,(id)[UIColor colorWithHue:_currentHueValue saturation:1 brightness:1 alpha:1].CGColor];
}

-(void)onSaturationSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    [self updateColorSpace];
}

-(void)onBrightnessSliderSliderValueChanged:(EFBeautySlider *)sender {
    sender.valueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
    [self updateColorSpace];
}

-(void)onColorWheelView:(EFColorWheelView *)wheelView hueValue:(CGFloat)hue {
    _currentHueValue = hue;
    [self updateColorSpace];
    [self updateSliders];
}

#pragma mark - properties
-(EFBeautySlider *)brightnessSlider {
    if (!_brightnessSlider) {
        _brightnessSlider = [[EFBeautySlider alloc] init];
        _brightnessSlider.minimumTrackTintColor = UIColor.clearColor;
        _brightnessSlider.maximumTrackTintColor = UIColor.clearColor;
        _brightnessSlider.value = _currentBrightnessValue;
        _brightnessSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", _brightnessSlider.value];
        _brightnessSlider.valueLabel.textColor = UIColor.lightGrayColor;
        //        _brightnessSlider.valueLabel.adjustsFontSizeToFitWidth = NO;
        [_brightnessSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_brightnessSlider addTarget:self action:@selector(onBrightnessSliderSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _brightnessSlider;
}

-(EFBeautySlider *)saturationSlider {
    if (!_saturationSlider) {
        _saturationSlider = [[EFBeautySlider alloc] init];
        _saturationSlider.minimumTrackTintColor = UIColor.clearColor;
        _saturationSlider.maximumTrackTintColor = UIColor.clearColor;
        _saturationSlider.value = _currentSaturationValue;
        _saturationSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", _saturationSlider.value];
        _saturationSlider.valueLabel.textColor = UIColor.lightGrayColor;
        //        _saturationSlider.valueLabel.adjustsFontSizeToFitWidth = NO;
        [_saturationSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        [_saturationSlider addTarget:self action:@selector(onSaturationSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _saturationSlider;
}

-(CAGradientLayer *)brightnessGradientLayer {
    if (!_brightnessGradientLayer) {
        _brightnessGradientLayer = [CAGradientLayer layer];
        _brightnessGradientLayer.startPoint = CGPointMake(0, 0);
        _brightnessGradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _brightnessGradientLayer;
}

-(CAGradientLayer *)saturationGradientLayer {
    if (!_saturationGradientLayer) {
        _saturationGradientLayer = [CAGradientLayer layer];
        _saturationGradientLayer.startPoint = CGPointMake(0, 0);
        _saturationGradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _saturationGradientLayer;
}

-(void)setDataSource:(id<TryOnDataElementInterface>)dataSource {
    _dataSource = dataSource;
    [self parsingAndShowTryOnInfoBy:dataSource];
}

/// 解析并将try on info显示在UI上
-(void)parsingAndShowTryOnInfoBy:(id<TryOnDataElementInterface>)dataSource {
    int regionCount = dataSource.tryonInfo -> region_count;
    if (regionCount > 0 && regionCount < 10) {
        self.strengthView.hidden = NO;
        self.strengthView.value = dataSource.tryonInfo -> region_info[self.currentRegionIndex].strength;
        
        st_color_t stColor = dataSource.tryonInfo -> region_info[self.currentRegionIndex].color;
        UIColor *color = [UIColor colorWithRed:stColor.r / 255 green:stColor.g / 255 blue:stColor.b / 255 alpha:stColor.a / 255];
        [self setCurrentColor:color];
    } else {
        if (dataSource.tryOnBeautyType == EFFECT_BEAUTY_TRYON_HAIR_COLOR) { // 染发特殊处理
            [self custoHairColorUI];
        }
        self.strengthView.hidden = YES;
        
        st_color_t stColor = dataSource.tryonInfo -> color;
        UIColor *color = [UIColor colorWithRed:stColor.r / 255 green:stColor.g / 255 blue:stColor.b / 255 alpha:stColor.a / 255];
        [self setCurrentColor:color];
    }
    
    self.segmentView.itemsCount = regionCount;
}

-(void)setCurrentColor:(UIColor *)currentColor {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    BOOL success = [currentColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (success) {
        _cv.hue = hue;
        _currentHueValue = hue;
        _saturationSlider.value = saturation;
        _saturationSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", _saturationSlider.value];
        _brightnessSlider.value = brightness;
        _brightnessSlider.valueLabel.text = [NSString stringWithFormat:@"%.2f", _brightnessSlider.value];
        [self updateSliders];
    }
}

-(EFTryOnLipsColorStrengthView *)strengthView {
    if (!_strengthView) {
        _strengthView = [[EFTryOnLipsColorStrengthView alloc] initWithFrame:CGRectZero];
    }
    return _strengthView;
}

-(EFTryOnHairStrengthView *)hairColorStrenthView {
    if (!_hairColorStrenthView) {
        _hairColorStrenthView = [[EFTryOnHairStrengthView alloc] initWithFrame:CGRectZero];
        _hairColorStrenthView.delegate = self;
    }
    return _hairColorStrenthView;
}

#pragma mark - actions
-(void)onBackButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelViewCanceled:)]) {
        [self.delegate tryOnColorWheelViewCanceled:self];
    }
}

#pragma mark - EFTryOnLipsColorStrengthViewDelegate
-(void)tryOnLipsColorStrengthView:(EFTryOnLipsColorStrengthView *)tryOnLipsColorStrengthView sliderValueChanged:(CGFloat)value {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelView:updateTryOnInfo:withBeautyType:)]) {
        self.dataSource.tryonInfo -> region_info[self.currentRegionIndex].strength = value;
        [self.delegate tryOnColorWheelView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

#pragma mark - hair color only
-(void)custoHairColorUI {
    self.hairColorStrenthView.hidden = NO;
    self.strengthView.hidden = YES;
    if (![self.subviews containsObject:self.hairColorStrenthView]) {
        [self addSubview:self.hairColorStrenthView];
        [self.hairColorStrenthView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    self.hairColorStrenthView.strength = self.dataSource.tryonInfo -> strength;
    self.hairColorStrenthView.brightness = self.dataSource.tryonInfo -> highlight;
    self.hairColorStrenthView.grayness = self.dataSource.tryonInfo -> midtone;
}

#pragma mark - EFTryOnHairStrengthViewDelegate
-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView strengthChanged:(CGFloat)strength {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelView:updateTryOnInfo:withBeautyType:)]) {
        self.dataSource.tryonInfo -> strength = strength;
        [self.delegate tryOnColorWheelView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView brightnessChanged:(CGFloat)strength {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelView:updateTryOnInfo:withBeautyType:)]) {
        self.dataSource.tryonInfo -> highlight = strength;
        [self.delegate tryOnColorWheelView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

-(void)tryOnHairStrengthView:(EFTryOnHairStrengthView *)tryOnHairStrengthView graynessChanged:(CGFloat)strength {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnColorWheelView:updateTryOnInfo:withBeautyType:)]) {
        self.dataSource.tryonInfo -> midtone = strength;
        [self.delegate tryOnColorWheelView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

#pragma mark - EFTryOnSegmentViewDelegate
-(void)tryOnSegmentView:(EFTryOnSegmentView *)tryOnSegmentView segmentIndexChanged:(NSInteger)currentIndex {
    self.currentRegionIndex = (int)currentIndex;
    self.strengthView.value = self.dataSource.tryonInfo -> region_info[self.currentRegionIndex].strength;
    
    st_color_t stColor = self.dataSource.tryonInfo -> region_info[self.currentRegionIndex].color;
    UIColor *color = [UIColor colorWithRed:stColor.r / 255 green:stColor.g / 255 blue:stColor.b / 255 alpha:stColor.a / 255];
    [self setCurrentColor:color];
}

@end
