//
//  SenseBeautifyView.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/20.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseBeautifyView.h"
#import "STBMPCollectionView.h"
#import "STBeautySlider.h"
#import "STBmpStrengthView.h"
#import "STScrollTitleView.h"
#import "STCollectionView.h"
#import "STViewButton.h"
#import "STMobileLog.h"
#import "STFilterView.h"

#import "SenseBeautifyManager.h"

@interface SenseBeautifyView () <STBeautySliderDelegate, STBMPCollectionViewDelegate, STBmpStrengthViewDelegate> {

}

@property (nonatomic, strong) STScrollTitleView *beautyScrollTitleViewNew;
@property (nonatomic, readwrite, strong) STFilterCollectionView *filterCollectionView;
@property (nonatomic, readwrite, strong) STFilterView *filterView;
@property (nonatomic, readwrite, strong) UIView *filterStrengthView;
@property (nonatomic, readwrite, strong) UISlider *filterStrengthSlider;
@property (nonatomic, strong) UILabel *lblFilterStrength;
@property (nonatomic, strong) STNewBeautyCollectionView *beautyCollectionView;
@property (nonatomic, strong) STBeautySlider *beautySlider;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) STBMPCollectionView *bmpColView;
@property (nonatomic, strong) STBmpStrengthView *bmpStrenghView;
@property (nonatomic, readwrite, strong) UIView *filterCategoryView;

@property (nonatomic, readwrite, strong) NSMutableArray *arrBeautyViews;
@property (nonatomic, readwrite, strong) NSMutableArray<STViewButton *> *arrFilterCategoryViews;

@property (nonatomic, assign) STEffectsType curEffectBeautyType;
@property (nonatomic, assign) STBeautyType curBeautyBeautyType;

@property (nonatomic, readwrite, strong) STCollectionViewDisplayModel *currentSelectedFilterModel;

@property (nonatomic, strong) SenseBeautifyManager *senseBeautifyManager;

@end

@implementation SenseBeautifyView

- (void)initSenseBeautifyManager:(SenseBeautifyManager *)manager {
    _senseBeautifyManager = manager;
    [self initResource];
    [self setupViews];
    [self initDefaultValue];
}

- (void)initResource {
    self.curEffectBeautyType = STEffectsTypeBeautyBase;
    
    //默认选中cherry滤镜
    _filterView.filterCollectionView.arrModels = _filterView.filterCollectionView.arrPortraitFilterModels;
    [_filterView.filterCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self getBabyPinkFilterIndex] inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    self.filterStrengthView.hidden = YES;
}

-(void)setupViews {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.beautyScrollTitleViewNew];
    
    UIView *whiteLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40 + SliderHeight, SCREEN_WIDTH, 1)];
    whiteLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self addSubview:whiteLineView];
    
    [self addSubview:self.filterCategoryView];
    [self addSubview:self.filterView];
    [self addSubview:self.bmpColView];
    [self addSubview:self.beautyCollectionView];

    [self.arrBeautyViews addObject:self.filterCategoryView];
    [self.arrBeautyViews addObject:self.filterView];
    [self.arrBeautyViews addObject:self.beautyCollectionView];
    
    [self addSubview:self.filterStrengthView];
    [self addSubview:self.beautySlider];
    [self addSubview:self.resetBtn];
}

