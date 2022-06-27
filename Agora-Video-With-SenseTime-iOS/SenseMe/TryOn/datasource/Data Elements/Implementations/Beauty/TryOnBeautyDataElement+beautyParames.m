//
//  TryOnBeautyDataElement+beautyParames.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import "TryOnBeautyDataElement+beautyParames.h"

@implementation TryOnBeautyDataElement (beautyParames)

/**
 @property (nonatomic, copy) NSString *name;
 @property (nonatomic, assign) st_effect_beauty_type_t type;
 @property (nonatomic, assign) int mode;
 @property (nonatomic, copy) NSString *path;
 @property (nonatomic, assign) CGFloat strength;
 @property (nonatomic, assign) st_effect_beauty_param_t otherBeautyParam;
 */

-(NSArray<TryOnBeautyParam *> *)generateBeauty1 {
    NSMutableArray *result = [NSMutableArray array];
    
    TryOnBeautyParam *whitten3 = [[TryOnBeautyParam alloc] init];
    whitten3.name = @"美白3";
    whitten3.type = EFFECT_BEAUTY_BASE_WHITTEN;
    whitten3.mode = 1;
    whitten3.strength = 75;
    whitten3.otherBeautyParam = EFFECT_BEAUTY_PARAM_ENABLE_WHITEN_SKIN_MASK;
    [result addObject:whitten3];
    
    
    TryOnBeautyParam *faceSmooth2 = [[TryOnBeautyParam alloc] init];
    faceSmooth2.name = @"磨皮2";
    faceSmooth2.type = EFFECT_BEAUTY_BASE_FACE_SMOOTH;
    faceSmooth2.mode = 1;
    faceSmooth2.strength = 60;
    [result addObject:faceSmooth2];
    
    TryOnBeautyParam *shrinkFace = [[TryOnBeautyParam alloc] init];
    shrinkFace.name = @"瘦脸";
    shrinkFace.type = EFFECT_BEAUTY_RESHAPE_SHRINK_FACE;
    shrinkFace.strength = 25;
    [result addObject:shrinkFace];
    
    TryOnBeautyParam *enlargeEye = [[TryOnBeautyParam alloc] init];
    enlargeEye.name = @"大眼";
    enlargeEye.type = EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE;
    enlargeEye.strength = 50;
    [result addObject:enlargeEye];
    
    TryOnBeautyParam *narrowFace = [[TryOnBeautyParam alloc] init];
    narrowFace.name = @"窄脸";
    narrowFace.type = EFFECT_BEAUTY_RESHAPE_NARROW_FACE;
    narrowFace.strength = 5;
    [result addObject:narrowFace];
    
    TryOnBeautyParam *roundEye = [[TryOnBeautyParam alloc] init];
    roundEye.name = @"圆眼";
    roundEye.type = EFFECT_BEAUTY_RESHAPE_ROUND_EYE;
    roundEye.strength = 10;
    [result addObject:roundEye];
    
    TryOnBeautyParam *longFace = [[TryOnBeautyParam alloc] init];
    longFace.name = @"高阶瘦脸-长脸";
    longFace.type = EFFECT_BEAUTY_PLASTIC_SHRINK_LONG_FACE;
    longFace.strength = 20;
    [result addObject:longFace];
    
    TryOnBeautyParam *chinLength = [[TryOnBeautyParam alloc] init];
    chinLength.name = @"下巴";
    chinLength.type = EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH;
    chinLength.strength = -15;
    [result addObject:chinLength];
    
    TryOnBeautyParam *philtrumLength = [[TryOnBeautyParam alloc] init];
    philtrumLength.name = @"缩人中";
    philtrumLength.type = EFFECT_BEAUTY_PLASTIC_PHILTRUM_LENGTH;
    philtrumLength.strength = 20;
    [result addObject:philtrumLength];
    
    TryOnBeautyParam *eyeDistance = [[TryOnBeautyParam alloc] init];
    eyeDistance.name = @"眼距";
    eyeDistance.type = EFFECT_BEAUTY_PLASTIC_EYE_DISTANCE;
    eyeDistance.strength = -20;
    [result addObject:eyeDistance];
    
    TryOnBeautyParam *brightEye = [[TryOnBeautyParam alloc] init];
    brightEye.name = @"亮眼";
    brightEye.type = EFFECT_BEAUTY_PLASTIC_BRIGHT_EYE;
    brightEye.strength = 25;
    [result addObject:brightEye];
    
    TryOnBeautyParam *removeDarkCircles = [[TryOnBeautyParam alloc] init];
    removeDarkCircles.name = @"祛黑眼圈";
    removeDarkCircles.type = EFFECT_BEAUTY_PLASTIC_REMOVE_DARK_CIRCLES;
    removeDarkCircles.strength = 69;
    [result addObject:removeDarkCircles];
    
    TryOnBeautyParam *removeNasolabialFolds = [[TryOnBeautyParam alloc] init];
    removeNasolabialFolds.name = @"祛法令纹";
    removeNasolabialFolds.type = EFFECT_BEAUTY_PLASTIC_REMOVE_NASOLABIAL_FOLDS;
    removeNasolabialFolds.strength = 60;
    [result addObject:removeNasolabialFolds];
    
    TryOnBeautyParam *toneSharpen = [[TryOnBeautyParam alloc] init];
    toneSharpen.name = @"锐化";
    toneSharpen.type = EFFECT_BEAUTY_TONE_SHARPEN;
    toneSharpen.strength = 50;
    [result addObject:toneSharpen];
    
    TryOnBeautyParam *toneClear = [[TryOnBeautyParam alloc] init];
    toneClear.name = @"清晰";
    toneClear.type = EFFECT_BEAUTY_TONE_CLEAR;
    toneClear.strength = 20;
    [result addObject:toneClear];
    
    return [result copy];
}

