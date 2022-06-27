//
//  EFStyleContentCell.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStyleContentCell.h"
#import "YYWebImage.h"

@interface EFStyleContentCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@end

@implementation EFStyleContentCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}


- (void)setUI {
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.activity];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(46);
        make.centerX.centerY.equalTo(self.contentView);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.centerY.equalTo(self.imageView);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.imageView);
        make.width.height.mas_equalTo(20);
    }];
}


- (void)config:(EFDataSourceModel *)model status:(EFMaterialDownloadStatus)status select:(BOOL)select{
    UIImage *image;
    if ([model.efThumbnailDefault isEqualToString:@"none"]) {
        image = [UIImage imageNamed:model.efThumbnailDefault];
    } else {
        NSString *path =  [NSString stringWithFormat:@"%@/%@",kDocumentPath, model.efThumbnailDefault];
        image = [UIImage imageWithContentsOfFile:path];
    }
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.efThumbnailDefault] placeholder:[UIImage imageNamed:model.efThumbnailDefault]];

    if (status == EFMaterialDownloadStatusDownloading) {
        self.activity.hidden = NO;
        [self.activity startAnimating];
    }else{
        self.activity.hidden = YES;
        [self.activity stopAnimating];
    }
    self.selectImageView.hidden = !select;
}

- (void)config:(EFDataSourceModel *)model select:(BOOL)select{
    
//    [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.efThumbnailDefault] placeholder:[UIImage imageNamed:model.efThumbnailDefault]];
//    self.selectImageView.hidden = !select;
    
    [self config:model status:EFMaterialDownloadStatusDownloaded select:select];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.cornerRadius = 23;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIImageView *)selectImageView {

    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc]init];
        _selectImageView.hidden = YES;
        _selectImageView.image = [UIImage imageNamed:@"style_select"];
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