#pragma mark -- setup view
- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 180 + SliderHeight, 100, 30)];
        [_resetBtn setImage:[UIImage imageNamed:@"reset"] forState:UIControlStateNormal];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_resetBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBeautyValues:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (STBeautySlider *)beautySlider {
    if (!_beautySlider) {
        
        _beautySlider = [[STBeautySlider alloc] initWithFrame:CGRectMake(40, -5, SCREEN_WIDTH - 90, SliderHeight)];
        _beautySlider.thumbTintColor = UIColorFromRGB(0x9e4fcb);
        _beautySlider.minimumTrackTintColor = UIColorFromRGB(0x9e4fcb);
        _beautySlider.maximumTrackTintColor = [UIColor whiteColor];
        _beautySlider.minimumValue = -1;
        _beautySlider.maximumValue = 1;
        _beautySlider.value = -1;
        _beautySlider.hidden = YES;
        _beautySlider.delegate = self;
        [_beautySlider addTarget:self action:@selector(beautySliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySlider;
}

- (UIView *)filterStrengthView {
    
    if (!_filterStrengthView) {
        
        _filterStrengthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SliderHeight)];
        _filterStrengthView.backgroundColor = [UIColor clearColor];
        _filterStrengthView.hidden = YES;
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 10, 35.5)];
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.font = [UIFont systemFontOfSize:11];
        leftLabel.text = @"0";
        [_filterStrengthView addSubview:leftLabel];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 90, 35.5)];
        slider.thumbTintColor = UIColorFromRGB(0x9e4fcb);
        slider.minimumTrackTintColor = UIColorFromRGB(0x9e4fcb);
        slider.maximumTrackTintColor = [UIColor whiteColor];
        slider.value = 1;
        [slider addTarget:self action:@selector(filterSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _filterStrengthSlider = slider;
        [_filterStrengthView addSubview:slider];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 20, 35.5)];
        rightLabel.textColor = [UIColor whiteColor];
        rightLabel.font = [UIFont systemFontOfSize:11];
        rightLabel.text = [NSString stringWithFormat:@"%d", (int)(self.senseBeautifyManager.fFilterStrength * 100)];
        _lblFilterStrength = rightLabel;
        [_filterStrengthView addSubview:rightLabel];
    }
    return _filterStrengthView;
}

- (STNewBeautyCollectionView *)beautyCollectionView {
    
    if (!_beautyCollectionView) {
        
        STWeakSelf;
        
        _beautyCollectionView = [[STNewBeautyCollectionView alloc] initWithFrame:CGRectMake(0, 41 + SliderHeight, SCREEN_WIDTH, 220) models:self.senseBeautifyManager.baseBeautyModels delegateBlock:^(STNewBeautyCollectionViewModel *model) {
            [weakSelf handleBeautyTypeChanged:model];
        }];
        
        _beautyCollectionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        [_beautyCollectionView reloadData];
    }
    return _beautyCollectionView;
}

- (STBMPCollectionView *)bmpColView
{
    if (!_bmpColView) {
        _bmpColView = [[STBMPCollectionView alloc] initWithFrame:CGRectMake(0, 41 + SliderHeight, SCREEN_WIDTH, 220)];
        _bmpColView.delegate = self;
        _bmpColView.hidden = YES;
        _bmpStrenghView = [[STBmpStrengthView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SliderHeight)];
        _bmpStrenghView.backgroundColor = [UIColor clearColor];
        _bmpStrenghView.hidden = YES;
        _bmpStrenghView.delegate = self;
        [self addSubview:_bmpStrenghView];
    }
    return _bmpColView;
}

- (STFilterView *)filterView {
    
    if (!_filterView) {
        _filterView = [[STFilterView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 41 + SliderHeight, SCREEN_WIDTH, 300)];
        _filterView.leftView.imageView.image = [UIImage imageNamed:@"still_life_highlighted"];
        _filterView.leftView.titleLabel.text = @"静物";
        _filterView.leftView.titleLabel.textColor = [UIColor whiteColor];
        
        _filterView.filterCollectionView.arrSceneryFilterModels = [self.senseBeautifyManager getFilterModelsByType:STEffectsTypeFilterScenery];
        _filterView.filterCollectionView.arrPortraitFilterModels = [self.senseBeautifyManager getFilterModelsByType:STEffectsTypeFilterPortrait];
        _filterView.filterCollectionView.arrStillLifeFilterModels = [self.senseBeautifyManager getFilterModelsByType:STEffectsTypeFilterStillLife];
        _filterView.filterCollectionView.arrDeliciousFoodFilterModels = [self.senseBeautifyManager getFilterModelsByType:STEffectsTypeFilterDeliciousFood];
        
        STWeakSelf;
        _filterView.filterCollectionView.delegateBlock = ^(STCollectionViewDisplayModel *model) {
            [weakSelf handleFilterChanged:model];
        };
        _filterView.block = ^{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.filterCategoryView.frame = CGRectMake(0, weakSelf.filterCategoryView.frame.origin.y, SCREEN_WIDTH, 300);
                weakSelf.filterView.frame = CGRectMake(SCREEN_WIDTH, weakSelf.filterView.frame.origin.y, SCREEN_WIDTH, 300);
            }];
            weakSelf.filterStrengthView.hidden = YES;
        };
    }
    return _filterView;
}

