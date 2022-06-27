//
//  EFStyleView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol EFStyleViewDelegate <NSObject>

- (void)efStyleViewAction:(UIView *)sender;

@end

@interface EFStyleView : UIView

@property (nonatomic, weak)  id<EFStyleViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataSource;

@property (nonatomic, assign) int selectIndex;

- (void)show:(UIView *)parentView;

- (void)dismiss:(UIView *)parentView;

@end

NS_ASSUME_NONNULL_END
