//
//  EFMovieRecorderManager.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, EFRecorderEvent) {
    EFRecorderEventBegin,
    EFRecorderEventFailed,
    EFRecorderEventInValid,
    EFRecorderEventFinish,
};

typedef void(^EFRecorderEventCallBack)(EFRecorderEvent event, NSURL *videoURL);

typedef NS_ENUM(NSInteger, EFWriterRecordingStatus){
    EFWriterRecordingStatusIdle = 0,
    EFWriterRecordingStatusStartingRecording,
    EFWriterRecordingStatusRecording,
    EFWriterRecordingStatusStoppingRecording
};

@interface EFMovieRecorderManager : NSObject

@property (nonatomic, assign, readonly) EFWriterRecordingStatus stateus;
@property (nonatomic, copy) EFRecorderEventCallBack recorderCallback;

- (void)startRecrodWithVideoSettings:(NSDictionary *)videoSettings
                       audioSettings:(NSDictionary *)audioSettings
              videoFormatDescription:(CMFormatDescriptionRef)videoFormat
              audioFormatDescription:(CMFormatDescriptionRef)audioFormat;

- (void)startRecrodWithVideoSettings:(NSDictionary *)videoSettings
                           transform:(CGAffineTransform)transform
              videoFormatDescription:(CMFormatDescriptionRef)videoFormat;

- (void)stopRecorder;

- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer timeStamp:(CMTime)timeStamp;

@end

NS_ASSUME_NONNULL_END
