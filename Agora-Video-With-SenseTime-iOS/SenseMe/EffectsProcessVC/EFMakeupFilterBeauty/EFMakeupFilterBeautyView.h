//
//  EFMakeupFilterBeautyView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EFMakeupFilterBeautyViewDelegate  <NSObject>

- (void)compareClick:(UIButton *)btn;

@end

@interface EFMakeupFilterBeautyView : UIView

@property (nonatomic, weak)  id<EFMakeupFilterBeautyViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataSource;

@property (nonatomic, readonly, assign) BOOL showed;

///区分item 类型
@property (nonatomic, assign) EffectsItemType itemType;

//index 默认选中
- (void)show:(UIView *)parentView select:(int)index;

- (void)dismiss:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
