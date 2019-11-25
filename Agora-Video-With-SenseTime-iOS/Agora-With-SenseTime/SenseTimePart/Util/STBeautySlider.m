//
//  STBeautySlider.m
//  SenseMeEffects
//
//  Created by Sunshine on 2019/2/11.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBeautySlider.h"


#define double_equals(x, y) ((x-y)>-0.0001 && (x-y)<0.0001)

@interface STBeautySlider ()

@end

@implementation STBeautySlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLabel.text = @"";
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_valueLabel];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect trackRect = [super trackRectForBounds:bounds];
    return CGRectMake(trackRect.origin.x, bounds.size.height * 3.0 / 4.0 - 1.0, trackRect.size.width, trackRect.size.height);
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    if ([self.delegate respondsToSelector:@selector(currentSliderValue:slider:)]) {
        value = [self.delegate currentSliderValue:value slider:self];
    }
    
    
    value = value * 100;
    if (double_equals(value, 10)) {
        value = 10;
    }
    
    _valueLabel.text = [NSString stringWithFormat:@"%d", (int)value];
    _valueLabel.frame = CGRectMake(thumbRect.origin.x, 0, thumbRect.size.width, thumbRect.origin.y);
    return thumbRect;
}

@end
