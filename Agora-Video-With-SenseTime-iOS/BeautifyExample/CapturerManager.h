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
#import <AGMBase/AGMBase.h>
#import "CapturerManagerDelegate.h"
#import <AGMRenderer/AGMRenderer.h>
#import "EffectsCamera.h"
#import "EffectsProcess.h"
#import "EffectsGLPreview.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapturerManager : NSObject <AgoraVideoSourceProtocol, EffectsCameraDelegate>

//- (instancetype)initWithVideoConfig:(AGMCapturerVideoConfig *)config process:(EffectsProcess *)process;
- (void)startCapture;
- (void)stopCapture;
- (void)switchCamera;

@property (nonatomic, strong) EffectsGLPreview *effecgGLPreview;

@end

NS_ASSUME_NONNULL_END
