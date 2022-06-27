//
//  NSBundle+language.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/1/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const AppLanguage = @"appLanguage";

@interface NSBundle (language)

///获取当前语言
+ (NSString *)currentLanguage;

///设置语言
+ (void)setLanguage:(NSString *)language;

@end

NS_ASSUME_NONNULL_END
