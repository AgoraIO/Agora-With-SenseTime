//
//  TryOnBeautyDataElement.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "TryOnBeautyDataElement.h"
#import "TryOnBeautyDataElement+beautyParames.h"

@implementation TryOnBeautyDataElement

-(instancetype)init {
    self = [super init];
    if (self) {
        _name = @"美颜";
        _items = [self generateItems];
    }
    return self;
}

-(NSArray<TryOnBeautyItem *> *)generateItems {
    TryOnBeautyItem *item1 = [[TryOnBeautyItem alloc] init];
    item1.name = @"美颜1";
    item1.imageName = @"tryon_style1";
    item1.params = [self generateBeauty1];
    
    TryOnBeautyItem *item2 = [[TryOnBeautyItem alloc] init];
    item2.name = @"美颜2";
    item2.imageName = @"tryon_style2";
    item2.params = [self generateBeauty2];
    
    return @[item1, item2];
}

@end

@implementation TryOnBeautyItem

@end

@implementation TryOnBeautyParam

@end
