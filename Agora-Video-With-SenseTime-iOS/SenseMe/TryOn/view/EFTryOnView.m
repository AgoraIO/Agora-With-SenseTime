//
//  EFTryOnView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnView.h"

#import "EFTryOnTitleView.h"

#import "EFTryOnBeautyView.h"
#import "EFTryOnLipsAndHairView.h"
#import "EFTryOnColorWheelView.h"

#import "EFTryOnShotView.h"
#import "EFTryOnDatasourceManager.h"

@interface EFTryOnView () <EFTryOnTitleViewDelegate, EFTryOnLipsAndHairViewDelegate, EFTryOnColorWheelViewDelegate, EFTryOnShotViewDelegate, EFTryOnBeautyViewDelegate>

@property (nonatomic, strong) EFTryOnBeautyView * tryOnBeautyView;
@property (nonatomic, strong) EFTryOnLipsAndHairView * tryOnLipsView;
@property (nonatomic, strong) EFTryOnLipsAndHairView * tryOnHairView;
@property (nonatomic, strong) EFTryOnTitleView * tryOnTitleView;
@property (nonatomic, strong) EFTryOnColorWheelView * lipsColorWheelView;
@property (nonatomic, strong) EFTryOnColorWheelView * hairColorWheelView;

@property (nonatomic, strong) UIView * currentSelectedView;

@property (nonatomic, strong) EFTryOnShotView * shotView;

@property (nonatomic, strong) EFTryOnDatasourceManager * datasourceModel;

@property (nonatomic, strong) UIView *trickBackgroundView;

@property (nonatomic, strong) EFTryOnColorWheelView *colorWheelView;

@end

@implementation EFTryOnView
{
    st_effect_beauty_type_t _tryonType;
}

-(instancetype)initWithFrame:(CGRect)frame andDatasource:(EFTryOnDatasourceManager *)datasourceModel {
    self = [super initWithFrame:frame];
    if (self) {
        _datasourceModel = datasourceModel;
        [self customSubViews];
        _currentSelectedView = self.tryOnBeautyView;
    }
    return self;
}

-(void)customSubViews {
    self.trickBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.trickBackgroundView.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.trickBackgroundView];
    
    [self.trickBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self).inset(54);
    }];
    
    self.tryOnTitleView = [[EFTryOnTitleView alloc] initWithDatasource:self.datasourceModel.dataSource];
    self.tryOnTitleView.delegate = self;
    [self addSubview:self.tryOnTitleView];
    [self.tryOnTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@46);
        make.top.equalTo(self).inset(54);
    }];
    
    [self addSubview:self.tryOnBeautyView];
    [self.tryOnBeautyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.tryOnTitleView.mas_bottom);
        make.height.equalTo(@90);
    }];

    [self addSubview:self.shotView];
    [self.shotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.tryOnBeautyView.mas_bottom);
    }];

    [self insertSubview:self.tryOnLipsView belowSubview:self.tryOnTitleView];
    self.tryOnLipsView.hidden = YES;
    [self.tryOnLipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.tryOnBeautyView);
        make.height.equalTo(@190);
    }];
    
//    [self addSubview:self.tryOnHairView];
//    self.tryOnHairView.hidden = YES;
//    [self.tryOnHairView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.tryOnBeautyView);
//    }];
}

#pragma mark - datasource properties

//-(NSArray *)beautyDataSourceArray {
//    if (!_beautyDataSourceArray) {
//        EFDataSourceModel * beautyModel = self.datasourceModel.efSubDataSources[0];
//        _beautyDataSourceArray = [beautyModel.efSubDataSources copy];
//    }
//    return _beautyDataSourceArray;
//}

//-(NSArray *)hairDataSourceArray {
//    if (!_hairDataSourceArray) {
//        NSArray * datasourceDicts = @[
//            @{
//                @"name": @"方式",
//                @"imageName": @"tryon_haircolor_gray",
//                @"highlightImageName": @"tryon_haircolor_gray",
//                @"subDataSources": @[
//
//                ]
//            },
//            @{
//                @"name": @"颜色",
//                @"imageName": @"tryon_color_gray",
//                @"highlightImageName": @"tryon_color",
//                @"subDataSources": @[
//                        @{
//                            @"name": NSLocalizedString(@"无", nil),
//                             @"imageName": @"tryon_None"
//                         },
//                        @{
//                            @"name": NSLocalizedString(@"调色", nil),
//                            @"imageName": @"tryon_tinting"
//                        },
//                ]
//            },
//        ];
//        NSMutableArray * datasourceResult = [NSMutableArray array];
//        for (NSDictionary * info in datasourceDicts) {
//            EFDataSourceModel * model = [EFDataSourceModel yy_modelWithDictionary:info];
//            if ([model.efName isEqualToString:@"颜色"]) {
//                NSMutableArray * subArray = [NSMutableArray arrayWithArray:model.efSubDataSources];
//                [subArray addObjectsFromArray:((EFDataSourceModel *)self.datasourceModel.efSubDataSources[2]).efSubDataSources];
//                model.efSubDataSources = [subArray copy];
//            }
//            [datasourceResult addObject:model];
//        }
//        _hairDataSourceArray = [datasourceResult copy];
//    }
//    return _hairDataSourceArray;
//}

