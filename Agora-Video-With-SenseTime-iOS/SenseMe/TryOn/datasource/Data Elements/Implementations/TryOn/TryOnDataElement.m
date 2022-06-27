//
//  TryOnDataElement.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/10.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "TryOnDataElement.h"

@implementation TryOnDataElement

-(instancetype)init {
    self = [super init];
    if (self) {
        _name = @"口红";
        TryOnGroup *colors = [[TryOnGroup alloc] init];
        colors.name = @"颜色";
        colors.imageName = @"tryon_color_gray";
        colors.highLightImageName = @"tryon_color";
        _colors = colors;
    }
    return self;
}

-(void)dealloc {
    if (_tryonInfo) {
        free(_tryonInfo);
    }
}

@end


@implementation TryOnGroup

@end

@implementation TryOnItem

@end
