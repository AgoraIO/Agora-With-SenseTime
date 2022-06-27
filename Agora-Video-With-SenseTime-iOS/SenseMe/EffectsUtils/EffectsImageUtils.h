//
//  STImageUtils.h
//  STFaceRebuild
//
//  Created by sunjian on 2020/10/13.
//  Copyright © 2020 dongshuaijun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>

@interface EffectsImageUtils : NSObject

+ (UIImage *)imageWithPath:(NSString *)filePath;

+ (UIImage *)imageWithPixelBuffer:(CVPixelBufferRef)pixelBuffer;

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

+ (UIImage *)convertImage:(UIImage *)image toSize:(CGSize)size;

+ (void)convertUIImage:(UIImage *)uiImage toBGRABytes:(unsigned char *)pImage;

+ (GLint)textureWithImage:(UIImage *)image;

+ (unsigned char *)rawDataWithImage:(UIImage *)image;

+ (unsigned char *)grayDataWithImage:(UIImage *)image;

+ (CGImageRef)createFromData:(NSData *)data width:(int)width height:(int)height;

+ (CGImageRef)createCGImageFromData:(unsigned char *)data
                              width:(int)width
                             height:(int)height;

+ (CGImageRef)getCGImageWithTexture:(GLuint)iTexture
                              width:(int)iWidth
                             height:(int)iHeight
                          ciContext:(CIContext *)ciContext;
@end
