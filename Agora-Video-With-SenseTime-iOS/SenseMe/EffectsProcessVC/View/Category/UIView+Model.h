//
//  UIView+Model.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/7/5.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Model)

- (instancetype)initWithFrame:(CGRect)frame model:(EFStatusManagerSingletonMode)model;

@end

NS_ASSUME_NONNULL_END
