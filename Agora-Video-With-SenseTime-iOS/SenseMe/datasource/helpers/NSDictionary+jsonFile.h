//
//  NSDictionary+jsonFile.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (jsonFile)

/// 从本地json读取效果
/// @param jsonFileName json file's name
+(instancetype)efTakeOutDatasourceFromJson:(NSString *)jsonFileName;

@end

