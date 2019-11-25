//
//  STLock.m
//  SenseMeEffects
//
//  Created by Lin Sun on 2018/11/19.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "STLock.h"

@interface STLock ()
{
    dispatch_semaphore_t _lock;
}
@end

@implementation STLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _lock = dispatch_semaphore_create(1);
    }
    
    return self;
}

- (void)lock
{
    dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER);
}

- (void)unlock
{
    dispatch_semaphore_signal(self->_lock);
}

@end
