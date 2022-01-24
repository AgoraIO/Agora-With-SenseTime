//
//  STVFShader.m
//  SenseMeEffects
//
//  Created by Sunshine on 2018/6/15.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "STVFShader.h"

const char* vsh = "attribute vec4 position;\
attribute vec4 inputTextureCoordinate;\
varying vec2 textureCoordinate;\
void main()\
{\
gl_Position = position;\
textureCoordinate = inputTextureCoordinate.xy;\
}";

const char* fsh = "varying highp vec2 textureCoordinate;\
uniform sampler2D videoFrame;\
void main()\
{\
gl_FragColor = texture2D(videoFrame, textureCoordinate);\
}";

@implementation STVFShader

@end
