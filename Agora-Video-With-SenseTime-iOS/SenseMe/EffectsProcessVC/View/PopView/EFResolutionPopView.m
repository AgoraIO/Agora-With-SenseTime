//
//  EFResolutionPopView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFResolutionPopView.h"

@interface EFResolutionPopView ()

@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonList;

@property (nonatomic, strong) NSMutableArray <UILabel *>*titleList;

@end


@implementation EFResolutionPopView

- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(XTDirectionType)type{
    self = [super initWithOrigin:origin Width:width Height:height Type:type];
    self.type = type;
    [self setUI];
    self.resolutType = _1280x720;
    return self;
}

- (void)setUI {
    
    NSArray *image_normal = @[@"640x480_normal", @"1280x720_normal", @"1920x1080_normal"];
    NSArray *image_selected = @[@"640x480_select", @"1280x720_select", @"1920x1080_select"];
    NSArray *titleArray = @[@"640x480",@"1280x720", @"1920x1080"];
    
    NSInteger space = (ScreenWidth - 40 - 26 * 3) / 4 ;
    self.buttonList = [[NSMutableArray alloc]init];
    self.titleList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(space + i*(space + 26), 20, 26, 26)];
        button.tag = 100 + i;
        
        [button setImage:[UIImage imageNamed:image_normal[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:image_selected[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGoundView addSubview:button];
        [self.buttonList addObject:button];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = titleArray[i];
        [self.titleList addObject:label];
        label.textColor = RGBA(163, 161, 161, 1);
        if (i == 1) {
            button.selected = YES;
            label.textColor = RGBA(249, 249, 249, 1);
        }
        label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [self.backGoundView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(button.mas_bottom).offset(10);
        }];
    }
    
    self.backGoundView.layer.cornerRadius = 5;
    self.backGoundView.layer.masksToBounds = YES;
    self.backGoundView.backgroundColor = RGBA(14, 14, 14, 0.7);
}


- (void)highlightWith:(ResolutionType)type {
    
    for (UIButton *button in self.buttonList) {
        button.selected = NO;
    }
    
    for (UILabel *label in self.titleList) {
        label.textColor = RGBA(163, 161, 161, 1);
    }
    
    switch (type) {
        case _640x480:
        {
            self.buttonList[0].selected = YES;
            self.titleList[0].textColor = RGBA(249, 249, 249, 1);
        }
            break;
        case _1280x720:
        {
            self.buttonList[1].selected = YES;
            self.titleList[1].textColor = RGBA(249, 249, 249, 1);
        }
            break;
        case _1920x1080:
        {
            self.buttonList[2].selected = YES;
            self.titleList[2].textColor = RGBA(249, 249, 249, 1);
        }
            break;
    }
}


#pragma mark - button Action
- (void)buttonAction:(UIButton *)sender {
    
    [self highlightWith:sender.tag - 100];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(EFResolutionPopView:didSelectType:)]) {
        self.resolutType = sender.tag - 100;
        [self.delegate EFResolutionPopView:self didSelectType:sender.tag - 100];
    }
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        [self removeFromSuperview];
    }];
}

#pragma mark -
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)startAnimateNormalView_x:(CGFloat) x
                              _y:(CGFloat) y
                    origin_width:(CGFloat) width
                   origin_height:(CGFloat) height
{
    self.backGoundView.frame = CGRectMake(x, y, width, height);
}

#pragma mark -
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![[touches anyObject].view isEqual:self.backGoundView]) {
        [self dismiss];
    }
    
}

@end
