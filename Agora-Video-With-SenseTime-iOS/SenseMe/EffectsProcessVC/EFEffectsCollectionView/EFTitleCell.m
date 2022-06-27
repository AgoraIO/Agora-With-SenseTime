//
//  EFTitleCell.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTitleCell.h"

@interface EFTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation EFTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(60);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(36);
        make.centerX.equalTo(self.titleLabel.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}


- (void)config:(EFDataSourceModel *)model select:(BOOL)isSelect {
    self.titleLabel.text = NSLocalizedString(model.efAlias, nil);
    self.titleLabel.textColor = isSelect ? RGBA(255, 255, 255, 1) : RGBA(255, 255, 255, 0.5);
    self.lineView.hidden = isSelect ? NO : YES;
}

//风格 cell
- (void)configStyle:(EFDataSourceModel *)model select:(BOOL)isSelect {
    
    self.titleLabel.text = NSLocalizedString(model.efAlias, nil);
    self.titleLabel.textColor = RGBA(82, 82, 82, 1);
    self.titleLabel.font = [UIFont systemFontOfSize:11 weight:isSelect ? UIFontWeightSemibold : UIFontWeightRegular];
    self.lineView.hidden = isSelect ? NO : YES;
    self.lineView.backgroundColor = RGBA(221, 144, 250, 1);
    
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = RGBA(255, 255, 255, 0.5);
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.hidden = YES;
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

@end
