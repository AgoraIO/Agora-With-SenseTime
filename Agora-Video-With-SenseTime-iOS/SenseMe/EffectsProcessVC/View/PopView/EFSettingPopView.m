//
//  EFSettingPopView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFSettingPopView.h"

@interface EFSettingPopView ()

@property (nonatomic, strong) NSMutableArray <UIButton *>*buttonList;

@property (nonatomic, strong) NSMutableArray <UILabel *>*titleList;

@end

@implementation EFSettingPopView

- (instancetype)initWithOrigin:(CGPoint)origin Width:(CGFloat)width Height:(CGFloat)height Type:(XTDirectionType)type{
    
    self = [super initWithOrigin:origin Width:width Height:height Type:type];
    self.type = type;
    
    [self setUI];
    return self;
}


- (void)setUI {
    
    NSArray *image_normal = @[@"performance_normal", @"language_normal",
                              //                              @"yuv_normal",
                              @"terms_normal", @"chongbo_icon_n"];
    NSArray *image_selected = @[@"performance_select", @"language_select",
                                //                                @"yuv_select",
                                @"terms_select", @"chongbo_icon_s"];
    NSArray *titleArray = @[@"性能展示",
                            @"语言切换",
                            //                            @"YUV/RGBA切换",
                            @"使用条款", @"Replay"];
    NSInteger space = (ScreenWidth - 40 - 26 * 4 - 60) / 3 ;
    self.buttonList = [[NSMutableArray alloc]init];
    self.titleList = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(30 + i*(space + 26), 20, 26, 26)];
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:image_normal[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:image_selected[i]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGoundView addSubview:button];
        [self.buttonList addObject:button];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = NSLocalizedString(titleArray[i], nil);
        [self.titleList addObject:label];
        label.textColor = RGBA(163, 161, 161, 1);
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


- (void)buttonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    //使用条款 不需要高亮
    if (sender.tag - 100 == 2) {
        sender.selected = NO;
    }
    
    if (sender.selected) {
        self.titleList[sender.tag - 100].textColor = RGBA(249, 249, 249, 1);
    }else {
        self.titleList[sender.tag - 100].textColor = RGBA(163, 161, 161, 1);
    }
    
    if ([self.delegate respondsToSelector:@selector(EFSettingPopView:didSelectIndex:select:)]) {
        [self.delegate EFSettingPopView:self didSelectIndex:sender.tag - 100 select:sender.selected];
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
