//
//  SenseTimeUtil.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/22.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseTimeUtil.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>

#import "SaveToastUtil.h"
#import "STParamUtil.h"

@implementation SenseTimeUtil


+ (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)bScaleToFit videoSettingSize:(CGSize)size
{
    CGRect rectRet = rect;
    
    CGFloat fWidth = size.width;
    CGFloat fHeight = size.height;
    
    float fScaleX = fWidth / CGRectGetWidth(rect);
    float fScaleY = fHeight / CGRectGetHeight(rect);
    float fScale = bScaleToFit ? fmaxf(fScaleX, fScaleY) : fminf(fScaleX, fScaleY);
    
    fWidth /= fScale;
    fHeight /= fScale;
    
    CGFloat fX = rect.origin.x - (fWidth - rect.size.width) / 2.0f;
    CGFloat fY = rect.origin.y - (fHeight - rect.size.height) / 2.0f;
    
    rectRet = CGRectMake(fX, fY, fWidth, fHeight);
    
    return rectRet;
}

+ (void)snapWithView:(UIView *)preview  width:(int)iWidth height:(int)iHeight {
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(iWidth, iHeight), NO, 1.0);
        [preview drawViewHierarchyInRect:CGRectMake(0, 0, iWidth, iHeight) afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [assetLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                       orientation:ALAssetOrientationUp
                                   completionBlock:^(NSURL *assetURL, NSError *error) {
            [SaveToastUtil showToastInView:UIApplication.sharedApplication.keyWindow text:@"图片已保存到相册"];
        }];
        
    });
}


/** CVPixelBufferRef covert to UIImage */
+ (UIImage *)imageFromCVPixelBufferRef0:(CVPixelBufferRef)pixelBuffer{
    // MUST READ-WRITE LOCK THE PIXEL BUFFER!!!!
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return uiImage;
}

+ (BOOL)checkMediaStatus:(NSString *)mediaType {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    BOOL res;
    
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            res = NO;
            break;
        case AVAuthorizationStatusAuthorized:
            res = YES;
            break;
    }
    return res;
}

#pragma mark - Util
+ (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone11,8"] || [platform isEqualToString:@"iPhone11,2"] || [platform isEqualToString:@"iPhone11,6"]) {
        return YES;
    }
    return NO;
}

+ (CGFloat)layoutWidthWithValue:(CGFloat)value {
    
    return (value / 750) * SCREEN_WIDTH;
}

+ (CGFloat)layoutHeightWithValue:(CGFloat)value {
    
    return (value / 1334) * SCREEN_HEIGHT;
}
@end
