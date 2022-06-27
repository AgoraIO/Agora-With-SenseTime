//
//  EFTryOnTitleView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnTitleView.h"
#import "EFTitleCell.h"
#import "TryOnDataElementInterface.h"

@interface EFTryOnTitleView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *titleCollectionView;
@property (nonatomic, strong) NSArray<id<TryOnDataElementInterface>> *dataSource;

@end

@implementation EFTryOnTitleView
{
    NSUInteger _current;
}

-(instancetype)initWithDatasource:(NSArray<id<TryOnDataElementInterface>> *)dataSource {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _dataSource = dataSource;
        [self customSubViews];
    }
    return self;
}

-(void)customSubViews {
    [self addSubview:self.titleCollectionView];
    
    [self.titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - collectionView delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFTitleCell" forIndexPath:indexPath];
    EFDataSourceModel *model = [[EFDataSourceModel alloc] init];
    id<TryOnDataElementInterface> dataElement = self.dataSource[indexPath.item];
    model.efAlias = dataElement.name;
    [cell configStyle:model select:_current == indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_current == indexPath.row) return;
    _current = indexPath.row;
    [collectionView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnTitleView:titleChanged:withModel:)]) {
        [self.delegate tryOnTitleView:self titleChanged:indexPath withModel:self.dataSource[indexPath.row]];
    }
}

#pragma mark - properties
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

@end
