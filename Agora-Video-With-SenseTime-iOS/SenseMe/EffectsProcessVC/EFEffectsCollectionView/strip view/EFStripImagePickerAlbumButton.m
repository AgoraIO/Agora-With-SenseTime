//
//  EFStripImagePickerAlbumButton.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/6.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStripImagePickerAlbumButton.h"

@interface EFStripImagePickerAlbumButton ()

@property (nonatomic, strong) UIImageView *efImageView;
@property (nonatomic, strong) UILabel *efTitleLabel;

@end

@implementation EFStripImagePickerAlbumButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
    }
    return self;
}

-(void)customUI {    
    self.efImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.efImageView];
    
    [self.efImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self).inset(20);
        make.top.equalTo(self).inset(10);
        make.height.equalTo(self.efImageView.mas_width);
    }];
    
    self.efImageView.image = [UIImage imageNamed:@"jia_icon"];
    
    self.efTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:self.efTitleLabel];
    
    [self.efTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.efImageView.mas_bottom).inset(5);
        make.bottom.equalTo(self).inset(10);
        make.leading.trailing.equalTo(self);
    }];
    
    self.efTitleLabel.text = NSLocalizedString(@"相册", nil);
    self.efTitleLabel.textColor = UIColor.whiteColor;
    self.efTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.efTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.efTitleLabel.numberOfLines = 1;
    self.efTitleLabel.font = [UIFont systemFontOfSize:12];
}

@end
