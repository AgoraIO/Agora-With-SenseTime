//
//  EFMakeupFilterBeautyContentView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EFContentViewEvent) {
    EFContentViewEventClear,
    EFContentViewEventReset,
};

@protocol EFMakeupFilterBeautyContentViewDelegate <NSObject>

- (void)selectedCell:(EFDataSourceModel *)dataModel index:(int)index;

- (void)contentViewEvent:(EFContentViewEvent)event;

- (void)backButtonAction:(UIButton *)button;

@end

@interface EFMakeupFilterBeautyContentView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak)  id<EFMakeupFilterBeautyContentViewDelegate> delegate;

@property (nonatomic, assign) int selectIndex;

@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataSource;

@property (nonatomic, strong) UISegmentedControl *segment;

- (void)setUI:(EffectsItemType)itemType;

- (void)setUI:(EffectsItemType)itemType with3D:(BOOL)is3D;

- (instancetype)initWithFrame:(CGRect)frame withType:(EffectsItemType)itemType model:(EFStatusManagerSingletonMode)model;

+ (float)updateCurrentBeautyValueWithModel:(EFDataSourceModel *)model
                                     value:(float)value;

@end

NS_ASSUME_NONNULL_END
