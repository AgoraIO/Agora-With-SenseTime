//
//  STColorConversion.h
//  SenseMeEffects
//
//  Created by sunjian on 2019/10/31.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#ifndef STColorConversion_h
#define STColorConversion_h
#include <GLKit/GLKit.h>

extern GLfloat *kColorConversion601;
extern GLfloat *kColorConversion601FullRange;
extern GLfloat *kColorConversion709;
extern NSString * const KVertexShaderString;
extern NSString * const KFragmentShaderString;
extern NSString * const kYUVVideoRangeConversionForRGFragmentShaderString;
extern NSString * const kYUVFullRangeConversionForLAFragmentShaderString;
extern NSString * const kYUVVideoRangeConversionForLAFragmentShaderString;
extern NSString * const kYUVFullRangeConversionForLAFragmentShaderString1;

#endif /* STColorConversion_h */
