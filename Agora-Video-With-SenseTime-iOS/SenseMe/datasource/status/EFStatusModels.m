//
//  EFStatusModels.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStatusModels.h"

@implementation EFStatusModels

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"efCachedStatusModels": EFRenderModel.class
    };
}

-(void)setEfCachedStatusModels:(NSMutableArray<EFRenderModel *> *)efCachedStatusModels {
    _efCachedStatusModels = [efCachedStatusModels mutableCopy];
}

#pragma mark - NSSecureCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    @synchronized (aCoder) {
        [self yy_modelEncodeWithCoder:aCoder];
    }
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

@end

@implementation EFRenderModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"efName": @[@"strName", @"efName", @"name"],
        @"efPath": @[@"strMaterialPath", @"efPath", @"path"],
        @"efRoute": @[@"route", @"efRoute"],
        @"efType": @[@"type", @"efType"],
        @"efStrength": @[@"efStrength", @"strength"],
        @"efMode": @[@"efMode", @"mode"],
        @"efStickerId": @[@"strID"]
    };
}

-(NSString *)efPath {
    NSString * basePath = NSHomeDirectory();
    if ([_efPath containsString:@"Bundle"]) {
        basePath = [[NSBundle mainBundle] bundlePath];
    }
    NSArray * filePathArray = [_efPath componentsSeparatedByString:@"/"];
    NSArray * basePathArray = [basePath componentsSeparatedByString:@"/"];
    NSMutableArray * fixedArray = [NSMutableArray array];
    for (NSInteger i = 0; i < filePathArray.count; i ++) {
        NSString * next = filePathArray[i];
        if (i < basePathArray.count) next = basePathArray[i];
        [fixedArray addObject:next];
    }
    _efPath = [fixedArray componentsJoinedByString:@"/"];
    return _efPath;
}

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

@end
