//
//  CapturerManager.h
//  BeautifyExample
//
//  Created by zhaoyongqiang on 2022/6/22.
//  Copyright © 2022 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <AGMCapturer/AGMCapturer.h>
#import <AGMRenderer/AGMRenderer.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CapturerManagerDelegate <NSObject>

- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)pixelBuffer;

@end


@interface CapturerManager : NSObject <AgoraVideoSourceProtocol, AGMVideoCameraDelegate>

- (instancetype)initWithVideoConfig:(AGMCapturerVideoConfig *)config delegate:(id <CapturerManagerDelegate>)delegate;

- (void)startCapture;
- (void)stopCapture;
- (void)switchCamera;

@property (nonatomic, strong) AGMEAGLVideoView *videoView;

@end

NS_ASSUME_NONNULL_END
