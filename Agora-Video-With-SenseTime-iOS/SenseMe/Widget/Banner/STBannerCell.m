//
//  STBannerCell.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/4.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "STBannerCell.h"

@interface STBannerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation STBannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)configCellWithImage:(UIImage *)image {
    self.imageView.image = image;
}


- (void)addSubviews {
    [self addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        _imageView = imageView;
    }
    return _imageView;
}

@end
