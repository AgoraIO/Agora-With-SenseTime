//
//  SenseMEUtils.h
//  SenseMeEffects
//
//  Created by Sunshine on 2019/1/14.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SenseMEUtils : NSObject

+ (instancetype)sharedInstance;

- (void)checkActiveCodeNativeOnSuccess:(void (^)(void))checkSuccess
                             onFailure:(void (^)(int checkResult))checkFailure;

- (void)checkActiveCodeOnlineOnSuccess:(void (^)(void))checkSuccess
                             onFailure:(void (^)(int checkResult))checkFailure;

+ (BOOL)isCheckedActiveCode;

@end

NS_ASSUME_NONNULL_END
