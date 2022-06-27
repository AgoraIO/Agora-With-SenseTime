//
//  EFTryOnViewController.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnViewController.h"
#import "EFTryOnView.h"

#import "EFTryOnLipsColorStrengthView.h"
#import "EFTryOnHairStrengthView.h"

#import "EFTryOnDatasourceManager.h"
#import "EFTryOnViewController+tryonViewDelegate.h"

@interface EFTryOnViewController () 

@property (nonatomic, strong) EFTryOnView * tryOnView;
@property (nonatomic, strong) EFTryOnDatasourceManager *tryOnDataSourceManager;

- (void)addSubviewsIsTryOn:(BOOL)isTryOn;

@end

@implementation EFTryOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addEffectsViews { // call from super
    [self.view addSubview:self.tryOnView];
    
    [self.tryOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.height.equalTo(@260);
    }];
}

-(void)beforeAddSubviews { // call from super
    [self addSubviewsIsTryOn:YES];
}

-(void)setDefaults{}
-(void)restoreAllCache {}
-(void)addOverlapButton {}
-(void)addModuleReorderButton {}

#pragma mark - actions
-(void)toast:(NSString *)toast {
    [EFToast show:self.view description:NSLocalizedString(toast, nil)];
}

#pragma mark - properties
-(EFTryOnView *)tryOnView {
    if (!_tryOnView) {
        _tryOnView = [[EFTryOnView alloc] initWithFrame:CGRectZero andDatasource:self.tryOnDataSourceManager];
        _tryOnView.backgroundColor = UIColor.clearColor;
        _tryOnView.delegate = self;
        _tryOnView.currentTryonBeauty = 0;
    }
    return _tryOnView;
}

-(EFTryOnDatasourceManager *)tryOnDataSourceManager {
    if (!_tryOnDataSourceManager) {
        _tryOnDataSourceManager = [[EFTryOnDatasourceManager alloc] init];
    }
    return _tryOnDataSourceManager;
}

@end
