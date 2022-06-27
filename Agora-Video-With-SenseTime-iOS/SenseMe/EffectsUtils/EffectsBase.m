//
//  BeautyBase.m
//  Effects
//
//  Created by sunjian on 2021/5/8.
//  Copyright © 2021 sjuinan. All rights reserved.
//

#import "EffectsBase.h"
#import "EffectsUtils.h"

@implementation EffectsBase

- (void)dealloc{
}

- (GLuint)createATexture:(int)width height:(int)height{
    self.outputTexture = [EffectsUtils createaTextureWithData:NULL width:width height:height];
    return self.outputTexture;
}

- (BOOL)createTextureAndPixelBufferWidth:(int)width
                                  height:(int)height
                               withCache:(CVOpenGLESTextureCacheRef)cache{
    return  [EffectsUtils createTexture:&_outputTexture
                            pixelBuffer:&_outputPixelBuffer
                              cvTexture:&_outputCVTexture
                                  width:width
                                 height:height
                              withCache:cache];
}

- (void)destoryGLResource{
    if(self.outputTexture){
        GLuint texture = self.outputTexture;
        glDeleteTextures(1, &texture);
        self.outputTexture = 0;
    }
    if(self.outputPixelBuffer){
        CVPixelBufferRef pixelBuffer = self.outputPixelBuffer;
        CVPixelBufferRelease(pixelBuffer);
    }
    if(self.outputCVTexture){
        CVOpenGLESTextureRef cvTexture = self.outputCVTexture;
        CFRelease(cvTexture);
    }
}

- (void)setCurrentEAGLContext:(EAGLContext*)glContext{
    if ([EAGLContext currentContext] != glContext) {
        [EAGLContext setCurrentContext:glContext];
    }
}

- (uint64_t)getDetectConfig{
    return 0;
}
@end
