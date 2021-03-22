//
//  STBMPCollectionViewCell.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBMPCollectionViewCell.h"

@implementation STBMPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.m_icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 50, 50)];
        [self addSubview:self.m_icon];
        
        self.m_labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.m_icon.frame), self.frame.size.width, 25)];
        self.m_labelName.textAlignment = NSTextAlignmentCenter;
        self.m_labelName.textColor = [UIColor whiteColor];
        self.m_labelName.font = [UIFont systemFontOfSize:14];
        self.m_labelName.backgroundColor = [UIColor clearColor];
        CGPoint m_labelNameCenter = self.m_labelName.center;
        self.m_icon.center = CGPointMake(m_labelNameCenter.x, 30);
        [self addSubview:self.m_labelName];
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

@end
