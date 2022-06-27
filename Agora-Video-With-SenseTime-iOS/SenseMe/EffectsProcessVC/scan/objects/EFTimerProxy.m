//
//  EFTimerProxy.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTimerProxy.h"

@interface EFTimerProxy ()

@property (nonatomic, weak) id target;

@end

@implementation EFTimerProxy

-(instancetype)initWithTarget:(id)target {
    EFTimerProxy *timerProxy = [EFTimerProxy alloc];
    timerProxy.target = target;
    return timerProxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [self.target methodSignatureForSelector:sel];
}

-(void)forwardInvocation:(NSInvocation *)invocation {
    invocation.target = self.target;
    [invocation invokeWithTarget:self.target];
}

@end
