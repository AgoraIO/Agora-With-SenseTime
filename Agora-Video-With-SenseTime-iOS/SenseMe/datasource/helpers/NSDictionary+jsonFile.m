//
//  NSDictionary+jsonFile.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "NSDictionary+jsonFile.h"

static NSString * const EFSuffixTypeJson = @"json";

@implementation NSDictionary (jsonFile)

+(instancetype)efTakeOutDatasourceFromJson:(NSString *)jsonFileName {
    if ([jsonFileName hasSuffix:@".json"]) jsonFileName = [jsonFileName componentsSeparatedByString:@"."].firstObject;
    if (!jsonFileName) return @{};
    NSString * path = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:EFSuffixTypeJson];
    NSData * data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
