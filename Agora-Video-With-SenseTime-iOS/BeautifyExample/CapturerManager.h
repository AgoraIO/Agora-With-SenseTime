//
//  CapturerManager.h
//  BeautifyExample
//
//  Created by zhaoyongqiang on 2022/6/22.
//  Copyright © 2022 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "EffectsCamera.h"
#import "EffectsProcess.h"
#import "EffectsGLPreview.h"

NS_ASSUME_NONNULL_BEGIN

@interface CapturerManager : NSObject <AgoraVideoSourceProtocol, EffectsCameraDelegate>

- (void)startCapture;
- (void)stopCapture;
- (void)switchCamera;

@property (nonatomic, strong) EffectsGLPreview *effecgGLPreview;

@end

NS_ASSUME_NONNULL_END
