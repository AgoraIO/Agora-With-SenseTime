//
//  STImageUtils.m
//  STFaceRebuild
//
//  Created by sunjian on 2020/10/13.
//  Copyright © 2020 dongshuaijun. All rights reserved.
//

#import "EffectsImageUtils.h"

@implementation EffectsImageUtils

+ (UIImage *)imageWithPath:(NSString *)filePath{
    if (filePath.length <= 0) {
        return nil;
    }
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)imageWithPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    CIImage *image_ci = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    return  [UIImage imageWithCIImage:image_ci];
}

+ (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    UIImage *image = [self imageWithPixelBuffer:imageBuffer];
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    return image;
    
    //TODO
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(baseAddress,
//                                                 width,
//                                                 height,
//                                                 8,
//                                                 bytesPerRow,
//                                                 colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    CGImageRelease(quartzImage);
//    return (image);
}

+ (UIImage *)convertImage:(UIImage *)image toSize:(CGSize)size{
    if (!image) {
        return nil;
    }
    CGSize srcSize = image.size;
    if (CGSizeEqualToSize(srcSize, size)) {
        return image;
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    [image drawInRect:rect];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizeImage;
}

+ (void)convertUIImage:(UIImage *)uiImage toBGRABytes:(unsigned char *)pImage {
    CGImageRef cgImage = [uiImage CGImage];
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    int iWidth = uiImage.size.width;
    int iHeight = uiImage.size.height;
    
    int maxSize = 1080 * 1920;    
    if (iWidth * iHeight > maxSize) {
        int multiple = 1;
        if (iWidth > 1080) {
            multiple = (int)ceil(iWidth / 1080);
        } else if (iHeight > 1920) {
            multiple = (int)ceil(iHeight / 1920);
        }
        iWidth /= multiple;
        iHeight /= multiple;
    }
    
    int iBytesPerPixel = 4;
    int iBytesPerRow = iBytesPerPixel * iWidth;
    int iBitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(pImage,
                                                 iWidth,
                                                 iHeight,
                                                 iBitsPerComponent,
                                                 iBytesPerRow,
                                                 colorspace,
                                                 kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast
                                                 );
    
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);

    if (!context) {
        CGColorSpaceRelease(colorspace);
        return;
    }
    
    CGRect rect = CGRectMake(0 , 0 , iWidth , iHeight);
    CGContextDrawImage(context , rect ,cgImage);
    CGColorSpaceRelease(colorspace);
    CGContextRelease(context);
}

+ (GLint)textureWithImage:(UIImage *)image{
    if (!image) {
        return -1;
    }
    //    unsigned char * imageData = [self rawDataWithImage:image];
    //    GLint texOut = [GLManager createTextureWithData:imageData size:image.size];
    //    if (texOut >= 0) {
    //        free(imageData);
    //        imageData = nil;
    //        return texOut;
    //    }
    return -1;
}

+ (unsigned char *)rawDataWithImage:(UIImage *)image {
    BOOL createCGImageByCIImage = NO;
    
    if (!image) {
        return nil;
    }
    CGSize size = image.size;
    unsigned char * rawData = (unsigned char *)malloc(sizeof(unsigned char *) * (int)size.width * (int)size.height * 4);
    CGImageRef image_cg = image.CGImage;
    
    if (!image_cg) {
        //do not forget release
        image_cg = [[CIContext contextWithOptions:nil] createCGImage:image.CIImage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        createCGImageByCIImage = YES;
    }
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    int w = size.width;
    int h = size.height;
    int iBytesPerPixel = 4;
    int iBitsPerRow = iBytesPerPixel * w;
    int iBitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 w,
                                                 h,
                                                 iBitsPerComponent,
                                                 iBitsPerRow,
                                                 colorspace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    if (!context) {
        CGColorSpaceRelease(colorspace);
        free(rawData);
        rawData = nil;
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextDrawImage(context, rect, image_cg);
    if (createCGImageByCIImage) {
        CGImageRelease(image_cg);
    }
    CGColorSpaceRelease(colorspace);
    CGContextRelease(context);
    return rawData;
}

+ (unsigned char *)grayDataWithImage:(UIImage *)image{
    if (!image) {
        return nil;
    }
    CGSize size = image.size;
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    int length = sizeof(unsigned char *)*size.width*size.height;
    unsigned char *pImage = (unsigned char *)malloc(length);
    CGContextRef context = CGBitmapContextCreate(pImage,
                                                 size.width,
                                                 size.height,
                                                 8,
                                                 size.width,
                                                 space,
                                                 kCGImageAlphaNone);
    CGColorSpaceRelease(space);
    if (!context) {
        free(pImage);
        pImage = nil;
        return nil;
    }
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
    CGContextRelease(context);
    return pImage;
}

+ (CGImageRef)createFromData:(NSData *)data width:(int)width height:(int)height {
    CGColorSpaceRef colorSpace;
    colorSpace = CGColorSpaceCreateDeviceGray();
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(width,
                                        height,
                                        8,
                                        8,
                                        width,
                                        colorSpace,
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,
                                        provider,
                                        NULL,
                                        false,
                                        kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return imageRef;
}

+ (CGImageRef)createCGImageFromData:(unsigned char *)data
                              width:(int)width
                             height:(int)height
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int iBytesPerPixel = 4;
    int iBitsPerRow = iBytesPerPixel * width;
    int iBitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(data,
                                                 width,
                                                 height,
                                                 iBitsPerComponent,
                                                 iBitsPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return quartzImage;
}


+ (CGImageRef)getCGImageWithTexture:(GLuint)iTexture
                              width:(int)iWidth
                             height:(int)iHeight
                          ciContext:(CIContext *)ciContext{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CIImage *ciImage = [CIImage imageWithTexture:iTexture size:CGSizeMake(iWidth, iHeight) flipped:YES colorSpace:colorSpace];
    CGImageRef cgImage = [ciContext createCGImage:ciImage fromRect:CGRectMake(0, 0, iWidth, iHeight)];
    CGColorSpaceRelease(colorSpace);
    return cgImage;
}
@end
