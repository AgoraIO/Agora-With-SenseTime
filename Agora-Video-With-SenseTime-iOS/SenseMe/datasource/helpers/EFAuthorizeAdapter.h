//
//  EFAuthorizeAdapter.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/7/8.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFAuthorizeAdapter : NSObject

+(void)efAuthorizeWithCallback:(void(^)(BOOL isAuthorized, SenseArAuthorizeError code ,SenseArMaterialService * service))callback;

@end
