//
//  EFScanViewControllerScanResultObject.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/2/25.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "EFScanViewControllerScanResultObject.h"

@implementation EFScanViewControllerScanResultObject

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"urlString": @[@"urlString", @"zip"]
    };
}

@end
