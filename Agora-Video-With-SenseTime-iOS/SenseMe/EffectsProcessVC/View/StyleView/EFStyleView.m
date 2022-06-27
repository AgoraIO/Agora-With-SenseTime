//
//  EFStyleView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStyleView.h"
#import "EFTitleCell.h"
#import "EFStyleContentView.h"
#import "EFBeautySlider.h"

typedef NS_ENUM(NSUInteger, EFStyleType){
    EFStyleTypeMakeup,
    EFStyleTypeFilter,
};

@interface EFStyleView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EFStyleContentViewDelegate>
{
    int _filterValue;
    int _makeupValue;
}

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIButton *enlargedButton;

@property (nonatomic, strong) UIButton *makeupButton;

@property (nonatomic, strong) UIButton *filterButton;

@property (nonatomic, strong) EFBeautySlider *efMakeupSlider;

@property (nonatomic, strong) EFBeautySlider *efFilterSlider;

@property (nonatomic, strong) UIView *styleBackgroundView;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) EFStatusManager *statusManager;

@property (nonatomic, strong) EFStyleContentView *contentView;

@property (nonatomic, assign) int index;

@property (nonatomic, assign) EFStyleType curType;

@property (nonatomic, assign) EFStatusManagerSingletonMode model;
@end


@implementation EFStyleView

- (instancetype)initWithFrame:(CGRect)frame
                        model:(EFStatusManagerSingletonMode)model{
    
    self = [super initWithFrame:frame];
    self.statusManager = [EFStatusManager sharedInstanceWith:model];
    self.model = model;
    _curType = EFStyleTypeMakeup;
    return self;
}


- (void)setUI {
    
    [self addSubview:self.backgroundView];
    if (EFStatusManagerSingletonMode1 == self.model) {
        [self.backgroundView addSubview:self.enlargedButton];
    }
    [self.backgroundView addSubview:self.filterButton];
    [self.backgroundView addSubview:self.makeupButton];
    [self.backgroundView addSubview:self.efFilterSlider];
    [self.backgroundView addSubview:self.efMakeupSlider];
    
    [self addSubview:self.styleBackgroundView];
    [self.styleBackgroundView addSubview:self.clearButton];
    [self.styleBackgroundView addSubview:self.titleCollectionView];
    [self.styleBackgroundView addSubview:self.contentView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_offset(50);
    }];
    
    if (EFStatusManagerSingletonMode1 == self.model) {
        [self.enlargedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(25);
            make.left.equalTo(self.backgroundView).offset(20);
            make.centerY.equalTo(self.backgroundView);
        }];
    }
    
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        id view = (EFStatusManagerSingletonMode1 ==self.model)?self.enlargedButton:self.backgroundView;
        if(EFStatusManagerSingletonMode1 == self.model){
            make.left.equalTo(self.enlargedButton.mas_right).offset(10);
        }else{
            make.left.equalTo(self.backgroundView).offset(20);
        }
        make.centerY.equalTo(view);
    }];
    
    [self.makeupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterButton.mas_right).offset(10);
        make.centerY.equalTo(self.filterButton);
    }];
    
    [self.efFilterSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.equalTo(self.makeupButton.mas_right).offset(10);
        make.centerY.equalTo(self.makeupButton);
        make.right.equalTo(self.backgroundView).offset(-10);
    }];
    
    [self.efMakeupSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.equalTo(self.makeupButton.mas_right).offset(10);
        make.centerY.equalTo(self.makeupButton);
        make.right.equalTo(self.backgroundView).offset(-10);
    }];
    
    [self.styleBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backgroundView);
        make.top.equalTo(self.backgroundView.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.equalTo(self.styleBackgroundView).offset(20);
        make.top.equalTo(self.styleBackgroundView).offset(13);
    }];
    
    [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46);
        make.top.right.equalTo(self.styleBackgroundView);
        make.left.equalTo(self.clearButton.mas_right).offset(10);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(90);
        make.left.right.equalTo(self.styleBackgroundView);
        make.top.equalTo(self.titleCollectionView.mas_bottom).offset(0);
    }];
    
    NSMutableArray <EFDataSourceModel *> *buttonArray = [[NSMutableArray alloc]init];
    EFDataSourceModel *model = [EFDataSourceGenerator sharedInstance].efDataSourceModel;
    for (int i = 0; i < model.efSubDataSources.count; i++) {
        EFDataSourceModel *dataModel = model.efSubDataSources[i];
        if ([dataModel.efName isEqualToString:@"风格"]) {
            for (EFDataSourceModel *model in dataModel.efSubDataSources) {
                [buttonArray addObject:model];
            }
        }
    }
    self.dataSource = buttonArray;
    [self.titleCollectionView reloadData];
    
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFTitleCell" forIndexPath:indexPath];
    BOOL select = [self.statusManager efModelHasSelected:self.dataSource[indexPath.item]];
    [cell configStyle:self.dataSource[indexPath.item] select:select];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.index = (int)indexPath.row;
    [self.statusManager efModelSelected:self.dataSource[indexPath.item]];
    [self.titleCollectionView reloadData];
    self.contentView.dataSource = [self.dataSource[indexPath.item].efSubDataSources mutableCopy];
}


