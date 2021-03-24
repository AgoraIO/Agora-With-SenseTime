//
//  SenseBeautifyManager.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/19.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

#import "STParamUtil.h"
#import "STCollectionView.h"
#import "STBMPModel.h"
#import "STBeautySlider.h"

#import "st_mobile_common.h"
#import "st_mobile_human_action.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _SenseBeautifyModel {
    int iWidth;
    int iHeight;
    
    st_rotate_type stMobileRotate;
    st_mobile_human_action_t newDetectResult;
    
    BOOL isTextureOriginReady;
    GLuint textureOriginInput;
} SenseBeautifyModel;

@protocol SenseBeautifyDelegate <NSObject>
- (void)updateEAGLContext;
@end

@interface SenseBeautifyManager : NSObject

@property (nonatomic, weak) id<SenseBeautifyDelegate> senseBeautifyDelegate;

- (void)setupHandle;

- (void)initResultTextureWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight cvTextureCache:(CVOpenGLESTextureCacheRef)textureCache;

- (void)resetBmp;

- (void)releaseResultTexture;
- (void)releaseResources;

- (uint64_t)currentActionWithBeautify:(uint64_t)originalAction;
- (uint64_t)currentActionWithMakeUp:(uint64_t)originalAction;
- (CVPixelBufferRef)captureOutputSenseBeautifyModel:(SenseBeautifyModel)model textureResult:(GLuint*)textureResult pixelBufffer:(CVPixelBufferRef)pixelBufffer;

// for view init data
@property (nonatomic, strong) NSArray<STNewBeautyCollectionViewModel *> *microSurgeryModels;
@property (nonatomic, strong) NSArray<STNewBeautyCollectionViewModel *> *baseBeautyModels;
@property (nonatomic, strong) NSArray<STNewBeautyCollectionViewModel *> *beautyShapeModels;
@property (nonatomic, strong) NSArray<STNewBeautyCollectionViewModel *> *adjustModels;

// filter value
@property (nonatomic, assign) float fFilterStrength;

// get filter model with type
- (NSArray *)getFilterModelsByType:(STEffectsType)type;

// on slider value changed
- (void)beautySliderValueChanged:(float)value beautySelectModel:(STNewBeautyCollectionViewModel *)selectModel;
- (void)filterSliderValueChanged:(float)value;
- (void)bmpSliderValueChanged:(float)value;

// on click reset button
- (void)resetBeautyValuesWithType:(STEffectsType)type filterModelPath:(NSString *)filterModelPath;

// on click filter view
- (void)handleFilterChanged:(STCollectionViewDisplayModel *)model;

// on click BMP view
- (void)handleBMPChanged:(STBMPModel *)model sliderValueBlock:(nullable void(^)(float)) block;

@end

NS_ASSUME_NONNULL_END

