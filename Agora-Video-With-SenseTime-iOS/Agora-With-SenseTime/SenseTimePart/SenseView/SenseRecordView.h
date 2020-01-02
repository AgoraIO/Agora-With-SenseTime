//
//  SenseRecordView.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

@protocol SenseRecordDelegate <NSObject>
- (void)onOvertimeRecording;
@end

@interface SenseRecordView : UIView

@property (nonatomic, weak) id<SenseRecordDelegate> senseRecordDelegate;

- (void)startRecorder:(NSDictionary *)videoCompressingSettings;
- (void)stopRecorder;

- (void)startRecordCapture;
- (void)stopRecordCapture;

- (void)releaseResources;

- (void)captureOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer  originalCVPixelBufferRef:(CVPixelBufferRef)originalPixelBuffer resultCVPixelBufferRef:(CVPixelBufferRef)resultPixelBuffer;

- (void)captureOutputOriginalCVPixelBufferRef:(CVPixelBufferRef)originalPixelBuffer
                       resultCVPixelBufferRef:(CVPixelBufferRef)resultPixelBuffer
                                    timeStamp:(CMTime)timeStamp;

- (void)captureOutputPixelBufferRef:(CVPixelBufferRef)pixelBuffer
             timeStamp:(CMTime)timeStamp;

// cancel recording when Interval greater than 10 seconds
- (BOOL)isOvertimeRecording;

@end

