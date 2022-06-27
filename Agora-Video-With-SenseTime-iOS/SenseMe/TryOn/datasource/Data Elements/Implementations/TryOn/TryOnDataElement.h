//
//  TryOnDataElement.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/10.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TryOnDataElementInterface.h"
#import "st_mobile_effect.h"

@interface TryOnDataElement : NSObject <TryOnDataElementInterface, YYModel>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<id<TryOnBeautyItemInterface>> *items;
@property (nonatomic, strong) id<TryOnGroupInterface> colors;
@property (nonatomic, strong) id<TryOnGroupInterface> styles;
@property (nonatomic, assign) st_effect_beauty_type_t tryOnBeautyType;
@property (nonatomic, assign) TryOnGroupType currentSelectedGroupType;
@property (nonatomic) st_effect_tryon_info_t *tryonInfo;

@end

@interface TryOnGroup : NSObject <YYModel, TryOnGroupInterface>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *highLightImageName;
@property (nonatomic, strong) NSArray<id<TryOnItemInterface>> *items;
@property (nonatomic, strong) SenseArMaterialGroup *materialGroup;

@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) NSIndexPath *currentIndexPath;

@end

@interface TryOnItem : NSObject <YYModel, TryOnItemInterface>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) int type;

@end
