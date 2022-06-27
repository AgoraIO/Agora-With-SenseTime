//
//  EFMakeupFilterBeautyView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMakeupFilterBeautyView.h"
#import "EFMakeupFilterBeautyContentView.h"
#import "EFTitleCell.h"
#import "EFBeautySlider.h"


@interface EFMakeupFilterBeautyView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EFMakeupFilterBeautyContentViewDelegate>


@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) EFMakeupFilterBeautyContentView *contentView;
@property (nonatomic, assign) int contentViewIndex;

@property (nonatomic, strong) EFStatusManager *statusManager;

@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, readwrite, assign) BOOL showed;

@property (nonatomic, strong) EFBeautySlider *efMakeupFilterBeautySlider;

@property (nonatomic, assign) int index;

@property (nonatomic, strong) UIButton *compareButton;

@property (nonatomic, assign) EFStatusManagerSingletonMode model;

@end

@implementation EFMakeupFilterBeautyView

- (instancetype)initWithFrame:(CGRect)frame model:(EFStatusManagerSingletonMode)model{
    self = [super initWithFrame:frame];
    self.statusManager = [EFStatusManager sharedInstanceWith:model];
    self.model = model;
    return self;
}

- (void)setUI {
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(228);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //add slider
    [self addSubview:self.efMakeupFilterBeautySlider];
    [self.efMakeupFilterBeautySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_W - 140);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-15);
    }];
    
    
    [self addSubview:self.compareButton];
    [self.compareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.efMakeupFilterBeautySlider).offset(5);
    }];
    
    
    //titleCollectionView superView
    [self.bottomView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(42);
        make.left.right.top.equalTo(self.bottomView);
    }];
    
    [self.titleView addSubview:self.titleCollectionView];
    [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleView);
    }];
    
    [self.bottomView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.bottomView);
    }];
    
}

- (void)show:(UIView *)parentView select:(int)index{
    
    _showed = YES;
    
    self.parentView = parentView;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.height.mas_equalTo(SCREEN_H);
        make.top.mas_equalTo(parentView.mas_bottom);
    }];
    
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(parentView);
            make.height.mas_equalTo(SCREEN_H);
            make.top.equalTo(parentView);
        }];
        [self.superview layoutIfNeeded];
    }];
    
    [self setUI];
    
    if (self.dataSource.count > 0) {
        [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
}

- (void)dismiss:(UIView *)parentView {
    
    _showed = NO;
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.height.mas_equalTo(SCREEN_H);
        make.top.mas_equalTo(parentView.mas_bottom);
    }];
    
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    
    [self.titleCollectionView removeFromSuperview];
    self.titleCollectionView = nil;
}


#pragma mark - collectionView delegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFTitleCell" forIndexPath:indexPath];
    BOOL select = [self.statusManager efModelHasSelected:self.dataSource[indexPath.row]];
    [cell config:self.dataSource[indexPath.row] select:select];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EFDataSourceModel *currentModel = self.dataSource[indexPath.row];
    self.index = (int)indexPath.row;
    [self.statusManager efModelSelected:currentModel];
    [self.titleCollectionView reloadData];
    
    if ([currentModel.efName isEqualToString:@"3D微整形"]) {
        [self.contentView setUI:self.itemType with3D:YES];
    } else {
        [self.contentView setUI:self.itemType];
    }
    self.contentView.dataSource = [self.dataSource[indexPath.row].efSubDataSources mutableCopy];
    if (self.contentView.dataSource.count) {
        [self.contentView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
    if (!self.contentView.dataSource.count)
        [EFToast showError:self
               description:NSLocalizedString(@"列表正在拉取或拉取出错", nil)];
    self.efMakeupFilterBeautySlider.hidden = YES;
}

#pragma mark - set
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.tag = 1001;
    }
    return _backView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        [_bottomView setBackgroundColor:[UIColor clearColor]];
    }
    return _bottomView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]init];
        _titleView.backgroundColor = RGBA(42, 42, 42, 0.9);
    }
    return _titleView;
}