- (UIView *)filterCategoryView {
    
    if (!_filterCategoryView) {
        
        _filterCategoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 41 + SliderHeight, SCREEN_WIDTH, 300)];
        _filterCategoryView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        
        STViewButton *portraitViewBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        portraitViewBtn.tag = STEffectsTypeFilterPortrait;
        portraitViewBtn.backgroundColor = [UIColor clearColor];
        portraitViewBtn.frame =  CGRectMake(SCREEN_WIDTH / 2 - 143, 58, 33, 60);
        portraitViewBtn.imageView.image = [UIImage imageNamed:@"portrait"];
        portraitViewBtn.imageView.highlightedImage = [UIImage imageNamed:@"portrait_highlighted"];
        portraitViewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        portraitViewBtn.titleLabel.textColor = [UIColor whiteColor];
        portraitViewBtn.titleLabel.highlightedTextColor = [UIColor whiteColor];
        portraitViewBtn.titleLabel.text = @"人物";
        
        for (UIGestureRecognizer *recognizer in portraitViewBtn.gestureRecognizers) {
            [portraitViewBtn removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer *portraitRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchFilterType:)];
        [portraitViewBtn addGestureRecognizer:portraitRecognizer];
        [self.arrFilterCategoryViews addObject:portraitViewBtn];
        [_filterCategoryView addSubview:portraitViewBtn];
        
        STViewButton *sceneryViewBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        sceneryViewBtn.tag = STEffectsTypeFilterScenery;
        sceneryViewBtn.backgroundColor = [UIColor clearColor];
        sceneryViewBtn.frame =  CGRectMake(SCREEN_WIDTH / 2 - 60, 58, 33, 60);
        sceneryViewBtn.imageView.image = [UIImage imageNamed:@"scenery"];
        sceneryViewBtn.imageView.highlightedImage = [UIImage imageNamed:@"scenery_highlighted"];
        sceneryViewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sceneryViewBtn.titleLabel.textColor = [UIColor whiteColor];
        sceneryViewBtn.titleLabel.highlightedTextColor = [UIColor whiteColor];
        sceneryViewBtn.titleLabel.text = @"风景";
        
        for (UIGestureRecognizer *recognizer in sceneryViewBtn.gestureRecognizers) {
            [sceneryViewBtn removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer *sceneryRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchFilterType:)];
        [sceneryViewBtn addGestureRecognizer:sceneryRecognizer];
        [self.arrFilterCategoryViews addObject:sceneryViewBtn];
        [_filterCategoryView addSubview:sceneryViewBtn];
        
        STViewButton *stillLifeViewBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        stillLifeViewBtn.tag = STEffectsTypeFilterStillLife;
        stillLifeViewBtn.backgroundColor = [UIColor clearColor];
        stillLifeViewBtn.frame =  CGRectMake(SCREEN_WIDTH / 2 + 27, 58, 33, 60);
        stillLifeViewBtn.imageView.image = [UIImage imageNamed:@"still_life"];
        stillLifeViewBtn.imageView.highlightedImage = [UIImage imageNamed:@"still_life_highlighted"];
        stillLifeViewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        stillLifeViewBtn.titleLabel.textColor = [UIColor whiteColor];
        stillLifeViewBtn.titleLabel.highlightedTextColor = [UIColor whiteColor];
        stillLifeViewBtn.titleLabel.text = @"静物";
        
        for (UIGestureRecognizer *recognizer in stillLifeViewBtn.gestureRecognizers) {
            [stillLifeViewBtn removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer *stillLifeRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchFilterType:)];
        [stillLifeViewBtn addGestureRecognizer:stillLifeRecognizer];
        [self.arrFilterCategoryViews addObject:stillLifeViewBtn];
        [_filterCategoryView addSubview:stillLifeViewBtn];
        
        STViewButton *deliciousFoodViewBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        deliciousFoodViewBtn.tag = STEffectsTypeFilterDeliciousFood;
        deliciousFoodViewBtn.backgroundColor = [UIColor clearColor];
        deliciousFoodViewBtn.frame =  CGRectMake(SCREEN_WIDTH / 2 + 110, 58, 33, 60);
        deliciousFoodViewBtn.imageView.image = [UIImage imageNamed:@"delicious_food"];
        deliciousFoodViewBtn.imageView.highlightedImage = [UIImage imageNamed:@"delicious_food_highlighted"];
        deliciousFoodViewBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        deliciousFoodViewBtn.titleLabel.textColor = [UIColor whiteColor];
        deliciousFoodViewBtn.titleLabel.highlightedTextColor = [UIColor whiteColor];
        deliciousFoodViewBtn.titleLabel.text = @"美食";
        
        for (UIGestureRecognizer *recognizer in deliciousFoodViewBtn.gestureRecognizers) {
            [deliciousFoodViewBtn removeGestureRecognizer:recognizer];
        }
        UITapGestureRecognizer *deliciousFoodRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchFilterType:)];
        [deliciousFoodViewBtn addGestureRecognizer:deliciousFoodRecognizer];
        [self.arrFilterCategoryViews addObject:deliciousFoodViewBtn];
        [_filterCategoryView addSubview:deliciousFoodViewBtn];
        
    }
    return _filterCategoryView;
}

