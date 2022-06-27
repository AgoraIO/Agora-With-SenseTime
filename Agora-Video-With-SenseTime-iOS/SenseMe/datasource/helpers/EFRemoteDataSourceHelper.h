//
//  EFRemoteDataSourceHelper.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenseArMaterialGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFRemoteDataSourceHelper : NSObject

+(void)efFetchAllRemoteGroupsWithMaterialsOnSuccess:(void (^)(NSArray <SenseArMaterialGroup *>* arrMaterialGroups))completeSuccess onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure;

@end

NS_ASSUME_NONNULL_END
