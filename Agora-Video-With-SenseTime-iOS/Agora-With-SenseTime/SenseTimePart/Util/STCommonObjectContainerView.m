//
//  STCommonObjectContainerView.m
//  SenseMeEffects
//
//  Created by Sunshine on 2017/6/1.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCommonObjectContainerView.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface STCommonObjectContainerView () <STCommonObjectViewDelegate>

@property (nonatomic, readwrite, assign) int newObjectViewID;

@end

@implementation STCommonObjectContainerView

- (void)drawRect:(CGRect)rect {
    
//    [self drawPoints];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetLineWidth(context, 1);
    
    [[UIColor greenColor] set];
    
    if (self.faceArray.count > 0) {
        
        for (NSDictionary *dic in self.faceArray) {
            
            if ([dic objectForKey:POINT_KEY]) {
                CGPoint point = [[dic objectForKey:POINT_KEY] CGPointValue];
                CGContextFillRect(context, CGRectMake(point.x - 1, point.y - 1, 2.0, 2.0));
            }
        }
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.needClear = NO;
    }
    return self;
}

- (void)drawPoints {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    if (!self.needClear) {
        
        CGContextSetLineWidth(context, 2);
        UIColor *greenColor = [UIColor greenColor];
        
        for (NSDictionary *dicPerson in self.arrPersons) {
            
            NSArray *arrPoints = [dicPerson objectForKey:POINTS_KEY];
            if (arrPoints) {
                for (NSDictionary *dicPoint in arrPoints) {
                    [greenColor set];
                    CGPoint point = [[dicPoint objectForKey:POINT_KEY] CGPointValue];
                    CGContextFillRect(context, CGRectMake(point.x - 1.0, point.y - 1.0, 2.0, 2.0));
                }
            }
            
            if ([dicPerson objectForKey:RECT_KEY]) {
                CGContextStrokeRect(context, [[dicPerson objectForKey:RECT_KEY] CGRectValue]);
            }
        }
    } else {
        CGContextClearRect(context, self.bounds);
    }
}

- (void)addCommonObjectViewWithImage:(UIImage *)image {
    _currentCommonObjectView = [[STCommonObjectView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - COMMON_OBJCET_VIEW_WIDTH / 2, SCREEN_HEIGHT / 2 - COMMON_OBJECT_VIEW_HEIGHT / 2, COMMON_OBJCET_VIEW_WIDTH, COMMON_OBJECT_VIEW_HEIGHT) commonObjectViewID:_newObjectViewID image:image];
    _currentCommonObjectView.onFirst = YES;
    [self addSubview:_currentCommonObjectView];
    _currentCommonObjectView.delegate = self;
}


#pragma mark - delegate

- (void)commonObjectViewBeginMove:(int)commonObjectViewID {
    if ([self.delegate respondsToSelector:@selector(commonObjectViewFinishTrackingFrame:)]) {
        [self.delegate commonObjectViewFinishTrackingFrame:self.currentCommonObjectView.frame];
    }
}

- (void)commonObjectViewEndMove:(int)commonObjectViewID {
    if ([self.delegate respondsToSelector:@selector(commonObjectViewStartTrackingFrame:)]) {
        [self.delegate commonObjectViewStartTrackingFrame:self.currentCommonObjectView.frame];
    }
}

#pragma mark - getter and setter
- (void)setCurrentCommonObjectView:(STCommonObjectView *)currentCommonObjectView {
    _currentCommonObjectView = currentCommonObjectView;
    [self bringSubviewToFront:currentCommonObjectView];
}

@end
