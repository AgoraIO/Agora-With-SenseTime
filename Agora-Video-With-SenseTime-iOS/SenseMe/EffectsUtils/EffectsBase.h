//
//  BeautyBase.h
//  Effects
//
//  Created by sunjian on 2021/5/8.
//  Copyright © 2021 sjuinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "st_mobile_common.h"
#import "st_mobile_human_action.h"
#import "st_mobile_animal.h"
#import <AVFoundation/AVFoundation.h>
#import "EffectsLog.h"
#import <OpenGLES/ES3/gl.h>

NS_ASSUME_NONNULL_BEGIN

@interface EffectsBase : NSObject

@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic) st_handle_t handle;
@property (nonatomic, assign) uint64_t config;
@property (nonatomic, assign) GLuint outputTexture;
@property (nonatomic) CVPixelBufferRef outputPixelBuffer;
@property (nonatomic) CVOpenGLESTextureRef outputCVTexture;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;


/// 创建纹理
/// @param width 纹理宽度
/// @param height 纹理高度
- (GLuint)createATexture:(int)width height:(int)height;


/// 创建纹理和CVPixelBuffer
/// @param width 图像宽度
/// @param height 图像高度
- (BOOL)createTextureAndPixelBufferWidth:(int)width
                                  height:(int)height
                               withCache:(CVOpenGLESTextureCacheRef)cache;

/// 销毁OpenGL资源
- (void)destoryGLResource;


/// OpenGL process Texture
/// @param inputTexture 输入纹理
/// @param width 纹理宽度
/// @param height 纹理高度
/// @param rotate 手机旋转角度
/// @param detectResult 人脸检测结果
/// @param outDetectResult 人脸检测结果输出
/// @param cache textrueCache
- (GLuint)processTexture:(GLuint)inputTexture
           outputTexture:(GLuint)outputTexture
                   width:(int)width
                  height:(int)height
                  rotate:(st_rotate_type)rotate
            detectResult:(st_mobile_human_action_t)detectResult
            animalResult:(st_mobile_animal_face_t const *)animalResult
             animalCount:(int)animalCount
         outDetectResult:(st_mobile_human_action_t)outDetectResult
               withCache:(CVOpenGLESTextureCacheRef)cache
          outPixelFormat:(st_pixel_format)fmt_out
               outBuffer:(unsigned char *)img_out;

/// 获取detect Config
- (uint64_t)getDetectConfig;

/// 获取detect Config
- (uint64_t)getAnimalDetectConfig;

/// 设置当前EAGLContext
/// @param glContext 当前GLContext
- (void)setCurrentEAGLContext:(EAGLContext*)glContext;

@end

NS_ASSUME_NONNULL_END
