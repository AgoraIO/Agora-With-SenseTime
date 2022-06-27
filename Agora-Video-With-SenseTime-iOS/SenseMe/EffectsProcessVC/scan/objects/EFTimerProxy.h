//
//  EFTimerProxy.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFTimerProxy : NSProxy

-(instancetype)initWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
