//
//  NSBundle+language.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/1/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "NSBundle+language.h"
#import <objc/runtime.h>

@interface STBundle : NSBundle

@end

@implementation STBundle
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {

    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    //设置默认语言 (如果跟随系统语言可不设置)
    currentLanguage = currentLanguage ? currentLanguage : @"zh-Hans";
    NSBundle *currentLanguageBundle = currentLanguage ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]] : nil;
    return currentLanguageBundle ? [currentLanguageBundle localizedStringForKey:key value:value table:tableName] : [super localizedStringForKey:key value:value table:tableName];
}

@end

@implementation NSBundle (language)


+ (NSString *)currentLanguage {
    
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:AppLanguage];
    return language;
}

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [STBundle class]);
    });
}


+ (void)setLanguage:(NSString *)language {
    
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:AppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