#pragma mark - func

- (void)show:(UIView *)parentView {
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.height.mas_equalTo(210);
        make.top.mas_equalTo(parentView.mas_bottom);
    }];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(parentView);
            make.height.mas_equalTo(210);
            make.top.equalTo(parentView.mas_top).offset(SCREEN_H - 255);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    [self setUI];
    
    if (self.dataSource.count > 0) {
        int titleIndex = 0;
        int styleIndex = 0;
        BOOL Break = NO;
        for(EFDataSourceModel * titleModel in self.dataSource){
            for(EFDataSourceModel * styleModel in titleModel.efSubDataSources){
                if([self.statusManager efModelHasSelected:styleModel]){
                    titleIndex = (int)[self.dataSource indexOfObject:titleModel];
                    styleIndex = (int)[titleModel.efSubDataSources indexOfObject:styleModel];
                    Break = YES;
                    [self selectedCell:styleModel];
                    break;
                }
                [self hideSlide:!Break];
            }
            if (Break) break;
        }
        [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:Break ? titleIndex : self.selectIndex inSection:0]];
        [self.contentView.contentCollectionView reloadData];
        [self.contentView.contentCollectionView layoutIfNeeded];
        [self.contentView autoSelectedModelAtIndex:styleIndex];
    }
}

- (void)dismiss:(UIView *)parentView {
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.height.mas_equalTo(210);
        make.top.mas_equalTo(parentView.mas_bottom);
    }];
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (UIButton *)enlargedButton{
    if (!_enlargedButton) {
        _enlargedButton = [[UIButton alloc] init];
        [_enlargedButton setImage:[UIImage imageNamed:@"enlarged_icon"] forState:UIControlStateNormal];
        [_enlargedButton addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enlargedButton;
}

- (UIButton *)filterButton{
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_filterButton setImage:[UIImage imageNamed:@"filter_adjusting"] forState:UIControlStateNormal];
        [_filterButton setImage:[UIImage imageNamed:@"filter_adjusting_light"] forState:UIControlStateSelected];
        [_filterButton addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (UIButton *)makeupButton{
    if (!_makeupButton) {
        _makeupButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_makeupButton setImage:[UIImage imageNamed:@"makeup_adjusting"] forState:UIControlStateNormal];
        [_makeupButton setImage:[UIImage imageNamed:@"lipstick"] forState:UIControlStateSelected];
        [_makeupButton addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventTouchUpInside];
        _makeupButton.selected = YES;
    }
    return _makeupButton;
}

- (EFBeautySlider *)efFilterSlider {
    if (!_efFilterSlider) {
        _efFilterSlider = [[EFBeautySlider alloc] initWithFrame:CGRectZero];
        _efFilterSlider.minimumTrackTintColor = [UIColor whiteColor];
        [_efFilterSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        _efFilterSlider.minimumValue = 0;
        _efFilterSlider.maximumValue = 100;
        _efFilterSlider.value = 85;
        _efFilterSlider.hidden = YES;
        [_efFilterSlider addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _efFilterSlider;
}

- (EFBeautySlider *)efMakeupSlider{
    if (!_efMakeupSlider) {
        _efMakeupSlider = [[EFBeautySlider alloc] initWithFrame:CGRectZero];
        _efMakeupSlider.minimumTrackTintColor = [UIColor whiteColor];
        [_efMakeupSlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        _efMakeupSlider.minimumValue = 0;
        _efMakeupSlider.maximumValue = 100;
        _efMakeupSlider.value = 85;
        [_efMakeupSlider addTarget:self action:@selector(styleAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _efMakeupSlider;
}

- (UIView *)styleBackgroundView{
    if (!_styleBackgroundView) {
        _styleBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _styleBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _styleBackgroundView;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]init];
        [_clearButton setImage:[UIImage imageNamed:@"cancel_style"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearSticker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(40, 32);
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
        _titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.bounces = NO;
        _titleCollectionView.pagingEnabled = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.backgroundColor = [UIColor clearColor];
        [_titleCollectionView registerClass:[EFTitleCell class] forCellWithReuseIdentifier:@"EFTitleCell"];
    }
    return _titleCollectionView;
}

- (EFStyleContentView *)contentView {
    
    if (!_contentView) {
        _contentView = [[EFStyleContentView alloc]initWithFrame:CGRectZero model:self.model];
        _contentView.delegate = self;
    }
    return _contentView;
}

#pragma mark - UI Action
- (void)clearSticker{
    self.contentView.collectionLayout.needScale = NO;
    
    if (self.dataSource.count > 0) {
        [self.statusManager efClear:self.dataSource[0].efSubDataSources[0]];
        self.contentView.dataSource = [self.dataSource[self.index].efSubDataSources mutableCopy];
    }
    [self hideSlide:YES];
}


- (void)hideSlide:(BOOL)hide {
    
    self.makeupButton.hidden = hide;
    self.filterButton.hidden = hide;
    self.efMakeupSlider.hidden = hide;
    self.efFilterSlider.hidden = hide;
}


- (void)styleAction:(UIView *)sender{
    if (sender == _enlargedButton) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(efStyleViewAction:)]) {
            [self.delegate efStyleViewAction:_enlargedButton];
        }
    }
    
    if (sender == _filterButton) {
        _filterButton.selected = YES;
        _makeupButton.selected = NO;
        _curType = EFStyleTypeFilter;
        _efFilterSlider.hidden = NO;
        _efMakeupSlider.hidden = YES;
    }
    
    if (sender == _makeupButton) {
        _filterButton.selected = NO;
        _makeupButton.selected = YES;
        _curType = EFStyleTypeMakeup;
        _efFilterSlider.hidden = YES;
        _efMakeupSlider.hidden = NO;
    }
    if (sender == _efFilterSlider || sender == _efMakeupSlider) {
        [self currentSliderValue:(_makeupButton.selected)?_efMakeupSlider:_efFilterSlider];
    }
}

- (void)currentSliderValue:(EFBeautySlider *)slider{
    int value = (int)slider.value;
    slider.valueLabel.text = [NSString stringWithFormat:@"%d", value];
    
    int fullValue = 0;
    
    if (_curType == EFStyleTypeFilter) {
        _filterValue = value;
    }
    if (_curType == EFStyleTypeMakeup) {
        _makeupValue = value;
    }
    
    fullValue = (_filterValue << 8 | _makeupValue);
    [self.statusManager efModel:self.contentView.dataSource[self.contentView.selectIndex] strengthChanged:
     fullValue];
}

#pragma mark - EFStyleContentViewDelegate
- (void)selectedCell:(EFDataSourceModel *)dataModel{
    int curValue = [self.statusManager efStrengthOfModel:dataModel];
    int makeupMask = 0b11111111;
    _filterValue = (curValue >> 8);
    _makeupValue = (curValue & makeupMask);
    int fullValue = 0;
    fullValue = (_filterValue << 8 | _makeupValue);
//    [self.statusManager efModel:self.contentView.dataSource[self.contentView.selectIndex]
//                strengthChanged:fullValue];
    self.efMakeupSlider.value = (int)_makeupValue;
    self.efMakeupSlider.valueLabel.text = [NSString stringWithFormat:@"%d", (int)_makeupValue];
    self.efFilterSlider.value = (int)_filterValue;
    self.efFilterSlider.valueLabel.text = [NSString stringWithFormat:@"%d", (int)_filterValue];
    [self styleAction:_makeupButton];
    self.efMakeupSlider.hidden = NO;
    self.makeupButton.hidden = NO;
    self.filterButton.hidden = NO;
    self.efFilterSlider.hidden = YES;
}

@end
