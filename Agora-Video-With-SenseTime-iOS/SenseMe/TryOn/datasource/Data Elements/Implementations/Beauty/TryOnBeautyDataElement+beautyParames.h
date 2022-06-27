//
//  TryOnBeautyDataElement+beautyParames.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "TryOnBeautyDataElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface TryOnBeautyDataElement (beautyParames)

-(NSArray<TryOnBeautyParam *> *)generateBeauty1;
-(NSArray<TryOnBeautyParam *> *)generateBeauty2;

@end

NS_ASSUME_NONNULL_END
