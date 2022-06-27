//
//  EFStyleContentView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStyleContentView.h"
#import "EFStyleContentCell.h"

@interface EFStyleContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) EFStatusManager *statusManager;

@end


@implementation EFStyleContentView

- (instancetype)initWithFrame:(CGRect)frame model:(EFStatusManagerSingletonMode)model{
    if (self = [super initWithFrame:frame]) {
        self.statusManager = [EFStatusManager sharedInstanceWith:model];
        [self setUI];
    }
    return self;
}


- (void)setUI {
    
    [self addSubview:self.contentCollectionView];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentCollectionView reloadData];
}

- (void)setDataSource:(NSMutableArray<EFDataSourceModel *> *)dataSource {
    _dataSource = dataSource;
    [self.contentCollectionView reloadData];
}


- (UICollectionView *)contentCollectionView {
    
    if (!_contentCollectionView) {
         _collectionLayout = [[EFStyleViewLayout alloc]init];
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_collectionLayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.pagingEnabled = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        [_contentCollectionView registerClass:[EFStyleContentCell class] forCellWithReuseIdentifier:@"EFStyleContentCell"];
        
    }
    return _contentCollectionView;
}


- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(64, self.contentCollectionView.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    NSInteger itemCount = [self collectionView:collectionView numberOfItemsInSection:section];

    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - 1 inSection:section];
    CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
    
    return UIEdgeInsetsMake(0, (collectionView.bounds.size.width - firstSize.width) / 2,
                            0, (collectionView.bounds.size.width - lastSize.width) / 2);
    
    
}

- (void)autoSelectedModelAtIndex:(int)index{
    [self.contentCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    self.selectIndex = index;
}


#pragma mark - collection Delegate DataDource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFStyleContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFStyleContentCell" forIndexPath:indexPath];
    
    BOOL select = [self.statusManager efModelHasSelected:self.dataSource[indexPath.row]];
    EFMaterialDownloadStatus status = [self.statusManager efDownloadStatus:self.dataSource[indexPath.item]];
    [cell config:self.dataSource[indexPath.item] status:status select:select];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.collectionLayout.needScale = YES;
    self.selectIndex = (int)indexPath.row;
    
    [self.statusManager efModelSelected:self.dataSource[indexPath.item] onProgress:^(id<EFDataSourcing> material, float fProgress, int64_t iSize) {
    } onSuccess:^(id<EFDataSourcing> material) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentCollectionView reloadData];
            if (self.delegate && material) {
                [self.delegate selectedCell:self.dataSource[indexPath.row]];
            }
        });
    } onFailure:nil];    
    
    [self.contentCollectionView reloadData];

    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }else{
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint pview = [self convertPoint:self.contentCollectionView.center
                                toView:self.contentCollectionView];
    NSIndexPath *indexPath = [self.contentCollectionView indexPathForItemAtPoint:pview];
    [self collectionView:self.contentCollectionView didSelectItemAtIndexPath:indexPath];
}

@end
