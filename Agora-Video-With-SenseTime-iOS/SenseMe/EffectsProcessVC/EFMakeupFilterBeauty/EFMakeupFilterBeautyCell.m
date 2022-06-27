//
//  EFMakeupFilterBeautyCell.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMakeupFilterBeautyCell.h"
#import "YYWebImage.h"

@interface EFMakeupFilterBeautyCell ()

@property (nonatomic, strong) UIImageView *iconImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *selectImage;

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation EFMakeupFilterBeautyCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    [self.contentView addSubview:self.selectImage];
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.activity];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(44);
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.width.mas_lessThanOrEqualTo(64);
        make.top.equalTo(self.iconImage.mas_bottom).offset(5);
    }];
    
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(47);
        make.centerX.centerY.equalTo(self.iconImage);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImage.mas_centerX);
        make.top.equalTo(self.iconImage.mas_bottom).offset(20);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.iconImage);
        make.width.height.mas_equalTo(20);
    }];
}


- (void)config:(EFDataSourceModel *)model
          type:(EffectsItemType)itemType
        select:(BOOL)isSelect
        status:(EFMaterialDownloadStatus)status
         value:(int)value{
    NSURL *imageUrl = nil;
    if (model.efThumbnailDefault && [model.efThumbnailDefault hasPrefix:@"http"]) {
        imageUrl = [NSURL URLWithString:model.efThumbnailDefault];
    }
    [self.iconImage yy_setImageWithURL:imageUrl placeholder:[UIImage imageNamed:model.efThumbnailDefault]];
    self.titleLabel.text = NSLocalizedString(model.efName, nil);
    self.valueLabel.text = [NSString stringWithFormat:@"%d", value];
    
    if (itemType != effectsItemBeauty && isSelect) {
        self.selectImage.hidden = NO;
    } else {
        self.selectImage.hidden = YES;
    }
    
    switch (itemType) {
        case effectsItemMakeup:
            if (status == EFMaterialDownloadStatusDownloading) {
                self.activity.hidden = NO;
                [self.activity startAnimating];
            }else{
                self.activity.hidden = YES;
                [self.activity stopAnimating];
            }
            self.iconImage.layer.cornerRadius = 22;
            self.iconImage.layer.masksToBounds = YES;
            self.selectImage.image = [UIImage imageNamed:@"makeup_select"];
            break;
        case effectsItemFilter:
            self.iconImage.layer.cornerRadius = 5;
            self.iconImage.layer.masksToBounds = YES;
            self.selectImage.image = [UIImage imageNamed:@"filter_select"];
            break;
        case effectsItemBeauty:
        case effectsItemMulti:
            self.valueLabel.hidden = model.efSubDataSources.count > 0 ? YES : NO;
            self.iconImage.layer.cornerRadius = 0;
            self.iconImage.layer.masksToBounds = YES;
            self.iconImage.image = [UIImage imageNamed:isSelect ? model.efThumbnailHighlight : model.efThumbnailDefault];
            break;
    }
    
}

#pragma mark - set
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]init];
    }
    return _iconImage;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBA(255, 255, 255, 1);
        _titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    
    if (!_valueLabel) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.hidden = YES;
        _valueLabel.textColor = RGBA(255, 255, 255, 1);
        _valueLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _valueLabel;
}

- (UIImageView *)selectImage {
    
    if (!_selectImage) {
        _selectImage = [[UIImageView alloc]init];
        _selectImage.hidden = YES;
    }
    return _selectImage;
}

- (UIActivityIndicatorView *)activity {
    
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]init];
        _activity.color = [UIColor whiteColor];
        _activity.hidden = YES;
    }
    return _activity;
}

@end
