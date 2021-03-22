//
//  STLock.h
//  SenseMeEffects
//
//  Created by Lin Sun on 2018/11/19.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STLock : NSObject

- (void)lock;

- (void)unlock;

@end

NS_ASSUME_NONNULL_END
