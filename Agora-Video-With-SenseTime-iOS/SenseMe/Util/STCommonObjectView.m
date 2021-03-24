//
//  STCommonObjectView.m
//  SenseMeEffects
//
//  Created by Sunshine on 2017/6/1.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCommonObjectView.h"
#import "STCommonObjectContainerView.h"


@interface STCommonObjectView ()

@property (nonatomic, readwrite, strong) UIImageView *imageContentView;
@property (nonatomic, readwrite, strong) UIImageView *deleteBtnView;
@property (nonatomic, readwrite, strong) UIImageView *sizeControlBtnView;
@property (nonatomic, readwrite, assign) CGFloat minWidth;
@property (nonatomic, readwrite, assign) CGFloat minHeight;
@property (nonatomic, readwrite, assign) CGFloat deltaAngle;
@property (nonatomic, readwrite, assign) CGPoint prevPoint;
@property (nonatomic, readwrite, assign) CGPoint touchStart;
@property (nonatomic, readwrite, assign) CGRect containerRect;

@end

@implementation STCommonObjectView

#pragma mark - remove
- (void)removeCommonObjectView {
    [self removeFromSuperview];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame commonObjectViewID:(int)viewID image:(UIImage *)image {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _commonObjectViewID = viewID;
        _onFirst = NO;
        
        [self setupSubviews];
        self.image = image;
        [self setupGestures];
    }
    return self;
}

- (void)setupSubviews {

    _imageContentView = [[UIImageView alloc] initWithFrame:CGRectMake(COMMON_OBJECT_VIEW_MARGIN, COMMON_OBJECT_VIEW_MARGIN, self.frame.size.width - 2 * COMMON_OBJECT_VIEW_MARGIN, self.frame.size.height - 2 * COMMON_OBJECT_VIEW_MARGIN)];
    _imageContentView.backgroundColor = [UIColor clearColor];
    _imageContentView.layer.borderColor = [UIColor redColor].CGColor;
    _imageContentView.layer.borderWidth = 4;
    _imageContentView.contentMode = UIViewContentModeScaleAspectFit;
    _imageContentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageContentView];
    
    _deleteBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, COMMON_OBJECT_VIEW_MARGIN * 2, COMMON_OBJECT_VIEW_MARGIN * 2)];
    _deleteBtnView.userInteractionEnabled = YES;
    _deleteBtnView.image = [UIImage imageNamed:@"bt_paster_delete"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteBtnPressed)];
    [_deleteBtnView addGestureRecognizer:tap];
    //[self addSubview:_deleteBtnView];
    
    _sizeControlBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - COMMON_OBJECT_VIEW_MARGIN * 2, self.frame.size.height - COMMON_OBJECT_VIEW_MARGIN * 2, COMMON_OBJECT_VIEW_MARGIN * 2, COMMON_OBJECT_VIEW_MARGIN * 2)];
    _sizeControlBtnView.userInteractionEnabled = YES;
    _sizeControlBtnView.image = [UIImage imageNamed:@"bt_paster_transform"];
    UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)];
    [_sizeControlBtnView addGestureRecognizer:panResizeGesture];
    //[self addSubview:_sizeControlBtnView];
}

- (void)setupGestures {
    
//    self.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    [self addGestureRecognizer:tapGesture];
//    
//    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
//    [self addGestureRecognizer:rotateGesture];
    
}

#pragma mark -
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageContentView.image = image;
}

- (void)setOnFirst:(BOOL)onFirst {
    _onFirst = onFirst;
    
//    self.deleteBtnView.hidden = !onFirst;
//    self.sizeControlBtnView.hidden = !onFirst;

    self.imageContentView.layer.borderWidth = onFirst ? 3.0 : 0.0;
    
    if (onFirst) {
        NSLog(@"common object view: %d is on.", self.commonObjectViewID);
    }
}

#pragma mark - TODO
- (void)deleteBtnPressed {
    
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer {
    
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {

}

- (void)handleRotate:(UIRotationGestureRecognizer *)rotateGesture {

}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.onFirst = YES;
    if ([self.delegate respondsToSelector:@selector(commonObjectViewBeginMove:)]) {
        [self.delegate commonObjectViewBeginMove:self.commonObjectViewID];
    }

    UITouch *touch = [touches anyObject];
    _touchStart = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    
    if (CGRectContainsPoint(self.sizeControlBtnView.frame, touchLocation)) {
        return;
    }
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
    _touchStart = touch;
}

- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - _touchStart.x,
                                    self.center.y + touchPoint.y - _touchStart.y);
    CGFloat midPointX = CGRectGetMidX(self.bounds);
    
//    if (newCenter.x > self.superview.bounds.size.width - midPointX + COMMON_OBJCET_VIEW_WIDTH / 2) {
//        newCenter.x = self.superview.bounds.size.width - midPointX + COMMON_OBJCET_VIEW_WIDTH / 2;
//    }
//    if (newCenter.x < midPointX - COMMON_OBJCET_VIEW_WIDTH / 2) {
//        newCenter.x = midPointX - COMMON_OBJCET_VIEW_WIDTH / 2;
//    }
    
    if (newCenter.x > self.superview.bounds.size.width - midPointX + COMMON_OBJECT_VIEW_MARGIN) {
        newCenter.x = self.superview.bounds.size.width - midPointX + COMMON_OBJECT_VIEW_MARGIN;
    }
    if (newCenter.x < midPointX - COMMON_OBJECT_VIEW_MARGIN) {
        newCenter.x = midPointX - COMMON_OBJECT_VIEW_MARGIN;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
//    if (newCenter.y > self.superview.bounds.size.height - midPointY + COMMON_OBJECT_VIEW_HEIGHT / 2)
//    {
//        newCenter.y = self.superview.bounds.size.height - midPointY + COMMON_OBJECT_VIEW_HEIGHT / 2;
//    }
//    if (newCenter.y < midPointY - COMMON_OBJECT_VIEW_HEIGHT / 2)
//    {
//        newCenter.y = midPointY - COMMON_OBJECT_VIEW_HEIGHT / 2;
//    }
    
    if (newCenter.y > self.superview.bounds.size.height - midPointY + COMMON_OBJECT_VIEW_MARGIN) {
        newCenter.y = self.superview.bounds.size.height - midPointY + COMMON_OBJECT_VIEW_MARGIN;
    }
    if (newCenter.y < midPointY - COMMON_OBJECT_VIEW_MARGIN) {
        newCenter.y = midPointY - COMMON_OBJECT_VIEW_MARGIN;
    }
    self.center = newCenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.onFirst = NO;
    if ([self.delegate respondsToSelector:@selector(commonObjectViewEndMove:)]) {
        [self.delegate commonObjectViewEndMove:self.commonObjectViewID];
    }
}

@end
