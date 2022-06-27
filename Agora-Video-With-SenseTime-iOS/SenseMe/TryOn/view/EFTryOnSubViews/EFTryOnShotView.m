//
//  EFTryOnShotView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/23.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnShotView.h"

@implementation EFTryOnShotView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    UIButton * shotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shotButton addTarget:self action:@selector(onShotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shotButton setBackgroundImage:[UIImage imageNamed:@"takePhoto_process"] forState:UIControlStateNormal];
    [self addSubview:shotButton];
    
    [shotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@44);
        make.center.equalTo(self);
    }];
}

-(void)onShotButtonClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnShotView:onShotButtonClick:)]) {
        [self.delegate tryOnShotView:self onShotButtonClick:sender];
    }
}

@end
