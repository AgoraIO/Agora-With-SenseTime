//
//  EFSettingPopView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "XTPopViewBase.h"
@class  EFSettingPopView;

@protocol EFSettingPopViewDelegate <NSObject>

/// 0 性能展示  1语言切换  2YUV/RGB  3使用条款
- (void)EFSettingPopView:(EFSettingPopView *_Nullable)view didSelectIndex:(NSInteger)index select:(BOOL)select;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EFSettingPopView : XTPopViewBase

@property (nonatomic, weak) id <EFSettingPopViewDelegate> delegate;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