- (STScrollTitleView *)beautyScrollTitleViewNew {
    
    if (!_beautyScrollTitleViewNew) {
        
        NSArray *beautyCategory = @[@"基础美颜", @"美形", @"微整形", @"美妆",@"滤镜", @"调整"];
        NSArray *beautyType = @[@(STEffectsTypeBeautyBase),
                                @(STEffectsTypeBeautyShape),
                                @(STEffectsTypeBeautyMicroSurgery),
                                @(STEffectsTypeBeautyMakeUp),
                                @(STEffectsTypeBeautyFilter),
                                @(STEffectsTypeBeautyAdjust)];
        
        STWeakSelf;
        _beautyScrollTitleViewNew = [[STScrollTitleView alloc] initWithFrame:CGRectMake(0, SliderHeight, SCREEN_WIDTH, 40) titles:beautyCategory effectsType:beautyType titleOnClick:^(STTitleViewItem *titleView, NSInteger index, STEffectsType type) {
            [weakSelf handleEffectsType:type];
        }];
        _beautyScrollTitleViewNew.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _beautyScrollTitleViewNew;
}

#pragma mark -- on touch
- (void)switchFilterType:(UITapGestureRecognizer *)recognizer {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.filterCategoryView.frame = CGRectMake(-SCREEN_WIDTH, self.filterCategoryView.frame.origin.y, SCREEN_WIDTH, 300);
        self.filterView.frame = CGRectMake(0, self.filterView.frame.origin.y, SCREEN_WIDTH, 300);
    }];
    
    if (self.currentSelectedFilterModel.modelType == recognizer.view.tag && self.currentSelectedFilterModel.isSelected) {
        self.filterStrengthView.hidden = NO;
    } else {
        self.filterStrengthView.hidden = YES;
    }
    
    switch (recognizer.view.tag) {
            
        case STEffectsTypeFilterPortrait:
            
            _filterView.leftView.imageView.image = [UIImage imageNamed:@"portrait_highlighted"];
            _filterView.leftView.titleLabel.text = @"人物";
            _filterView.filterCollectionView.arrModels = _filterView.filterCollectionView.arrPortraitFilterModels;
            
            break;
            
            
        case STEffectsTypeFilterScenery:
            
            _filterView.leftView.imageView.image = [UIImage imageNamed:@"scenery_highlighted"];
            _filterView.leftView.titleLabel.text = @"风景";
            _filterView.filterCollectionView.arrModels = _filterView.filterCollectionView.arrSceneryFilterModels;
            
            break;
            
        case STEffectsTypeFilterStillLife:
            
            _filterView.leftView.imageView.image = [UIImage imageNamed:@"still_life_highlighted"];
            _filterView.leftView.titleLabel.text = @"静物";
            _filterView.filterCollectionView.arrModels = _filterView.filterCollectionView.arrStillLifeFilterModels;
            
            break;
            
        case STEffectsTypeFilterDeliciousFood:
            
            _filterView.leftView.imageView.image = [UIImage imageNamed:@"delicious_food_highlighted"];
            _filterView.leftView.titleLabel.text = @"美食";
            _filterView.filterCollectionView.arrModels = _filterView.filterCollectionView.arrDeliciousFoodFilterModels;
            
            break;
            
        default:
            break;
    }
    
    [_filterView.filterCollectionView reloadData];
}