#pragma mark - subview properties
-(EFTryOnBeautyView *)tryOnBeautyView {
    if (!_tryOnBeautyView) {
        _tryOnBeautyView = [[EFTryOnBeautyView alloc] initWithDatasource:self.datasourceModel.dataSource.firstObject];
        _tryOnBeautyView.delegate = self;
    }
    return _tryOnBeautyView;
}

-(EFTryOnLipsAndHairView *)tryOnLipsView {
    if (!_tryOnLipsView) {
        _tryOnLipsView = [[EFTryOnLipsAndHairView alloc] init];
        _tryOnLipsView.delegate = self;
        _tryOnLipsView.tryonType = EFFECT_BEAUTY_TRYON_LIPSTICK;
    }
    return _tryOnLipsView;
}

-(EFTryOnLipsAndHairView *)tryOnHairView {
    if (!_tryOnHairView) {
        _tryOnHairView = [[EFTryOnLipsAndHairView alloc] init];
        _tryOnHairView.delegate = self;
        _tryOnHairView.tryonType = EFFECT_BEAUTY_TRYON_HAIR_COLOR;
    }
    return _tryOnHairView;
}

-(EFTryOnColorWheelView *)lipsColorWheelView {
    if (!_lipsColorWheelView) {
        _lipsColorWheelView = [[EFTryOnColorWheelView alloc] initWithHue:0.9710 saturation:0.7582 andBrightness:0.7137];
        _lipsColorWheelView.delegate = self;
    }
    return _lipsColorWheelView;
}

-(EFTryOnColorWheelView *)hairColorWheelView {
    if (!_hairColorWheelView) {
        _hairColorWheelView = [[EFTryOnColorWheelView alloc] initWithHue:0.0033 saturation:0.7556 andBrightness:0.5294];
        _hairColorWheelView.delegate = self;
    }
    return _hairColorWheelView;
}

-(EFTryOnShotView *)shotView {
    if (!_shotView) {
        _shotView = [[EFTryOnShotView alloc] initWithFrame:CGRectZero];
        _shotView.delegate = self;
    }
    return _shotView;
}

-(EFTryOnColorWheelView *)colorWheelView {
    if (!_colorWheelView) {
        _colorWheelView = [[EFTryOnColorWheelView alloc] initWithHue:0.9710 saturation:0.7582 andBrightness:0.7137];
        _colorWheelView.delegate = self;
    }
    return _colorWheelView;
}

-(void)showColorWheelView:(BOOL)isShow withDatasource:(id<TryOnDataElementInterface>)dataSource {
    if (isShow) {
        [self.superview addSubview:self.colorWheelView];
        [self.colorWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.colorWheelView.dataSource = dataSource;
        [self.superview bringSubviewToFront:self.colorWheelView];
    } else {
        [self.colorWheelView removeFromSuperview];
        self.colorWheelView = nil;
    }
    self.tryOnLipsView.hidden = isShow;
}

#pragma mark - properties
-(void)setLipstick:(st_effect_lipstick_finish_t)lipstick {
    _lipstick = lipstick;
    self.tryOnLipsView.lipstick = lipstick;
}

-(void)setCurrentTryonBeauty:(NSInteger)currentTryonBeauty {
    _currentTryonBeauty = currentTryonBeauty;
    self.tryOnBeautyView.currentTryonBeauty = currentTryonBeauty;
}

#pragma mark - EFTryOnTitleViewDelegate
-(void)tryOnTitleView:(EFTryOnTitleView *)tryOnTitleView titleChanged:(NSIndexPath *)indexPath withModel:(id<TryOnDataElementInterface>)model {
    if (_currentSelectedView) {
        _currentSelectedView.hidden = YES;
    }
    if ([model.name isEqualToString:@"美颜"]) {
        self.tryOnBeautyView.hidden = NO;
        _currentSelectedView = self.tryOnBeautyView;
    } else {
        self.tryOnLipsView.hidden = NO;
        self.tryOnLipsView.dataSource = model;
        _currentSelectedView = self.tryOnLipsView;
        _tryonType = EFFECT_BEAUTY_TRYON_LIPSTICK;
    }
}

#pragma mark - EFTryOnLipsAndHairViewDelegate
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView onTinting:(NSInteger)index {
//    if (tryOnLipsAndHairView == self.tryOnLipsView) { // 口红
//        if ([self.subviews containsObject:self.lipsColorWheelView]) {
//
//        } else {
//            UIColor * currentColor = [self getCurrentColorBy:EFFECT_BEAUTY_TRYON_LIPSTICK];
//            self.lipsColorWheelView.currentColor = currentColor;
//            [self addSubview:self.lipsColorWheelView];
//            [self.lipsColorWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self);
//            }];
//        }
//    } else { // 染发
//        if ([self.subviews containsObject:self.hairColorWheelView]) {
//
//        } else {
//            UIColor * currentColor = [self getCurrentColorBy:EFFECT_BEAUTY_TRYON_HAIR_COLOR];
//            self.hairColorWheelView.currentColor = currentColor;
//            [self addSubview:self.hairColorWheelView];
//            [self.hairColorWheelView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self);
//            }];
//        }
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView selectedModel:(EFRenderModel *)renderModel withTryonType:(st_effect_beauty_type_t)tryonType {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:lipsOrHairSelected:withTryonType:)]) {
//        [self.delegate tryOnView:self lipsOrHairSelected:renderModel withTryonType:tryonType];
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView selectedColorModel:(EFRenderModel *)renderModel withTryonType:(st_effect_beauty_type_t)tryonType {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:colorModelSelected:withTryonType:)]) {
//        [self.delegate tryOnView:self colorModelSelected:renderModel withTryonType:tryonType];
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowColorStrength:(BOOL)isShow {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:isShowColorStrength:)]) {
//        [self.delegate tryOnView:self isShowColorStrength:isShow];
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowBrightnessStrength:(BOOL)isShow {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:isShowBrightnessStrength:)]) {
//        [self.delegate tryOnView:self isShowBrightnessStrength:isShow];
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowHairColorStrength:(BOOL)isShow {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:isShowHairColorStrength:)]) {
//        [self.delegate tryOnView:self isShowHairColorStrength:isShow];
//    }
//}
//
//-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView isShowHairStrength:(BOOL)isShow {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:isShowHairStrength:)]) {
//        [self.delegate tryOnView:self isShowHairStrength:YES];
//    }
//}

-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView isShowColorWheel:(BOOL)isShow andDatasource:(id<TryOnDataElementInterface>)dataSource {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showColorWheelView:isShow withDatasource:dataSource];
    });
}