-(NSArray<TryOnBeautyParam *> *)generateBeauty2 {
    NSMutableArray *result = [NSMutableArray array];
    
    TryOnBeautyParam *whitten3 = [[TryOnBeautyParam alloc] init];
    whitten3.name = @"美白3";
    whitten3.type = EFFECT_BEAUTY_BASE_WHITTEN;
    whitten3.mode = 1;
    whitten3.strength = 25;
    whitten3.otherBeautyParam = EFFECT_BEAUTY_PARAM_ENABLE_WHITEN_SKIN_MASK;
    [result addObject:whitten3];
    
    
    TryOnBeautyParam *faceSmooth2 = [[TryOnBeautyParam alloc] init];
    faceSmooth2.name = @"磨皮2";
    faceSmooth2.type = EFFECT_BEAUTY_BASE_FACE_SMOOTH;
    faceSmooth2.mode = 1;
    faceSmooth2.strength = 25;
    [result addObject:faceSmooth2];
    
    TryOnBeautyParam *enlargeEye = [[TryOnBeautyParam alloc] init];
    enlargeEye.name = @"大眼";
    enlargeEye.type = EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE;
    enlargeEye.strength = 29;
    [result addObject:enlargeEye];
    
    TryOnBeautyParam *shrinkJaw = [[TryOnBeautyParam alloc] init];
    shrinkJaw.name = @"小脸";
    shrinkJaw.type = EFFECT_BEAUTY_RESHAPE_SHRINK_JAW;
    shrinkJaw.strength = 10;
    [result addObject:shrinkJaw];
    
    TryOnBeautyParam *narrowFace = [[TryOnBeautyParam alloc] init];
    narrowFace.name = @"窄脸";
    narrowFace.type = EFFECT_BEAUTY_RESHAPE_NARROW_FACE;
    narrowFace.strength = 25;
    [result addObject:narrowFace];
    
    TryOnBeautyParam *roundEye = [[TryOnBeautyParam alloc] init];
    roundEye.name = @"圆眼";
    roundEye.type = EFFECT_BEAUTY_RESHAPE_ROUND_EYE;
    roundEye.strength = 7;
    [result addObject:roundEye];
    
    TryOnBeautyParam *chinLength = [[TryOnBeautyParam alloc] init];
    chinLength.name = @"下巴";
    chinLength.type = EFFECT_BEAUTY_PLASTIC_CHIN_LENGTH;
    chinLength.strength = 20;
    [result addObject:chinLength];
    
    TryOnBeautyParam *appleMuscle = [[TryOnBeautyParam alloc] init];
    appleMuscle.name = @"苹果肌";
    appleMuscle.type = EFFECT_BEAUTY_PLASTIC_APPLE_MUSLE;
    appleMuscle.strength = 30;
    [result addObject:appleMuscle];
    
    TryOnBeautyParam *narrowNose = [[TryOnBeautyParam alloc] init];
    narrowNose.name = @"瘦鼻翼";
    narrowNose.type = EFFECT_BEAUTY_PLASTIC_NARROW_NOSE;
    narrowNose.strength = 21;
    [result addObject:narrowNose];
    
    TryOnBeautyParam *profilePhinoplasty = [[TryOnBeautyParam alloc] init];
    profilePhinoplasty.name = @"侧脸隆鼻";
    profilePhinoplasty.type = EFFECT_BEAUTY_PLASTIC_PROFILE_RHINOPLASTY;
    profilePhinoplasty.strength = 10;
    [result addObject:profilePhinoplasty];
    
    TryOnBeautyParam *eyeDistance = [[TryOnBeautyParam alloc] init];
    eyeDistance.name = @"眼距";
    eyeDistance.type = EFFECT_BEAUTY_PLASTIC_EYE_DISTANCE;
    eyeDistance.strength = -23;
    [result addObject:eyeDistance];
    
    TryOnBeautyParam *brightEye = [[TryOnBeautyParam alloc] init];
    brightEye.name = @"亮眼";
    brightEye.type = EFFECT_BEAUTY_PLASTIC_BRIGHT_EYE;
    brightEye.strength = 25;
    [result addObject:brightEye];
    
    TryOnBeautyParam *removeDarkCircles = [[TryOnBeautyParam alloc] init];
    removeDarkCircles.name = @"祛黑眼圈";
    removeDarkCircles.type = EFFECT_BEAUTY_PLASTIC_REMOVE_DARK_CIRCLES;
    removeDarkCircles.strength = 69;
    [result addObject:removeDarkCircles];
    
    TryOnBeautyParam *removeNasolabialFolds = [[TryOnBeautyParam alloc] init];
    removeNasolabialFolds.name = @"祛法令纹";
    removeNasolabialFolds.type = EFFECT_BEAUTY_PLASTIC_REMOVE_NASOLABIAL_FOLDS;
    removeNasolabialFolds.strength = 60;
    [result addObject:removeNasolabialFolds];
    
    TryOnBeautyParam *whiteTeeth = [[TryOnBeautyParam alloc] init];
    whiteTeeth.name = @"白牙";
    whiteTeeth.type = EFFECT_BEAUTY_PLASTIC_WHITE_TEETH;
    whiteTeeth.strength = 20;
    [result addObject:whiteTeeth];
    
    TryOnBeautyParam *shrinkCheekbone = [[TryOnBeautyParam alloc] init];
    shrinkCheekbone.name = @"瘦颧骨";
    shrinkCheekbone.type = EFFECT_BEAUTY_PLASTIC_SHRINK_CHEEKBONE;
    shrinkCheekbone.strength = 36;
    [result addObject:shrinkCheekbone];
    
    TryOnBeautyParam *toneSharpen = [[TryOnBeautyParam alloc] init];
    toneSharpen.name = @"锐化";
    toneSharpen.type = EFFECT_BEAUTY_TONE_SHARPEN;
    toneSharpen.strength = 50;
    [result addObject:toneSharpen];
    
    TryOnBeautyParam *toneClear = [[TryOnBeautyParam alloc] init];
    toneClear.name = @"清晰";
    toneClear.type = EFFECT_BEAUTY_TONE_CLEAR;
    toneClear.strength = 20;
    [result addObject:toneClear];
    
    return [result copy];
}

@end
