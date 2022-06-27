//
//  TryOnDataElementInterface.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFSenseArMaterialDataModels.h"
#import "st_mobile_effect.h"

typedef enum : NSUInteger {
    TryOnGroupTypeColor,
    TryOnGroupTypeStyle,
} TryOnGroupType;

@protocol TryOnBeautyItemInterface, TryOnGroupInterface, TryOnItemInterface;

@protocol TryOnDataElementInterface <NSObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<id<TryOnBeautyItemInterface>> *items;
@property (nonatomic, strong) id<TryOnGroupInterface> colors;
@property (nonatomic, strong) id<TryOnGroupInterface> styles;

@property (nonatomic, assign) st_effect_beauty_type_t tryOnBeautyType;
@property (nonatomic, assign) TryOnGroupType currentSelectedGroupType;

@property (nonatomic) st_effect_tryon_info_t *tryonInfo;

@end

@protocol TryOnGroupInterface <NSObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *highLightImageName;
@property (nonatomic, strong) NSArray<id<TryOnItemInterface>> *items;
@property (nonatomic, strong) SenseArMaterialGroup *materialGroup;

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) NSIndexPath *currentIndexPath;

@end

@protocol TryOnItemInterface <NSObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;

@end

@protocol TryOnBeautyItemInterface <NSObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;

@end
