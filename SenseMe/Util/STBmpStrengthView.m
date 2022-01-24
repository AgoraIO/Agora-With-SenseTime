//
//  STBmpStrengthView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/13.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBmpStrengthView.h"
#import "STParamUtil.h"

@interface STBmpStrengthView ()
@property (nonatomic, strong) UISlider *filterStrengthSlider;
@property (nonatomic, strong) UILabel *lblFilterStrength;
@end

@implementation STBmpStrengthView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUis) name:@"resetUIs" object:nil];
        
        [self setupUIs];
        
        return self;
    }
    
    return nil;
}

- (void)resetUis
{
    [self updateSliderValue:0.8];
}


- (void)setupUIs {
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 10, 35.5)];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:11];
    leftLabel.text = @"0";
    [self addSubview:leftLabel];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width - 90, 35.5)];
    slider.thumbTintColor = UIColorFromRGB(0x9e4fcb);
    slider.minimumTrackTintColor = UIColorFromRGB(0x9e4fcb);
    slider.maximumTrackTintColor = [UIColor whiteColor];
    slider.value = 0.8;
    slider.minimumValue = 0.0f;
    slider.maximumValue = 1.0f;
    [slider addTarget:self action:@selector(filterSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _filterStrengthSlider = slider;
    [self addSubview:slider];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 20, 35.5)];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:11];
    rightLabel.text = @"80";
    _lblFilterStrength = rightLabel;
    [self addSubview:rightLabel];

}

- (void)filterSliderValueChanged:(UISlider *)slider
{
    _lblFilterStrength.text = [NSString stringWithFormat:@"%d", (int)(slider.value * 100)];
    if (self.delegate) {
        [self.delegate sliderValueDidChange:slider.value];
    }
}

- (void)updateSliderValue:(float)value
{
    _filterStrengthSlider.value = value;
    _lblFilterStrength.text = [NSString stringWithFormat:@"%d", (int)(value * 100)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetUIs" object:nil];
}
@end
