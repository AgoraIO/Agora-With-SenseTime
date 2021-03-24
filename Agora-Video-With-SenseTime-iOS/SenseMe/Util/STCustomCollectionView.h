//
//  STCustomCollectionView.h
//  SenseArDemo
//
//  Created by sluin on 2017/8/31.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STCustomCollectionView : UICollectionView

@property (nonatomic , copy) NSInteger(^numberOfSectionsInView)(STCustomCollectionView *collectionView);

@property (nonatomic , copy) NSInteger(^numberOfItemsInSection)(STCustomCollectionView *collectionView , NSInteger section);

@property (nonatomic , copy) UICollectionViewCell *(^cellForItemAtIndexPath)(STCustomCollectionView *collectionView , NSIndexPath *indexPath);

@property (nonatomic , copy) void(^didSelectItematIndexPath)(STCustomCollectionView *collectionView , NSIndexPath *indexPath);

@property (nonatomic , copy) void(^didDeselectItematIndexPath)(STCustomCollectionView *collectionView , NSIndexPath *indexPath);

@end
