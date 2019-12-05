//
//  AGMCameraCapturer.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/7.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <AGMBase/AGMVideoSource.h>
#import "AGMCapturerVideoConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMCameraCapturer : AGMVideoSource

// The captureDevicePosition control cameraPosition ,default front
@property (nonatomic, assign) AVCaptureDevicePosition captureDevicePosition;
// Video preview resolution.
@property (nonatomic, assign) AGMCaptureSessionPreset sessionPreset;
// Specifies the recommended settings for use with an AVAssetWriterInput.
@property (nonatomic, strong, readonly) NSDictionary *videoCompressingSettings;


- (instancetype)initWithConfig:(AGMCapturerVideoConfig *)config;
// Start video pixelbuffer camera.
- (BOOL)start;
- (void)stop;
- (void)dispose;
#if TARGET_OS_IPHONE
/**
 Switches between front and rear cameras.
 */
-(void)switchCamera;
#endif

- (void)setExposurePoint:(CGPoint)point inPreviewFrame:(CGRect)frame;

- (void)setISOValue:(float)value;


@end

NS_ASSUME_NONNULL_END
