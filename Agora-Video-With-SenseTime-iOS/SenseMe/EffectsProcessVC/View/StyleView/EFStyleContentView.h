//
//  EFStyleContentView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFStyleViewLayout.h"

NS_ASSUME_NONNULL_BEGIN
@protocol EFStyleContentViewDelegate <NSObject>

- (void)selectedCell:(EFDataSourceModel *)dataModel;

@end


@interface EFStyleContentView : UIView

@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) EFStyleViewLayout *collectionLayout;

@property (nonatomic, weak)   id<EFStyleContentViewDelegate> delegate;

@property (nonatomic, assign) int selectIndex;

@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataSource;

- (void)autoSelectedModelAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