#pragma mark -- on click
- (void)beautySliderValueChanged:(UISlider *)sender {
    //[-1,1] -> [0,1]
    float value1 = (sender.value + 1) / 2;
    
    //[-1,1]
    float value2 = sender.value;
    
    STNewBeautyCollectionViewModel *model = self.beautyCollectionView.selectedModel;
    
    switch (model.beautyType) {
            
        case STBeautyTypeNone:
            break;
        case STBeautyTypeWhiten:
        case STBeautyTypeRuddy:
        case STBeautyTypeDermabrasion:
        case STBeautyTypeDehighlight:
        case STBeautyTypeShrinkFace:
        case STBeautyTypeNarrowFace:
        case STBeautyTypeEnlargeEyes:
        case STBeautyTypeShrinkJaw:
        case STBeautyTypeThinFaceShape:
        case STBeautyTypeNarrowNose:
        case STBeautyTypeContrast:
        case STBeautyTypeSaturation:
        case STBeautyTypeAppleMusle:
        case STBeautyTypeProfileRhinoplasty:
        case STBeautyTypeBrightEye:
        case STBeautyTypeRemoveDarkCircles:
        case STBeautyTypeWhiteTeeth:
        case STBeautyTypeOpenCanthus:
        case STBeautyTypeRemoveNasolabialFolds:
            [self.senseBeautifyManager beautySliderValueChanged:value1 beautySelectModel:model];
            model.beautyValue = value1 * 100;
            break;
            
        case STBeautyTypeChin:
        case STBeautyTypeHairLine:
        case STBeautyTypeLengthNose:
        case STBeautyTypeMouthSize:
        case STBeautyTypeLengthPhiltrum:
        case STBeautyTypeEyeDistance:
        case STBeautyTypeEyeAngle:
            [self.senseBeautifyManager beautySliderValueChanged:value2 beautySelectModel:model];
            model.beautyValue = value2 * 100;
            break;
    }
    [self.beautyCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.modelIndex inSection:0]]];
}

- (void)filterSliderValueChanged:(UISlider *)sender {
    _lblFilterStrength.text = [NSString stringWithFormat:@"%d", (int)(sender.value * 100)];
    [self.senseBeautifyManager filterSliderValueChanged: sender.value];
}

- (void)initDefaultValue {
    self.lblFilterStrength.text = @"65";
    self.filterStrengthSlider.value = 0.65;

    self.currentSelectedFilterModel.isSelected = NO;
    [self refreshFilterCategoryState:STEffectsTypeNone];
    self.beautyCollectionView.selectedModel = nil;
    [self.beautyCollectionView reloadData];
}

