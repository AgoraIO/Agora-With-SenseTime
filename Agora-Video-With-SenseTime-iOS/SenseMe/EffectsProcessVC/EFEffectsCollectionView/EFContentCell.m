//
//  EFContentCell.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFContentCell.h"
#import "YYWebImage.h"

@interface EFContentCell()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *downLoadButton;

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation EFContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}


- (void)setUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.downLoadButton];
    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.activity];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconImageView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
    
    [self.downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconImageView.mas_right).offset(5);
        make.bottom.equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.iconImageView);
        make.width.height.mas_equalTo(52);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.iconImageView);
        make.width.height.mas_equalTo(20);
    }];
    
}

- (void)config:(EFDataSourceMaterialModel *)model status:(EFMaterialDownloadStatus)status select:(BOOL)select{
    UIImage *image;
    if ([model.efThumbnailDefault isEqualToString:@"none"]) {
        image = [UIImage imageNamed:model.efThumbnailDefault];
    } else {
        NSString *path =  [NSString stringWithFormat:@"%@/%@",kDocumentPath, model.efThumbnailDefault];
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    if (model.efFromBundle || [UIImage imageNamed:model.efThumbnailDefault]) {
        self.iconImageView.image = [UIImage imageNamed:model.efThumbnailDefault];
    } else {
        [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:model.strThumbnailURL] placeholder:image];
    }

    self.titleLabel.text = NSLocalizedString(model.strName, nil);
    self.downLoadButton.hidden = status == EFMaterialDownloadStatusNotDownload ? NO : YES;
    if (status == EFMaterialDownloadStatusDownloading) {
        self.activity.hidden = NO;
        [self.activity startAnimating];
    }else{
        self.activity.hidden = YES;
        [self.activity stopAnimating];
    }
    self.selectImageView.hidden = !select;
    
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = 5.0;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.hidden = YES;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _titleLabel;
}

- (UIButton *)downLoadButton {
    if (!_downLoadButton) {
        _downLoadButton = [[UIButton alloc]init];
        [_downLoadButton setImage:[UIImage imageNamed:@"download_process"] forState:UIControlStateNormal];
    }
    return _downLoadButton;
}

- (UIImageView *)selectImageView {
    
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.hidden = YES;
        _selectImageView.image = [UIImage imageNamed:@"select_icon"];
    }
    return _selectImageView;
}

- (UIActivityIndicatorView *)activity {
    
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]init];
        _activity.color = [UIColor whiteColor];
    }
    return _activity;
}


@end
