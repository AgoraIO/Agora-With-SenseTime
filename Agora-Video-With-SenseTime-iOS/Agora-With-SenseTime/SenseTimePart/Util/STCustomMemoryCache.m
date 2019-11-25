//
//  STCustomMemoryCache.m
//
//  Created by sluin on 2017/5/6.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import "STCustomMemoryCache.h"

#define STSemaphoreLock() dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER)
#define STSemaphoreUnlock() dispatch_semaphore_signal(self->_lock)


@interface STCustomMemoryCache ()
{
    dispatch_semaphore_t _lock;
}

@property (nonatomic , strong) NSMutableDictionary *dicCache;

@end

@implementation STCustomMemoryCache

- (instancetype)init
{
    self = [super init];
    if (self) {

        _lock = dispatch_semaphore_create(1);
        _dicCache = [NSMutableDictionary dictionary];
    }
    return self;
}



- (NSArray<id> *)allKeys
{
    STSemaphoreLock();
    
    NSArray *arrAllKeys = [_dicCache allKeys];
    
    STSemaphoreUnlock();
    
    return arrAllKeys;
}

- (NSArray<id> *)allValues
{
    STSemaphoreLock();
    
    NSArray *arrAllValues = [_dicCache allValues];
    
    STSemaphoreUnlock();
    
    return arrAllValues;
}

- (void)setObject:(id)anObject forKey:(id)aKey;
{
    if (aKey == nil || anObject == nil) {
        
        return;
    }
    
    STSemaphoreLock();
    
    [_dicCache setObject:anObject forKey:aKey];
    
    STSemaphoreUnlock();
}
- (id)objectForKey:(id)aKey
{
    if (aKey == nil) {
        
        return nil;
    }
    
    STSemaphoreLock();
    
    id obj = [_dicCache objectForKey:aKey];
    
    STSemaphoreUnlock();
    
    return obj;
}

- (void)removeObjectForKey:(id)aKey
{
    if (aKey == nil) {
        
        return;
    }
    
    STSemaphoreLock();
    
    [_dicCache removeObjectForKey:aKey];
    
    STSemaphoreUnlock();
}

- (void)removeAllObjects
{
    STSemaphoreLock();
    
    [_dicCache removeAllObjects];
    
    STSemaphoreUnlock();
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    STSemaphoreLock();
    
    [_dicCache enumerateKeysAndObjectsUsingBlock:block];
    
    STSemaphoreUnlock();
}

- (void)dealloc
{
    _lock = nil;
    self.dicCache = nil;
}


@end
