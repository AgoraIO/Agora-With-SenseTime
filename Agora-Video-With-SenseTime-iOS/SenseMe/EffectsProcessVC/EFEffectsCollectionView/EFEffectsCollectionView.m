//
//  EFEffectsCollectionView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFEffectsCollectionView.h"
#import "EFTitleCell.h"
#import "EFEffectsContentView.h"
#import "EFStripImagePickerView.h"

@interface EFEffectsCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EFStripImagePickerViewDelegate>

@property (nonatomic, strong) UICollectionView *titleCollectionView;

@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIView *parentView;

@property (nonatomic, strong) EFStatusManager *statusManager;

@property (nonatomic, strong) EFEffectsContentView *contentView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIView *contentBackView;

@property (nonatomic, assign) int index;

@property (nonatomic, assign) EFStatusManagerSingletonMode model;

@property (nonatomic, strong) EFStripImagePickerView *stripImagePickerView;

@end

@implementation EFEffectsCollectionView


- (instancetype)initWithFrame:(CGRect)frame model:(EFStatusManagerSingletonMode)model{
    self = [super initWithFrame: frame];
    self.statusManager = [EFStatusManager sharedInstanceWith:model];
    self.model = model;
    return self;
}

- (void)setUI {
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(272);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    //titleCollectionView superView
    [self.bottomView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(42);
        make.left.right.top.equalTo(self.bottomView);
    }];
    
    //contentCollectionView superView
    [self.bottomView addSubview:self.contentBackView];
    [self.contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.bottomView);
    }];
    
    
    [self.titleView addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView);
        make.left.equalTo(self.titleView.mas_left).offset(22);
    }];
    
    
    [self.titleView addSubview:self.titleCollectionView];
    [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.titleView);
        make.left.equalTo(self.clearButton.mas_right).offset(20);
    }];
    
    
    [self.contentBackView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentBackView);
    }];
}


- (void)setDataSource:(NSMutableArray<EFDataSourceModel *> *)dataSource {
    NSMutableArray<EFDataSourceModel *> *dataArray = [[NSMutableArray alloc]init];
    BOOL hasAvatar = NO;
    for (EFDataSourceModel *model in dataSource) {
        
        if (![model.efAlias isEqualToString:@"Avatar"]) {
            [dataArray addObject:model];
        }
        
        if ([model.efAlias isEqualToString:@"Avatar"] && !hasAvatar) {
            hasAvatar = YES;
            [dataArray addObject:model];
        }
    }
    _dataSource = dataArray;
    [self.titleCollectionView reloadData];
    
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
    self.index = (int)indexPath.row;
    [self.statusManager efModelSelected:self.dataSource[indexPath.row]];
    [self.titleCollectionView reloadData];
    
    EFDataSourceModel * selectedModel = self.dataSource[indexPath.row];    
    self.contentView.efIsMulti = [selectedModel.efName isEqualToString:@"叠加"];
    self.contentView.dataSource = [selectedModel.efSubDataSources mutableCopy];
    
    [self.titleCollectionView layoutIfNeeded];
    [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    if (self.contentView.dataSource.count) {
        [self.contentView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

#pragma mark - func

- (void)show:(UIView *)parentView select:(int)index {
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
    
    if (self.subviews.count == 0) {
        [self setUI];
    }
    
    if (self.dataSource.count > 0) {
        [self collectionView:self.titleCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    
    [self.contentView.collectionView reloadData];
}

- (void)dismiss:(UIView *)parentView {
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(parentView);
        make.height.mas_equalTo(SCREEN_H);
        make.top.mas_equalTo(parentView.mas_bottom);
    }];
}

#pragma mark - set
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
        _titleView.backgroundColor = RGBA(16, 16, 16, 0.8);
    }
    return _titleView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor clearColor];
        _backView.tag = 1000;
    }
    return _backView;
}

- (UIView *)contentBackView {
    if (!_contentBackView) {
        _contentBackView = [[UIView alloc]init];
        _contentBackView.backgroundColor = RGBA(42, 42, 42, 0.8);
    }
    return _contentBackView;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]init];
        [_clearButton setImage:[UIImage imageNamed:@"clear_texiao"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearSticker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (EFEffectsContentView *)contentView {
    if (!_contentView) {
        _contentView = [[EFEffectsContentView alloc] initWithFrame:CGRectZero model:self.model];
    }
    return _contentView;
}

- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(50, 42);
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

#pragma mark - EFStripImagePickerView & EFStripImagePickerViewDelegate
-(void)setShowPhotoStripView:(BOOL)showPhotoStripView {
    _showPhotoStripView = showPhotoStripView;
    if (showPhotoStripView && !_stripImagePickerView) {
        [self addSubview:self.stripImagePickerView];
        [self.stripImagePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottomView.mas_top).inset(10);
            make.leading.trailing.equalTo(self).inset(10);
            make.height.equalTo(@60);
        }];
    }
    self.stripImagePickerView.hidden = !showPhotoStripView;
    if (!showPhotoStripView) {
        [self.stripImagePickerView resetImageSelectedStatus];
        [self.stripImagePickerView removeFromSuperview];
        _stripImagePickerView = nil;
    }
}

-(EFStripImagePickerView *)stripImagePickerView {
    if (!_stripImagePickerView) {
        _stripImagePickerView = [[EFStripImagePickerView alloc] initWithFrame:CGRectZero];
        _stripImagePickerView.delegate = self;
        _stripImagePickerView.hidden = YES;
    }
    return _stripImagePickerView;
}

-(void)stripImagePickerView:(EFStripImagePickerView *)stripImagePickerView selectedImage:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(effectsCollectionView:selectedImage:)]) {
        [self.delegate effectsCollectionView:self selectedImage:image];
    }
}

#pragma mark - UI Action
- (void)clearSticker{
    if (self.dataSource && self.dataSource.count > 0) {
        if (self.dataSource[0].efSubDataSources && self.dataSource[0].efSubDataSources.count > 0) {
            [self.statusManager efClear:self.dataSource[0].efSubDataSources[0]];
            self.contentView.dataSource = [self.dataSource[self.index].efSubDataSources mutableCopy];
        }
    }
}
@end
