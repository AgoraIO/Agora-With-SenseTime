//
//  EFStripImagePickerCollectionViewCell.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/11/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStripImagePickerCollectionViewCell.h"

@interface EFStripImagePickerCollectionViewCell ()

@end

@implementation EFStripImagePickerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
    }
    return self;
}

-(void)customUI {
    self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.cornerRadius = 6;
    self.contentImageView.layer.masksToBounds = YES;
    self.contentImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.contentImageView];
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.selectedBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_select"]];
    self.selectedBorderView.hidden = YES;
    [self.contentView addSubview:self.selectedBorderView];
    
    [self.selectedBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentImageView);
        make.width.height.equalTo(self.contentImageView).offset(1);
    }];
}

-(UIImageView *)selectedBorderView {
    if (!_selectedBorderView) {
        _selectedBorderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_select"]];
    }
    return _selectedBorderView;
}

@end
