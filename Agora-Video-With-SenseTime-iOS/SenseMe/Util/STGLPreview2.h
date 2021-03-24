//
//  STGLPreview2.h
//  SenseMeEffects
//
//  Created by Sunshine on 2018/5/21.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/glext.h>
#import "st_mobile_common.h"

@interface STGLPreview2 : UIView

@property (nonatomic , strong) EAGLContext *glContext;

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context;

- (void)renderTexture:(GLuint)texture rotate:(st_rotate_type)rotateType;

@end
