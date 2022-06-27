//
//  EFTryOnSegmentView.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/2/9.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "EFTryOnSegmentView.h"

@interface EFTryOnSegmentView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;

@end

@implementation EFTryOnSegmentView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

-(void)setItemsCount:(int)itemsCount {
    _itemsCount = itemsCount;
    if (!self.itemButtons) {
        self.itemButtons = [NSMutableArray array];
    }
    [self _customUIBy:itemsCount];
}

-(void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    if (currentIndex < self.itemButtons.count) {
        for (int i = 0; i < self.itemButtons.count; i ++) {
            self.itemButtons[i].layer.borderColor = currentIndex == i ? RGBA(221, 144, 250, 1).CGColor : UIColor.grayColor.CGColor;
        }
    }
}

-(void)_customUIBy:(int)itemsCount {
    if (self.subviews.count) {
        for (NSInteger i = 0; i < self.subviews.count; i ++) {
            UIView *curretnSubview = self.subviews[i];
            [curretnSubview removeFromSuperview];
        }
        [self.itemButtons removeAllObjects];
    }
    
    if (itemsCount == 0) return;
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    areaLabel.text = NSLocalizedString(@"区域", nil);
    areaLabel.textColor = UIColor.blackColor;
    areaLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    UIButton *lastItem;
    CGFloat buttonSize = 36;
    CGFloat spacing = 10;
    for (int i = 0; i < itemsCount; i ++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
        [item setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:14];
        item.layer.borderWidth = 1;
        item.layer.borderColor = UIColor.grayColor.CGColor;
        item.layer.cornerRadius = buttonSize / 2;
        item.clipsToBounds = YES;
        [item addTarget:self action:@selector(onItemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        if (!lastItem) {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(areaLabel.mas_trailing).inset(spacing);
                make.height.width.equalTo(@(buttonSize));
                make.centerY.equalTo(areaLabel);
            }];
        } else {
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(lastItem);
                make.centerY.equalTo(lastItem);
                make.leading.equalTo(lastItem.mas_trailing).inset(spacing);
            }];
        }
        lastItem = item;
        [self.itemButtons addObject:item];
    }
    self.currentIndex = 0;
}

-(void)onItemButtonClick:(UIButton *)itemButton {
    self.currentIndex = (int)[self.itemButtons indexOfObject:itemButton];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnSegmentView:segmentIndexChanged:)]) {
        [self.delegate tryOnSegmentView:self segmentIndexChanged:self.currentIndex];
    }
}

@end
