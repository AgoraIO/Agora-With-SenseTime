//
//  EFTryOnBeautyView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnBeautyView.h"
#import "EFTryOnBeautyCollectionViewCell.h"

@interface EFTryOnBeautyView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) id<TryOnDataElementInterface> dataSource;
@property (nonatomic, strong) id<TryOnBeautyItemInterface> currentModel;

@end

static NSString *const EFTryOnBeautyCollectionViewCellKey = @"EFTryOnBeautyCollectionViewCell";

@implementation EFTryOnBeautyView

-(instancetype)initWithDatasource:(id<TryOnDataElementInterface>)dataSource {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        _dataSource = dataSource;
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    [self addSubview:self.contentCollectionView];
    self.contentCollectionView.backgroundColor = UIColor.whiteColor;
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)setDefaultBeauty {
    
}

- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.pagingEnabled = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        [_contentCollectionView registerClass:[EFTryOnBeautyCollectionViewCell class] forCellWithReuseIdentifier:EFTryOnBeautyCollectionViewCellKey];
        
    }
    return _contentCollectionView;
}


- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(64, self.contentCollectionView.bounds.size.height);
}

#pragma mark - properties
-(void)setCurrentTryonBeauty:(NSInteger)currentTryonBeauty {
    _currentTryonBeauty = currentTryonBeauty;
    id<TryOnBeautyItemInterface> model = self.dataSource.items[currentTryonBeauty];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnBeautyView:selectModel:withIndex:)]) {
        [self.delegate tryOnBeautyView:self selectModel:model withIndex:currentTryonBeauty];
    }
    self.currentModel = model;
    [self.contentCollectionView reloadData];
}

#pragma mark - collection Delegate DataDource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFTryOnBeautyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EFTryOnBeautyCollectionViewCellKey forIndexPath:indexPath];
    id<TryOnBeautyItemInterface> model = self.dataSource.items[indexPath.row];
    [cell config:model status:EFMaterialDownloadStatusDownloaded select:model == self.currentModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<TryOnBeautyItemInterface> model = self.dataSource.items[indexPath.row];
    if (self.currentModel && self.currentModel == model) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnBeautyView:deselectModel:withIndex:)]) {
            [self.delegate tryOnBeautyView:self deselectModel:model withIndex:indexPath.row];
        }
        self.currentModel = nil;
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnBeautyView:deselectModel:withIndex:)]) {
            [self.delegate tryOnBeautyView:self deselectModel:self.currentModel withIndex:indexPath.row];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnBeautyView:selectModel:withIndex:)]) {
            [self.delegate tryOnBeautyView:self selectModel:model withIndex:indexPath.row];
        }
        self.currentModel = model;
    }
    
    [collectionView reloadData];
}

@end