- (EFMakeupFilterBeautyContentView *)contentView {
    if (!_contentView) {
        _contentView = [[EFMakeupFilterBeautyContentView alloc]initWithFrame:CGRectZero withType:self.itemType model:self.model];
        _contentView.backgroundColor = RGBA(42, 42, 42, 0.85);
        _contentView.delegate = self;
    }
    return _contentView;
}

- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.itemType == effectsItemBeauty ? 70 : 60, 42);
        layout.sectionInset = UIEdgeInsetsMake(0, self.itemType == effectsItemBeauty ? 20 : 10, 0, 10);
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

- (EFBeautySlider *)efMakeupFilterBeautySlider {
    if (!_efMakeupFilterBeautySlider) {
        _efMakeupFilterBeautySlider = [[EFBeautySlider alloc] initWithFrame:CGRectZero];
        _efMakeupFilterBeautySlider.minimumTrackTintColor = [UIColor grayColor];
        [_efMakeupFilterBeautySlider setThumbImage:[UIImage imageNamed:@"strength_point"] forState:UIControlStateNormal];
        _efMakeupFilterBeautySlider.minimumValue = 0;
        _efMakeupFilterBeautySlider.maximumValue = 1;
        _efMakeupFilterBeautySlider.value = 0.0;
        [_efMakeupFilterBeautySlider addTarget:self action:@selector(currentSliderValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _efMakeupFilterBeautySlider;
}


- (UIButton *)compareButton{
    if (!_compareButton) {
        _compareButton = [[UIButton alloc] init];
        [_compareButton setImage:[UIImage imageNamed:@"comparison_icon"] forState:UIControlStateNormal];
        [_compareButton addTarget:self action:@selector(onBtnCompareTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_compareButton addTarget:self action:@selector(onBtnCompareTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _compareButton;
}

#pragma mark - EFMakeupFilterBeautyContentViewDelegate
- (void)selectedCell:(EFDataSourceModel *)dataModel index:(int)index{
    self.contentViewIndex = index;
    self.efMakeupFilterBeautySlider.hidden = ![self.statusManager efModelHasSelected:dataModel];
    float curValue = [self.statusManager efStrengthOfModel:dataModel]/100.0;
    self.efMakeupFilterBeautySlider.value = curValue;
    curValue = [EFMakeupFilterBeautyContentView updateCurrentBeautyValueWithModel:dataModel value:curValue];
    self.efMakeupFilterBeautySlider.valueLabel.text = [NSString stringWithFormat:@"%d", [self floatToInt:curValue]];
}

- (int)floatToInt:(float)f{
    int i = 0;
    if(f>0) //正数
      i = (f*10 + 5)/10;
    else if(f<0) //负数
      i = (f*10 - 5)/10;
    else i = 0;
 
    return i;
 
}

- (void)contentViewEvent:(EFContentViewEvent)event{
    switch (event) {
        case EFContentViewEventClear:
        case EFContentViewEventReset:
            self.efMakeupFilterBeautySlider.hidden = YES;
            break;
        default:
            break;
    }
}


- (void)backButtonAction:(UIButton *)button {
    
    [self.contentView setUI:self.itemType];
    [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]];
    
}

- (void)currentSliderValue:(UISlider *)slider{
    float value = slider.value;
    
    if (self.contentView.dataSource.count > self.contentViewIndex) {
        [self.statusManager efModel:self.contentView.dataSource[self.contentViewIndex] strengthChanged:value];
        self.contentView.dataSource = self.contentView.dataSource;//[self.dataSource[self.index].efSubDataSources mutableCopy];
        EFDataSourceModel *model = self.contentView.dataSource[self.contentViewIndex];
        float curValue = [self.statusManager efStrengthOfModel:model]/100.0;
        float trueValue = [EFMakeupFilterBeautyContentView updateCurrentBeautyValueWithModel:model value:curValue];
        self.efMakeupFilterBeautySlider.valueLabel.text = [NSString stringWithFormat:@"%d",  [self floatToInt:trueValue]];
    }
}


- (void)onBtnCompareTouchDown:(UIButton *)btn{
    btn.selected = YES;
    if (self.delegate) {
        [self.delegate compareClick:btn];
    }
}
- (void)onBtnCompareTouchUpInside:(UIButton *)btn{
    btn.selected = NO;
    if (self.delegate) {
        [self.delegate compareClick:btn];
    }
}

@end
