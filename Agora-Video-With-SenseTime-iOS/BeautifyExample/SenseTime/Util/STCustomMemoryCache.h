//
//  STCustomMemoryCache.h
//
//  Created by sluin on 2017/5/6.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCustomMemoryCache : NSObject

@property (readonly, copy) NSArray<id> *allKeys;
@property (readonly, copy) NSArray<id> *allValues;

- (void)setObject:(id)anObject forKey:(id)aKey;
- (id)objectForKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;
- (void)removeAllObjects;

- (void)enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;


@end
