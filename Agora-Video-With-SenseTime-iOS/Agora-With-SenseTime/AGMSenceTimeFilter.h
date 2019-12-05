//
//  AGMSenceTimeFilter.h
//  ARSCapturerAndRenderer
//
//  Created by LSQ on 2019/11/25.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <AGMBase/AGMBase.h>
#import "SenseTimeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMSenceTimeFilter : AGMVideoSource <AGMVideoSink>

@property (nonatomic, strong) SenseTimeManager *senseTimeManager;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, assign) BOOL isVideoMirrored;

@property (nonatomic, copy) void (^didCompletion)(CVPixelBufferRef originalPixelBuffer, CVPixelBufferRef resultPixelBuffer, CMTime timeStamp);

@end

NS_ASSUME_NONNULL_END
