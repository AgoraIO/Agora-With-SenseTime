//
//  STCustomCollectionView.m
//  SenseArDemo
//
//  Created by sluin on 2017/8/31.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCustomCollectionView.h"

@interface STCustomCollectionView () <UICollectionViewDelegate , UICollectionViewDataSource>
@end

@implementation STCustomCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

#pragma - mark -
#pragma - mark UICollectionViewDelegate , UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.numberOfSectionsInView) {
        
        __weak typeof(self) weakSelf = self;

        return weakSelf.numberOfSectionsInView(weakSelf);
    }else{
        
        return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.numberOfItemsInSection) {
        
        __weak typeof(self) weakSelf = self;
        
        return weakSelf.numberOfItemsInSection(weakSelf , section);
    }else{
        
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForItemAtIndexPath) {
        
        __weak typeof(self) weakSelf = self;
        
        return weakSelf.cellForItemAtIndexPath(weakSelf , indexPath);
    }else{
        
        return [[UICollectionViewCell alloc] init];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectItematIndexPath) {
        
        __weak typeof(self) weakSelf = self;
        
        return weakSelf.didSelectItematIndexPath(weakSelf , indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didDeselectItematIndexPath) {
        
        __weak typeof(self) weakSelf = self;
        
        return weakSelf.didDeselectItematIndexPath(weakSelf , indexPath);
    }
}


@end
