//
//  EffectsGLPreview.h
//  SenseMeEffects
//
//  Created by Sunshine on 2018/5/21.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES3/glext.h>
#import "st_mobile_common.h"
#import <AVFoundation/AVFoundation.h>

@interface EffectsGLPreview : UIView

@property (nonatomic , strong) EAGLContext *glContext;

@property (nonatomic, assign) GLfloat scale;

- (instancetype)initWithFrame:(CGRect)frame
                      context:(EAGLContext *)context;

- (void)renderPixelBuffer:(CVPixelBufferRef)pixelBuffer
                   rotate:(st_rotate_type)rotate;

- (void)renderTexture:(GLuint)texture
               rotate:(st_rotate_type)rotate;

@end
