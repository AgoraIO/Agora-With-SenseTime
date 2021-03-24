
//
//  STBMPDetailColVCell.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBMPDetailColVCell.h"

@implementation STBMPDetailColVCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.m_icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self addSubview:self.m_icon];
        self.m_icon.layer.borderWidth = 2.0f;
        self.m_icon.layer.cornerRadius = 50/2;
        self.m_icon.layer.masksToBounds = YES;
        
        self.m_labelName = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.m_icon.frame), self.frame.size.width, 20)];
        self.m_labelName.textAlignment = NSTextAlignmentCenter;
        self.m_labelName.textColor = [UIColor whiteColor];
        self.m_labelName.font = [UIFont systemFontOfSize:14];
        self.m_labelName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.m_labelName];
        CGPoint m_labelNameCenter = self.m_labelName.center;
        self.m_icon.center = CGPointMake(m_labelNameCenter.x, 25);
    }
    
    return self;
}

- (void)setName:(NSString *)name
{
    self.m_labelName.text = name;
}

- (void)setIcon:(NSString *)icon
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", icon]];
    [self.m_icon setImage:image];
}

- (void)setDidSelected:(BOOL)didSelected;
{
    if (didSelected) {
        _m_icon.layer.borderColor = [UIColor purpleColor].CGColor;
    }else{
        _m_icon.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
