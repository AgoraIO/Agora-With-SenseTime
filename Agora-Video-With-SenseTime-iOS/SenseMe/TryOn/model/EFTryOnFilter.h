//
//  EFTryOnFilter.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/23.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFTryOnFilter : NSObject

+(instancetype)sharedInstance;

-(NSArray <EFRenderModel *> *)tryonBeautyRenderModelsByParameters:(NSArray *)parameters andName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