-(void)tryOnLipsAndHairView:(EFTryOnLipsAndHairView *)tryOnLipsAndHairView showToast:(NSString *)toast {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:showToast:)]) {
        [self.delegate tryOnView:self showToast:toast];
    }
}

-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView selectedMaterial:(SenseArMaterial *)material andBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(nonnull id<TryOnDataElementInterface>)dataSource {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:selectedMaterial:andBeautyType:andDataSource:)]) {
        [self.delegate tryOnView:self selectedMaterial:material andBeautyType:beautyType andDataSource:dataSource];
    }
}

-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView cancelTryOnBeautyType:(st_effect_beauty_type_t)beautyType andDataSource:(nonnull id<TryOnDataElementInterface>)dataSource {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:cancelTryOnBeautyType:andDataSource:)]) {
        [self.delegate tryOnView:self cancelTryOnBeautyType:beautyType andDataSource:dataSource];
    }
}

-(void)tryOnView:(EFTryOnLipsAndHairView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:updateTryOnInfo:withBeautyType:)]) {
        [self.delegate tryOnView:self updateTryOnInfo:tryOnBeautyInfo withBeautyType:beautyType];
    }
}

#pragma mark - EFTryOnColorWheelViewDelegate
-(void)tryOnColorWheelView:(EFTryOnColorWheelView *)tryonView updateTryOnInfo:(st_effect_tryon_info_t *)tryOnBeautyInfo withBeautyType:(st_effect_beauty_type_t)beautyType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:updateTryOnInfo:withBeautyType:)]) {
        [self.delegate tryOnView:self updateTryOnInfo:tryOnBeautyInfo withBeautyType:beautyType];
    }
}

-(void)tryOnColorWheelViewCanceled:(EFTryOnColorWheelView *)tryOnColorWheelView {
    [self showColorWheelView:NO withDatasource:nil];
}

#pragma mark - EFTryOnShotViewDelegate
-(void)tryOnShotView:(EFTryOnShotView *)shotView onShotButtonClick:(UIButton *)shotButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnShotBy:)]) {
        [self.delegate tryOnShotBy:self];
    }
}

#pragma mark - EFTryOnBeautyViewDelegate
-(void)tryOnBeautyView:(EFTryOnBeautyView *)tryOnBeautyView selectModel:(id<TryOnBeautyItemInterface>)model withIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:beautySelected:)]) {
        [self.delegate tryOnView:self beautySelected:model];
    }
}

-(void)tryOnBeautyView:(EFTryOnBeautyView *)tryOnBeautyView deselectModel:(id<TryOnBeautyItemInterface>)model withIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:beautyDeselected:)]) {
        [self.delegate tryOnView:self beautyDeselected:model];
    }
}

#pragma mark - helper
-(UIColor *)getCurrentColorBy:(st_effect_beauty_type_t)tryonType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:updateColorWheelBy:)]) {
        UIColor * currentColor = [self.delegate tryOnView:self updateColorWheelBy:tryonType];
        return currentColor;
    }
    return nil;
}

@end
