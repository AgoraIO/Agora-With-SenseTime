//
//  EFScanResourceModel.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanResourceModel.h"

@implementation EFScanResourceModel

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init]; return [self yy_modelInitWithCoder:aDecoder];
}

+(BOOL)supportsSecureCoding {
    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

-(NSString *)imageName {
    return _imageName ?: @"scan_default_icon";
}

@end
