//
//  EFEffectsContentView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFEffectsContentView : UIView

@property (nonatomic, readwrite, assign) BOOL efIsMulti;

@property (nonatomic, strong) NSMutableArray <EFDataSourceMaterialModel *> *dataSource;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END
