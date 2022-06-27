//
//  EffectsPointsPainter.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/10/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "st_mobile_human_action.h"

NS_ASSUME_NONNULL_BEGIN

@interface EffectsPointsPainter : NSObject

- (void)createMetalTextureWithWidth:(int)width height:(int)height andPixelBuffer:(CVPixelBufferRef)pixelBuffer;

-(void)renderPointsWithDetectResult:(st_mobile_human_action_t)detectResult;

@end

NS_ASSUME_NONNULL_END
