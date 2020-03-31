//
//  AGMSenceTimeFilter.m
//  AGMCapturerAndRenderer
//
//  Created by LSQ on 2019/11/25.
//  Copyright © 2019 Agora. All rights reserved.
//

#import "AGMSenceTimeFilter.h"

@implementation AGMSenceTimeFilter

- (void)onTextureFrame:(AGMImageFramebuffer *)textureFrame frameTime:(CMTime)time {
    
    //获取每一帧图像信息
     CVPixelBufferRef originalPixelBuffer = textureFrame.pixelBuffer;
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
         self.didCompletion(originalPixelBuffer, pixelBufferRefResult, time);
     }
     
     CVPixelBufferUnlockBaseAddress(originalPixelBuffer, 0);
}

@end
