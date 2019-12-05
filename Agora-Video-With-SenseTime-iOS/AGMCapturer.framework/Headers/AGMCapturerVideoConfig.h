//
//  AGMCapturerConfig.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/7.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/** Video pixel format.

 This enumeration defines the pixel format of the video frame. Agora supports three pixel formats on iOS: I420, BGRA, and NV12. For information on the YVU format, see:

   * [FourCC YUV Pixel Formats](http://www.fourcc.org/yuv.php)
   * [Recommended 8-Bit YUV Formats for Video Rendering](https://docs.microsoft.com/zh-cn/windows/desktop/medfound/recommended-8-bit-yuv-formats-for-video-rendering)
 */
typedef NS_ENUM(NSUInteger, AGMVideoPixelFormat) {
    /** I420 */
    AGMVideoPixelFormatI420   = 1,
    /** BGRA */
    AGMVideoPixelFormatBGRA   = 2,
    /** NV12 */
    AGMVideoPixelFormatNV12   = 8,
};

/** Video buffer type */
typedef NS_ENUM(NSInteger, AGMVideoBufferType) {
   /** Use a pixel buffer to transmit the video data. */
    AGMVideoBufferTypePixelBuffer = 1,
    /** Use raw data to transmit the video data. */
    AGMVideoBufferTypeRawData     = 2,
};

/** Video preview resolution(When the device does not support the current resolution, automatically lower the level.) */
typedef NS_ENUM (NSUInteger, AGMCaptureSessionPreset){
    /** low resolution */
    AGMCaptureSessionPreset480x640 = 0,
    /** medium resolution */
    AGMCaptureSessionPreset540x960 = 1,
    /** high resolution */
    AGMCaptureSessionPreset720x1280 = 2
};

@interface AGMCapturerVideoConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
+ (instancetype)defaultConfig
{
    AGMCapturerVideoConfig *config = [[AGMCapturerVideoConfig alloc] init];
    config.videoSize = CGSizeMake(540, 960);
    config.fps = 24;
    config.bitRate = 800*1000;
    config.outputBufferType = AGMVideoBufferTypePixelBuffer;
    config.outputPixelFormat = AGMVideoPixelFormatNV12;
    config.sessionPreset = AGMCaptureSessionPreset540x960;
    return config;
}
*/
+ (instancetype)defaultConfig;
// Video size
@property (nonatomic, assign) CGSize videoSize;
// Video frame per second
@property (nonatomic, assign) NSInteger fps;
// Video bit rate，unit（bps）
@property (nonatomic, assign) NSUInteger bitRate;
// Video output buffer type, only support AGMVideoBufferTypePixelBuffer
@property (nonatomic, assign) AGMVideoBufferType outputBufferType;
// Video output buffer format, AGMVideoPixelFormatI420 unsupport
@property (nonatomic, assign) AGMVideoPixelFormat outputPixelFormat;
// Video preview resolution
@property (nonatomic, assign) AGMCaptureSessionPreset sessionPreset;
@end

NS_ASSUME_NONNULL_END
