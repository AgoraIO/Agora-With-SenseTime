//
//  EFScanAnimationView.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanAnimationView.h"
#import "EFTimerProxy.h"

@interface EFScanAnimationView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIImageView *stripImageView;

@end

@implementation EFScanAnimationView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
    }
    return self;
}

-(void)customUI {
    UIImageView *boxImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_box"]];
    [self addSubview:boxImageView];
    
    [boxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.stripImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_animation_strip"]];
    [self addSubview:self.stripImageView];
    
    [self.stripImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@2);
        make.centerY.equalTo(self);
    }];
    
    EFTimerProxy *timerProxy = [[EFTimerProxy alloc] initWithTarget:self];
    self.displayLink = [CADisplayLink displayLinkWithTarget:timerProxy selector:@selector(displayLinkAction:)];
    self.displayLink.frameInterval = 1;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

static NSInteger f = 0;
static BOOL isDown = YES;
-(void)displayLinkAction:(id)sender {
    if (f >= self.bounds.size.height) {
        isDown = NO;
    } else if (f <= 0) {
        isDown = YES;
    }
    if (isDown) {
        f += 2;
    } else {
        f -= 2;
    }
    [self.stripImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).inset(f);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@2);
    }];
}

-(void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end
