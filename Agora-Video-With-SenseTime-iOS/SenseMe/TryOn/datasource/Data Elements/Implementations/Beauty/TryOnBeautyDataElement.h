//
//  TryOnBeautyDataElement.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TryOnDataElementInterface.h"

#import "st_mobile_effect.h"

NS_ASSUME_NONNULL_BEGIN

@class TryOnBeautyItem, TryOnBeautyParam;

@interface TryOnBeautyDataElement : NSObject <TryOnDataElementInterface, YYModel>

@property (nonatomic, copy) NSString *name; // 美颜
@property (nonatomic, strong) NSArray<id<TryOnBeautyItemInterface>> *items;

@end

@interface TryOnBeautyItem : NSObject <TryOnBeautyItemInterface, YYModel>

@property (nonatomic, copy) NSString *name; // 美颜1 美颜2
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSArray<TryOnBeautyParam *> *params;

@end

@interface TryOnBeautyParam : NSObject <YYModel> // 参数

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) st_effect_beauty_type_t type;
@property (nonatomic, assign) int mode;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) CGFloat strength;
@property (nonatomic, assign) st_effect_beauty_param_t otherBeautyParam;

@end

NS_ASSUME_NONNULL_END
