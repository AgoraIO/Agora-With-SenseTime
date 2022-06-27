//
//  EFColorWheelView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/19.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFColorWheelView.h"

@interface EFColorWheelView ()
{
@private
    
    CALayer *_indicatorLayer;
    CGFloat _hue;
    CGFloat _saturation;
}

@end


@implementation EFColorWheelView

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _hue = 0.0f;
        _saturation = 0.0f;

        self.accessibilityLabel = @"color_wheel_view";

        self.layer.delegate = self;
        [self.layer addSublayer:[self indicatorLayer]];
    }

    return self;
}

- (CALayer *)indicatorLayer
{
    if (!_indicatorLayer) {
        CGFloat dimension = 33;
        UIColor *edgeColor = [UIColor colorWithWhite:0.9 alpha:0.8];
        _indicatorLayer = [CALayer layer];
        _indicatorLayer.cornerRadius = dimension / 2;
        _indicatorLayer.borderColor = edgeColor.CGColor;
        _indicatorLayer.borderWidth = 2;
        _indicatorLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _indicatorLayer.bounds = CGRectMake(0, 0, dimension, dimension);
        _indicatorLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        _indicatorLayer.shadowColor = [UIColor blackColor].CGColor;
        _indicatorLayer.shadowOffset = CGSizeZero;
        _indicatorLayer.shadowRadius = 1;
        _indicatorLayer.shadowOpacity = 0.5f;
    }

    return _indicatorLayer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint position = [[touches anyObject] locationInView:self];

    [self onTouchEventWithPosition:position];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint position = [[touches anyObject] locationInView:self];

    [self onTouchEventWithPosition:position];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint position = [[touches anyObject] locationInView:self];

    [self onTouchEventWithPosition:position];
}

- (void)onTouchEventWithPosition:(CGPoint)point
{
    CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    CGFloat dist = sqrtf((radius - point.x) * (radius - point.x) + (radius - point.y) * (radius - point.y));

    if (dist <= radius) {
        [self ms_colorWheelValueWithPosition:point hue:&_hue saturation:&_saturation];
        [self setSelectedPoint:point];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(onColorWheelView:hueValue:)]) {
        [self.delegate onColorWheelView:self hueValue:_hue];
    }
}

- (void)setSelectedPoint:(CGPoint)point
{
    UIColor *selectedColor = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0f alpha:1.0f];

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    self.indicatorLayer.position = point;
    self.indicatorLayer.backgroundColor = selectedColor.CGColor;
    [CATransaction commit];
}

- (void)setHue:(CGFloat)hue
{
    _hue = hue;
    [self setSelectedPoint:[self ms_selectedPoint]];
    [self setNeedsDisplay];
}

- (void)setSaturation:(CGFloat)saturation
{
    _saturation = saturation;
    [self setSelectedPoint:[self ms_selectedPoint]];
    [self setNeedsDisplay];
}

#pragma mark - CALayerDelegate methods

- (void)displayLayer:(CALayer *)layer
{
    CGFloat dimension = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    NSDictionary* parameters = @{@"inputColorSpace": (__bridge_transfer id)CGColorSpaceCreateDeviceRGB(),
                            @"inputDither": @0,
                            @"inputRadius": @(dimension),
                            @"inputSoftness": @0,
                            @"inputValue": @1};
    CIFilter* filter = [CIFilter filterWithName:@"CIHueSaturationValueGradient" withInputParameters:parameters];
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    self.layer.contents = (__bridge_transfer id)cgimg;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer == self.layer) {
        [self setSelectedPoint:[self ms_selectedPoint]];
        [self.layer setNeedsDisplay];
    }
}

#pragma mark - Private methods

- (CGPoint)ms_selectedPoint
{
    CGFloat dimension = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    CGFloat radius = _saturation * dimension / 2;
    CGFloat x = dimension / 2 + radius * cosf(_hue * M_PI * 2.0f);
    CGFloat y = dimension / 2 - radius * sinf(_hue * M_PI * 2.0f);

    return CGPointMake(x, y);
}

- (void)ms_colorWheelValueWithPosition:(CGPoint)position hue:(out CGFloat *)hue saturation:(out CGFloat *)saturation
{
    NSInteger c = CGRectGetWidth(self.bounds) / 2;
    CGFloat dx = (float)(position.x - c) / c;
    CGFloat dy = (float)(c - position.y) / c;
    CGFloat d = sqrtf((float)(dx * dx + dy * dy));

    *saturation = d;

    if (d == 0) {
        *hue = 0;
    } else {
        *hue = acosf((float)dx / d) / M_PI / 2.0f;

        if (dy < 0) {
            *hue = 1.0 - *hue;
        }
    }
}


@end
