//
//  EFNavigationView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFNavigationView.h"

@interface EFNavigationView ()
{
    EFViewType _type;
}

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *cameraButton;

@property (nonatomic, strong) UIButton *saveButton;

/// 扫码按钮
@property (nonatomic, strong) UIButton *scanButton;

@end


@implementation EFNavigationView

- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type andIsTryOn:(BOOL)isTryOn {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self setUIByTryOn:isTryOn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type{
    return [self initWithFrame:frame type:type andIsTryOn:NO];
}

- (void)setUIByTryOn:(BOOL)isTryOn {
    self.backButton = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    self.backButton.tag = 0;
    [self.backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(22);
        make.bottom.equalTo(self.mas_bottom).offset(-18);
    }];
    
    if (EFViewTypePreview != _type) {
        self.saveButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.saveButton setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        self.saveButton.tag = 1;
        [self.saveButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-22);
            make.bottom.equalTo(self.mas_bottom).offset(-18);
        }];
    }
    
    if (EFViewTypeVideo == _type) {
        self.playButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"preview"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        self.playButton.tag = 2;
        [self.playButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];
        [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.saveButton.mas_left).offset(-22);
            make.centerY.equalTo(self.saveButton);
        }];
    }
    
    if (EFViewTypePreview == _type) {
        self.settingButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.settingButton setBackgroundImage:[UIImage imageNamed:@"setting_icon"] forState:UIControlStateNormal];
        self.settingButton.tag = 1;
        [self.settingButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.settingButton];
        
        self.scaleButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.scaleButton setBackgroundImage:[UIImage imageNamed:@"scale_icon"] forState:UIControlStateNormal];
        self.scaleButton.tag = 2;
        [self.scaleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.scaleButton];
        
        self.cameraButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
        self.cameraButton.tag = 3;
        [self.cameraButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cameraButton];
        
        if (isTryOn) {
            NSInteger space = (SCREEN_W - (25 * 4) - 44) / 3;
            
            [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backButton.mas_bottom);
                make.left.equalTo(self.backButton.mas_right).offset(space);
            }];
            
            [self.scaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.settingButton.mas_bottom);
                make.left.equalTo(self.settingButton.mas_right).offset(space);
            }];
            
            [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-22);
                make.bottom.equalTo(self.scaleButton.mas_bottom);
            }];
        } else {
            self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.scanButton setBackgroundImage:[UIImage imageNamed:@"scan_entry"] forState:UIControlStateNormal];
            self.scanButton.tag = 4;
            [self.scanButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.scanButton];
            
            NSInteger space = (SCREEN_W - (25 * 4) - 44) / 4;
            
            [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backButton.mas_bottom);
                make.left.equalTo(self.backButton.mas_right).offset(space);
            }];
            
            [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.settingButton.mas_bottom);
                make.left.equalTo(self.settingButton.mas_right).offset(space);
            }];
            
            [self.scaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.scanButton.mas_bottom);
                make.left.equalTo(self.scanButton.mas_right).offset(space);
            }];
            
            [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-22);
                make.bottom.equalTo(self.scaleButton.mas_bottom);
            }];
        }
    }
}

- (void)hideSubview:(BOOL)hide {
    for (UIView *view in self.subviews) {
        view.hidden = hide;
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (sender == self.playButton) {
        sender.selected = !sender.selected;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(EFNavigationView:didSelect:sender:)]) {
        [self.delegate EFNavigationView:self didSelect:sender.tag sender:sender];
    }
}


@end
