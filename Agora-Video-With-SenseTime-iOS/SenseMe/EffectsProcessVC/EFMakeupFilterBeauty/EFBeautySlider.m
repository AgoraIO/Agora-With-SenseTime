//
//  STBeautySlider.m
//  SenseMeEffects
//
//  Created by Sunshine on 2019/2/11.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "EFBeautySlider.h"


#define double_equals(x, y) ((x-y)>-0.0001 && (x-y)<0.0001)

@interface EFBeautySlider ()

@end

@implementation EFBeautySlider

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
    _valueLabel.frame = CGRectMake(thumbRect.origin.x - 5, 0 - 5, thumbRect.size.width + 10, thumbRect.origin.y + 10);
    return thumbRect;
}

@end
