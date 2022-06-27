//
//  EFTryOnBeautyCollectionViewCell.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnBeautyCollectionViewCell.h"
#import "YYWebImage.h"

@interface EFTryOnBeautyCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property (nonatomic, strong) UILabel * name;

@end

@implementation EFTryOnBeautyCollectionViewCell

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
    [self.contentView addSubview:self.name];
        
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(46);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).offset(-10);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self.imageView);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageView);
        make.top.equalTo(self.imageView.mas_bottom).inset(5);
    }];
}


- (void)config:(id<TryOnItemInterface>)model status:(EFMaterialDownloadStatus)status select:(BOOL)select {
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSUInteger numberOfLink = [dataDetector numberOfMatchesInString:model.imageName options:NSMatchingReportProgress range:NSMakeRange(0, model.imageName.length)];
    if (numberOfLink > 0) { // url
        [self.imageView yy_setImageWithURL:[NSURL URLWithString:model.imageName] placeholder:[UIImage imageNamed:@"none"]];
    } else {
        self.imageView.image = [UIImage imageNamed:model.imageName];
    }

    if (status == EFMaterialDownloadStatusDownloading) {
        self.activity.hidden = NO;
        [self.activity startAnimating];
    }else{
        self.activity.hidden = YES;
        [self.activity stopAnimating];
    }
    self.selectImageView.hidden = !select;
    self.name.text = model.name;
    self.name.textColor = RGBA(82, 82, 82, 1);
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

-(UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.text = @"男生";
        _name.font = [UIFont systemFontOfSize:12];
    }
    return _name;
}

@end
