//
//  EFEffectsCollectionView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class EFEffectsCollectionView;

@protocol EFEffectsCollectionViewDelegate <NSObject>

-(void)effectsCollectionView:(EFEffectsCollectionView *)effectsCollectionView selectedImage:(UIImage *)image;

@end

@interface EFEffectsCollectionView : UIView

@property (nonatomic, weak) id<EFEffectsCollectionViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataSource;

@property (nonatomic, assign) BOOL showPhotoStripView;

- (void)show:(UIView *)parentView select:(int)index;

- (void)dismiss:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
