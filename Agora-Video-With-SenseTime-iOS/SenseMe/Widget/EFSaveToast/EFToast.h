//
//  EFToast.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/29.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFToast : UIView

+ (void)show:(UIView *)view description:(NSString *)description;


+ (void)showError:(UIView *)view
      description:(NSString *)description;

+ (void)showFail:(UIView *)view
      description:(NSString *)description;

@end

NS_ASSUME_NONNULL_END
