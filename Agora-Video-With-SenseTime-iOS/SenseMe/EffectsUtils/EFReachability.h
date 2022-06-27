//
//  EFReachability.h
//  SenseAr
//
//  Created by sluin on 16/10/28.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SenseArNetWorkStatus) {
    SenseArNetWorkStatusNotReachable = 0,
    SenseArNetWorkStatusUnknown = 1,
    SenseArNetWorkStatusWWAN2G = 2,
    SenseArNetWorkStatusWWAN3G = 3,
    SenseArNetWorkStatusWWAN4G = 4,
    
    SenseArNetWorkStatusWiFi = 9,
};

extern NSString *kSenseArNetWorkReachabilityChangedNotification;

@interface EFReachability : NSObject

+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

+ (instancetype)reachabilityWithAddress:(const struct sockaddr *)hostAddress;

+ (instancetype)reachabilityForInternetConnection;

- (BOOL)startNotifier;

- (void)stopNotifier;

- (SenseArNetWorkStatus)currentReachabilityStatus;

@end
