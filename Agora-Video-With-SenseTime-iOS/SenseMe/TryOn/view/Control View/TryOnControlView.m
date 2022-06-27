//
//  TryOnControlView.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "TryOnControlView.h"

#import "EFTryOnDatasourceManager.h"

#import "EFTryOnTitleView.h"

@interface TryOnControlView ()

@property (nonatomic, strong) EFTryOnDatasourceManager *dataSourceManager;

@property (nonatomic, strong) EFTryOnTitleView * tryOnTitleView;

@end

@implementation TryOnControlView

-(instancetype)initWithFrame:(CGRect)frame andDataSourceManager:(nonnull EFTryOnDatasourceManager *)dataSourceManager {
    self = [super initWithFrame:frame];
    if (self) {
        _dataSourceManager = dataSourceManager;
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    [self customTabs];
}

-(void)customTabs {
    self.tryOnTitleView = [[EFTryOnTitleView alloc] initWithDatasource:self.dataSourceManager.dataSource];
//    self.tryOnTitleView.delegate = self;
    [self addSubview:self.tryOnTitleView];
    [self.tryOnTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@46);
    }];
}

@end