- (void)resetBeautyValues:(UIButton *)sender {
    
    switch (_curEffectBeautyType) {
        //reset filter to baby pink
        case STEffectsTypeBeautyFilter:
        {
            [self refreshFilterCategoryState:STEffectsTypeFilterPortrait];

            self.lblFilterStrength.text = @"65";
            self.filterStrengthSlider.value = 0.65;
            
            if (self.filterView.filterCollectionView.selectedModel.modelType == STEffectsTypeFilterPortrait) {
                
                self.filterView.filterCollectionView.selectedModel.isSelected = NO;
                self.filterView.filterCollectionView.arrPortraitFilterModels[[self getBabyPinkFilterIndex]].isSelected = YES;
                [self.filterView.filterCollectionView reloadData];
                
            } else {
                
                self.filterStrengthView.hidden = YES;
                self.filterView.filterCollectionView.selectedModel.isSelected = NO;
                [self.filterView.filterCollectionView reloadData];
                self.filterView.filterCollectionView.selectedModel = nil;
                self.filterView.filterCollectionView.arrPortraitFilterModels[[self getBabyPinkFilterIndex]].isSelected = YES;
            }
            
            STCollectionViewDisplayModel *selectedFilterModel = self.filterView.filterCollectionView.arrPortraitFilterModels[[self getBabyPinkFilterIndex]];
            self.filterView.filterCollectionView.selectedModel = selectedFilterModel;
            
            self.currentSelectedFilterModel = self.filterView.filterCollectionView.arrPortraitFilterModels[[self getBabyPinkFilterIndex]];
        }
        default:
            break;
            
    }
    
    [self.senseBeautifyManager resetBeautyValuesWithType:_curEffectBeautyType filterModelPath:self.currentSelectedFilterModel.strPath];

    [self.beautyCollectionView reloadData];
    
    switch (self.beautyCollectionView.selectedModel.beautyType) {
            
        case STBeautyTypeNone:
        case STBeautyTypeWhiten:
        case STBeautyTypeRuddy:
        case STBeautyTypeDermabrasion:
        case STBeautyTypeDehighlight:
        case STBeautyTypeShrinkFace:
        case STBeautyTypeEnlargeEyes:
        case STBeautyTypeShrinkJaw:
        case STBeautyTypeThinFaceShape:
        case STBeautyTypeNarrowNose:
        case STBeautyTypeContrast:
        case STBeautyTypeSaturation:
        case STBeautyTypeNarrowFace:
        case STBeautyTypeAppleMusle:
        case STBeautyTypeProfileRhinoplasty:
        case STBeautyTypeBrightEye:
        case STBeautyTypeRemoveDarkCircles:
        case STBeautyTypeWhiteTeeth:
        case STBeautyTypeOpenCanthus:
        case STBeautyTypeRemoveNasolabialFolds:
            
            self.beautySlider.value = self.beautyCollectionView.selectedModel.beautyValue / 50.0 - 1;
            
            break;
            
            
        case STBeautyTypeChin:
        case STBeautyTypeHairLine:
        case STBeautyTypeLengthNose:
        case STBeautyTypeMouthSize:
        case STBeautyTypeLengthPhiltrum:
        case STBeautyTypeEyeDistance:
        case STBeautyTypeEyeAngle:
            
            self.beautySlider.value = self.beautyCollectionView.selectedModel.beautyValue / 100.0;
            
            break;
    }
}

- (void)handleBeautyTypeChanged:(STNewBeautyCollectionViewModel *)model {
    
    float preType = self.curBeautyBeautyType;
    float preValue = self.beautySlider.value;
    float curValue = -2;
    float lblVal = -2;
    
    self.curBeautyBeautyType = model.beautyType;
    
    self.beautySlider.hidden = NO;

    switch (model.beautyType) {
            
        case STBeautyTypeNone:
        case STBeautyTypeWhiten:
        case STBeautyTypeRuddy:
        case STBeautyTypeDermabrasion:
        case STBeautyTypeDehighlight:
        case STBeautyTypeShrinkFace:
        case STBeautyTypeEnlargeEyes:
        case STBeautyTypeShrinkJaw:
        case STBeautyTypeThinFaceShape:
        case STBeautyTypeNarrowNose:
        case STBeautyTypeContrast:
        case STBeautyTypeSaturation:
        case STBeautyTypeNarrowFace:
        case STBeautyTypeAppleMusle:
        case STBeautyTypeProfileRhinoplasty:
        case STBeautyTypeBrightEye:
        case STBeautyTypeRemoveDarkCircles:
        case STBeautyTypeWhiteTeeth:
        case STBeautyTypeOpenCanthus:
        case STBeautyTypeRemoveNasolabialFolds:
            curValue = model.beautyValue / 50.0 - 1;
            lblVal = (curValue + 1) * 50.0;
            break;

        case STBeautyTypeChin:
        case STBeautyTypeHairLine:
        case STBeautyTypeLengthNose:
        case STBeautyTypeMouthSize:
        case STBeautyTypeLengthPhiltrum:
        case STBeautyTypeEyeAngle:
        case STBeautyTypeEyeDistance:
            curValue = model.beautyValue / 100.0;
            lblVal = curValue * 100.0;
            break;
    }
    
    if (curValue == preValue && preType != model.beautyType) {
        self.beautySlider.valueLabel.text = [NSString stringWithFormat:@"%d", (int)lblVal];
    }
    self.beautySlider.value = curValue;
}

