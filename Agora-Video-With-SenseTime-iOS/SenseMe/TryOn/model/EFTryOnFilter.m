//
//  EFTryOnFilter.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/23.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnFilter.h"
#import "NSDictionary+jsonFile.h"

@implementation EFTryOnFilter
{
    NSMutableDictionary * _beautyRenderModelCache;
}

+(instancetype)sharedInstance {
    static EFTryOnFilter * _sharedFilter = nil;
    static dispatch_once_t sharedFilterToken;
    dispatch_once(&sharedFilterToken, ^{
        _sharedFilter = [[EFTryOnFilter alloc] init];
    });
    return _sharedFilter;
}

-(NSArray <EFRenderModel *> *)tryonBeautyRenderModelsByParameters:(NSArray *)parameters andName:(NSString *)name {
    if (!_beautyRenderModelCache) {
        _beautyRenderModelCache = [NSMutableDictionary dictionary];
    } else {
        if ([_beautyRenderModelCache.allKeys containsObject:name]) {
            return _beautyRenderModelCache[name];
        }
    }
    NSDictionary * rootDict = [NSDictionary efTakeOutDatasourceFromJson:@"_efGeneratAllFunctionDataSources"];
    NSArray <NSArray *> * beautyInfo = rootDict[@"all_categories"]; // 二维数组
    NSMutableArray * result = [NSMutableArray array];
    
    for (NSInteger i = 0; i < beautyInfo.count; i ++) {
        for (NSInteger j = 0; j < beautyInfo[i].count; j ++) {
            EFRenderModel * renderModel = [EFRenderModel yy_modelWithDictionary:beautyInfo[i][j]];
            renderModel.efAction = EFRenderModelActionSelect;
            renderModel.efStrength = [self _efRenderModel:renderModel getStrengthFromUIStrength: ((NSNumber *)parameters[i][j]).floatValue];
            [result addObject:renderModel];
        }
    }
    _beautyRenderModelCache[name] = result;
    return result;
}

-(CGFloat)_efRenderModel:(EFRenderModel *)renderModel getStrengthFromUIStrength:(CGFloat)originStrength {
//    NSUInteger realType = renderModel.efType >> 5;
//    /**
//     下巴303/额头304/长鼻307/嘴型309/缩人中310/眼距311/眼睛角度312
//     */
//    NSArray * specialTypes = @[@303, @304, @307, @309, @310, @311, @312];
//    if ([specialTypes containsObject:@(realType)]) {
//        return originStrength * 2 - 100;
//    }
    return originStrength;
}

@end
