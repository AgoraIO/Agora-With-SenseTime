//
//  EFMachineVersion.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/9/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMachineVersion.h"
#import "sys/utsname.h"

static NSInteger const ef_iPhone8Code = 101;

static NSInteger ef_canShowCartonFlag = 0;

@implementation EFMachineVersion

+(BOOL)canShowCartonOfEffcts0805 {
    if (ef_canShowCartonFlag != -1) return ef_canShowCartonFlag;
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@"iPhone" withString:@""];
    deviceString = [deviceString stringByReplacingOccurrencesOfString:@"," withString:@""];
    ef_canShowCartonFlag = deviceString.integerValue > ef_iPhone8Code;
    return ef_canShowCartonFlag;
}

+(BOOL)isiPhone5sOrLater {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];

    if([phoneType  isEqualToString:@"iPhone1,1"])  return NO;//@"iPhone 2G";

    if([phoneType  isEqualToString:@"iPhone1,2"])  return NO;// @"iPhone 3G";

    if([phoneType  isEqualToString:@"iPhone2,1"])  return NO;// @"iPhone 3GS";

    if([phoneType  isEqualToString:@"iPhone3,1"])  return NO;// @"iPhone 4";

    if([phoneType  isEqualToString:@"iPhone3,2"])  return NO;//@"iPhone 4";

    if([phoneType  isEqualToString:@"iPhone3,3"])  return NO;//@"iPhone 4";

    if([phoneType  isEqualToString:@"iPhone4,1"])  return NO;//@"iPhone 4S";

    if([phoneType  isEqualToString:@"iPhone5,1"])  return NO;//@"iPhone 5";

    if([phoneType  isEqualToString:@"iPhone5,2"])  return NO;//@"iPhone 5";

    if([phoneType  isEqualToString:@"iPhone5,3"])  return NO;//@"iPhone 5c";

    if([phoneType  isEqualToString:@"iPhone5,4"])  return NO;//@"iPhone 5c";

    if([phoneType  isEqualToString:@"iPhone6,1"])  return NO;//@"iPhone 5s";

    if([phoneType  isEqualToString:@"iPhone6,2"])  return NO;//@"iPhone 5s";
    
    return YES;
}

@end