- (void)handleEffectsType:(STEffectsType)type {
    
    switch (type) {
        case STEffectsTypeBeautyFilter:
        case STEffectsTypeBeautyBase:
        case STEffectsTypeBeautyShape:
        case STEffectsTypeBeautyMicroSurgery:
        case STEffectsTypeBeautyAdjust:
            self.curEffectBeautyType = type;
            break;
        case STEffectsTypeBeautyMakeUp:
            self.curEffectBeautyType = type;
            break;
        default:
            break;
    }
    
    if (type != STEffectsTypeBeautyFilter) {
        self.filterStrengthView.hidden = YES;
    }
    
    if (type == self.beautyCollectionView.selectedModel.modelType) {
        self.beautySlider.hidden = NO;
    } else {
        self.beautySlider.hidden = YES;
    }
    
    switch (type) {
        case STEffectsTypeBeautyFilter:
            
            self.filterCategoryView.hidden = NO;
            self.filterView.hidden = NO;
            self.beautyCollectionView.hidden = YES;
            
            self.filterCategoryView.center = CGPointMake(SCREEN_WIDTH / 2, self.filterCategoryView.center.y);
            self.filterView.center = CGPointMake(SCREEN_WIDTH * 3 / 2, self.filterView.center.y);
            
            _bmpColView.hidden = YES;
            _bmpStrenghView.hidden = YES;
            
            break;
            
        case STEffectsTypeBeautyMakeUp:
            self.beautyCollectionView.hidden = YES;
            self.filterCategoryView.hidden = YES;
            self.filterView.hidden = YES;
            
            _bmpColView.hidden = NO;
            
        case STEffectsTypeNone:
            break;
            
        case STEffectsTypeBeautyShape:
            self.filterStrengthView.hidden = YES;
            
            self.beautyCollectionView.hidden = NO;
            self.filterCategoryView.hidden = YES;
            self.beautyCollectionView.models = self.senseBeautifyManager.beautyShapeModels;
            [self.beautyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            _bmpColView.hidden = YES;
            _bmpStrenghView.hidden = YES;
            
            break;
            
        case STEffectsTypeBeautyBase:
            
            self.filterStrengthView.hidden = YES;
            [self hideBeautyViewExcept:self.beautyCollectionView];
            
            self.beautyCollectionView.hidden = NO;
            self.filterCategoryView.hidden = YES;
            self.beautyCollectionView.models = self.senseBeautifyManager.baseBeautyModels;
            [self.beautyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            _bmpColView.hidden = YES;
            _bmpStrenghView.hidden = YES;
            
            break;
            
        case STEffectsTypeBeautyMicroSurgery:
            
            [self hideBeautyViewExcept:self.beautyCollectionView];
            self.beautyCollectionView.hidden = NO;
            self.filterCategoryView.hidden = YES;
            self.beautyCollectionView.models = self.senseBeautifyManager.microSurgeryModels;
            [self.beautyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            _bmpColView.hidden = YES;
            _bmpStrenghView.hidden = YES;
            
            break;
            
        case STEffectsTypeBeautyAdjust:
            [self hideBeautyViewExcept:self.beautyCollectionView];
            self.beautyCollectionView.hidden = NO;
            self.filterCategoryView.hidden = YES;
            self.beautyCollectionView.models = self.senseBeautifyManager.adjustModels;
            [self.beautyCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            
            _bmpColView.hidden = YES;
            _bmpStrenghView.hidden = YES;
            
            break;
            
            
        case STEffectsTypeBeautyBody:
            
            self.filterStrengthView.hidden = YES;
            break;
            
        default:
            break;
    }
    
}

- (void)hideBeautyViewExcept:(UIView *)view {
    for (UIView *beautyView in self.arrBeautyViews) {
        beautyView.hidden = !(view == beautyView);
    }
}

#pragma mark - lazy load array
- (NSMutableArray *)arrBeautyViews {
    if (!_arrBeautyViews) {
        _arrBeautyViews = [NSMutableArray array];
    }
    return _arrBeautyViews;
}

- (NSMutableArray *)arrFilterCategoryViews {
    
    if (!_arrFilterCategoryViews) {
        
        _arrFilterCategoryViews = [NSMutableArray array];
    }
    return _arrFilterCategoryViews;
}

#pragma mark - collectionview click events
- (void)handleFilterChanged:(STCollectionViewDisplayModel *)model {
    self.currentSelectedFilterModel = model;

    if (model.index > 0) {
        self.filterStrengthView.hidden = NO;
    } else {
        self.filterStrengthView.hidden = YES;
    }

    self.filterStrengthSlider.value = self.senseBeautifyManager.fFilterStrength;
    [self refreshFilterCategoryState:model.modelType];
    [self.senseBeautifyManager handleFilterChanged:model];
}

#pragma mark - STBeautySliderDelegate
- (CGFloat)currentSliderValue:(float)value slider:(UISlider *)slider {
    
    switch (self.curBeautyBeautyType) {
            
        case STBeautyTypeNone:
        case STBeautyTypeWhiten:
        case STBeautyTypeRuddy:
        case STBeautyTypeDermabrasion:
        case STBeautyTypeDehighlight:
        case STBeautyTypeShrinkFace:
        case STBeautyTypeEnlargeEyes:
        case STBeautyTypeShrinkJaw:
        case STBeautyTypeThinFaceShape:
        case STBeautyTypeNarrowNose:
        case STBeautyTypeContrast:
        case STBeautyTypeSaturation:
        case STBeautyTypeNarrowFace:
        case STBeautyTypeAppleMusle:
        case STBeautyTypeProfileRhinoplasty:
        case STBeautyTypeBrightEye:
        case STBeautyTypeRemoveDarkCircles:
        case STBeautyTypeWhiteTeeth:
        case STBeautyTypeOpenCanthus:
        case STBeautyTypeRemoveNasolabialFolds:
            value = (value + 1) / 2.0;
            break;
            
        default:
            break;
            
    }
    
    return value;
}

#pragma STBMPCollectionViewDelegate
- (void)didSelectedDetailModel:(STBMPModel *)model
{
    if (model.m_index == 0) {
        _bmpStrenghView.hidden = YES;
    }else{
        _bmpStrenghView.hidden = NO;
    }
    
    STWeakSelf
    [self.senseBeautifyManager handleBMPChanged:model sliderValueBlock:^(float value) {
        [weakSelf.bmpStrenghView updateSliderValue:value];
    }];
}
- (void)backToMainView
{
    self.bmpStrenghView.hidden = YES;
}

#pragma STBmpStrengthViewDelegate
- (void)sliderValueDidChange:(float)value
{
    [_bmpStrenghView updateSliderValue:value];
    [self.senseBeautifyManager bmpSliderValueChanged:value];
}

#pragma mark -- private
- (NSUInteger)getBabyPinkFilterIndex {
    
    __block NSUInteger index = 0;
    
    [_filterView.filterCollectionView.arrPortraitFilterModels enumerateObjectsUsingBlock:^(STCollectionViewDisplayModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.strName isEqualToString:@"babypink"]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)refreshFilterCategoryState:(STEffectsType)type {
    
    for (int i = 0; i < self.arrFilterCategoryViews.count; ++i) {
        
        if (self.arrFilterCategoryViews[i].highlighted) {
            self.arrFilterCategoryViews[i].highlighted = NO;
        }
    }
    
    switch (type) {
        case STEffectsTypeFilterPortrait:
            
            self.arrFilterCategoryViews[0].highlighted = YES;
            
            break;
            
        case STEffectsTypeFilterScenery:
            
            self.arrFilterCategoryViews[1].highlighted = YES;
            
            break;
            
        case STEffectsTypeFilterStillLife:
            
            self.arrFilterCategoryViews[2].highlighted = YES;
            
            break;
            
        case STEffectsTypeFilterDeliciousFood:
            
            self.arrFilterCategoryViews[3].highlighted = YES;
            
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    
    _senseBeautifyManager = nil;
    
    for (STViewButton *stViewButton in _arrFilterCategoryViews) {
        NSArray *targets = [stViewButton gestureRecognizers];
        for (UIGestureRecognizer *recognizer in targets) {
            [stViewButton removeGestureRecognizer: recognizer];
        }
    }
    [_arrFilterCategoryViews removeAllObjects];
}

@end
