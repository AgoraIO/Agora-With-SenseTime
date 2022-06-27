//
//  EFEffectsContentView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFEffectsContentView.h"
#import "EFContentCell.h"

@interface EFEffectsContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) EFStatusManager *statusManager;

@end

@implementation EFEffectsContentView

- (instancetype)initWithFrame:(CGRect)frame model:(EFStatusManagerSingletonMode)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.statusManager = [EFStatusManager sharedInstanceWith:model];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setDataSource:(NSMutableArray<EFDataSourceMaterialModel *> *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFContentCell" forIndexPath:indexPath];
    BOOL select = [self.statusManager efModelHasSelected:self.dataSource[indexPath.row]];
    EFMaterialDownloadStatus status = [self.statusManager efDownloadStatus:self.dataSource[indexPath.item]];
    [cell config:self.dataSource[indexPath.item] status:status select:select];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EFDataSourceModel * selectedModel = self.dataSource[indexPath.item];
    if (self.efIsMulti) {
        selectedModel = [selectedModel copy];
        selectedModel.efIsMulti = YES;
    }
    [self.statusManager efModelSelected:selectedModel onProgress:^(id<EFDataSourcing> material, float fProgress, int64_t iSize) {
    } onSuccess:^(id<EFDataSourcing> material) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } onFailure:nil];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(65, 70);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(22, 22, 10, 22);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[EFContentCell class] forCellWithReuseIdentifier:@"EFContentCell"];
    }
    return _collectionView;
}

@end
