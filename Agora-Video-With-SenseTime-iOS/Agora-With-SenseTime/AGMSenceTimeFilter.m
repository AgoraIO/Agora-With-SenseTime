//
//  AGMSenceTimeFilter.m
//  AGMCapturerAndRenderer
//
//  Created by LSQ on 2019/11/25.
//  Copyright © 2019 Agora. All rights reserved.
//

#import "AGMSenceTimeFilter.h"

@implementation AGMSenceTimeFilter

- (void)onFrame:(AGMVideoFrame *)videoFrame
{
#pragma mark 写入滤镜处理
    
    AGMCVPixelBuffer *AGMPixelBuffer = videoFrame.buffer;
    
    //获取每一帧图像信息
    CVPixelBufferRef originalPixelBuffer = AGMPixelBuffer.pixelBuffer;
    CVPixelBufferLockBaseAddress(originalPixelBuffer, 0);

    GLuint textureResult = 0;
    CVPixelBufferRef pixelBufferRefResult = originalPixelBuffer;

    SenseTimeModel model;
    model.devicePosition = self.devicePosition;
    model.isVideoMirrored = self.isVideoMirrored;
    model.pixelBuffer = originalPixelBuffer;
    model.textureResult = &textureResult;
    pixelBufferRefResult = [self.senseTimeManager captureOutputWithSenseTimeModel:model];

    
    if (self.didCompletion) {
        self.didCompletion(originalPixelBuffer, pixelBufferRefResult, videoFrame.timeStamp);
    }
    
    CVPixelBufferUnlockBaseAddress(originalPixelBuffer, 0);


    CMTime timeStamp = videoFrame.timeStamp;

    AGMCVPixelBuffer *aPixelBuffer = [[AGMCVPixelBuffer alloc] initWithPixelBuffer:pixelBufferRefResult];
    AGMVideoFrame *aVideoFrame = [[AGMVideoFrame alloc] initWithBuffer:aPixelBuffer
                                                             rotation:videoFrame.rotation
                                                             timeStamp:timeStamp];
    aVideoFrame.usingFrontCamera = videoFrame.usingFrontCamera;
    aVideoFrame.videoSize = videoFrame.videoSize;

    
    if (self.allSinks.count) {
        for (id<AGMVideoSink> sink in self.allSinks) {
            [sink onFrame:aVideoFrame];
        }
    }

}

@end
