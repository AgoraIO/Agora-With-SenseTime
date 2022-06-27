//
//  EFMovieRecorderManager.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMovieRecorderManager.h"
#import "EFMovieRecorder.h"

@interface EFMovieRecorderManager ()<EFMovieRecorderDelegate>
@property (nonatomic, strong) EFMovieRecorder *videoRecorder;
@property (nonatomic, strong) dispatch_queue_t recorderQueue;
@property (nonatomic, strong) dispatch_semaphore_t recorderLock;
@property (nonatomic, assign) EFWriterRecordingStatus stateus;
@property (nonatomic, strong) NSURL *recorderURL;
@end

@implementation EFMovieRecorderManager


#pragma mark - public record video and audio
- (void)startRecrodWithVideoSettings:(NSDictionary *)videoSettings
                       audioSettings:(NSDictionary *)audioSettings
              videoFormatDescription:(CMFormatDescriptionRef)videoFormat
              audioFormatDescription:(CMFormatDescriptionRef)audioFormat{
    if(self.stateus != EFWriterRecordingStatusIdle) return;
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    self.videoRecorder = [[EFMovieRecorder alloc] initWithURL:self.recorderURL
                                                     delegate:self
                                                callbackQueue:self.recorderQueue];
    [self.videoRecorder addVideoTrackWithSourceFormatDescription:videoFormat
                                                       transform:CGAffineTransformIdentity
                                                        settings:videoSettings];
    [self.videoRecorder addAudioTrackWithSourceFormatDescription:audioFormat
                                                        settings:audioSettings];
    self.stateus = EFWriterRecordingStatusStartingRecording;
    [self.videoRecorder prepareToRecord];
    dispatch_semaphore_signal(self.recorderLock);
    if (self.recorderCallback) {
        self.recorderCallback(EFRecorderEventBegin, nil);
    }
}

- (void)startRecrodWithVideoSettings:(NSDictionary *)videoSettings
                           transform:(CGAffineTransform)transform
              videoFormatDescription:(CMFormatDescriptionRef)videoFormat{
    if(self.stateus != EFWriterRecordingStatusIdle) return;
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    self.videoRecorder = [[EFMovieRecorder alloc] initWithURL:self.recorderURL
                                                     delegate:self
                                                callbackQueue:self.recorderQueue];
    [self.videoRecorder addVideoTrackWithSourceFormatDescription:videoFormat
                                                       transform:CGAffineTransformIdentity
                                                        settings:videoSettings];
    self.stateus = EFWriterRecordingStatusStartingRecording;
    [self.videoRecorder prepareToRecord];
    dispatch_semaphore_signal(self.recorderLock);
    if (self.recorderCallback) {
        self.recorderCallback(EFRecorderEventBegin, nil);
    }
}


- (void)stopRecorder {
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    if (self.stateus != EFWriterRecordingStatusRecording) {
        dispatch_semaphore_signal(self.recorderLock);
        return;
    }
    self.stateus = EFWriterRecordingStatusStoppingRecording;
    [self.videoRecorder finishRecording];
    dispatch_semaphore_signal(self.recorderLock);
}

- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    if (self.stateus != EFWriterRecordingStatusRecording) {
        return;
    }
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    [self.videoRecorder appendAudioSampleBuffer:sampleBuffer];
    dispatch_semaphore_signal(self.recorderLock);
}

- (void)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer timeStamp:(CMTime)timeStamp{
    if (self.stateus != EFWriterRecordingStatusRecording) {
        return;
    }
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    [self.videoRecorder appendVideoPixelBuffer:pixelBuffer
                          withPresentationTime:timeStamp];
    dispatch_semaphore_signal(self.recorderLock);
}

#pragma mark - setter/getter
- (NSURL *)recorderURL{
    if (!_recorderURL) {
        NSString *saveVideoPath = [NSString pathWithComponents:@[NSTemporaryDirectory(), @"Movie.MOV"]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:saveVideoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:saveVideoPath error:nil];
        }
        _recorderURL = [[NSURL alloc] initFileURLWithPath:saveVideoPath];
    }
    return _recorderURL;
}

- (dispatch_queue_t)recorderQueue{
    if (!_recorderQueue) {
        _recorderQueue = dispatch_queue_create("com.videoRecoreder.queue", DISPATCH_QUEUE_SERIAL);
    }
    return _recorderQueue;
}

- (dispatch_semaphore_t)recorderLock{
    if (!_recorderLock) {
        _recorderLock = dispatch_semaphore_create(1);
    }
    return _recorderLock;
}

#pragma mark - EFMovieRecorderDelegate

- (void)movieRecorder:(EFMovieRecorder *)recorder
     didFailWithError:(NSError *)error {
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    self.videoRecorder = nil;
    self.stateus = EFWriterRecordingStatusIdle;
    dispatch_semaphore_signal(self.recorderLock);
    if (self.recorderCallback) {
        self.recorderCallback(EFRecorderEventBegin, nil);
    }
}

- (void)movieRecorderDidFinishPreparing:(EFMovieRecorder *)recorder {
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    if (self.stateus != EFWriterRecordingStatusStartingRecording) {
        dispatch_semaphore_signal(self.recorderLock);
        return;
    }
    self.stateus = EFWriterRecordingStatusRecording;
    dispatch_semaphore_signal(self.recorderLock);
}

- (void)movieRecorderDidFinishRecording:(EFMovieRecorder *)recorder {
    dispatch_semaphore_wait(self.recorderLock, DISPATCH_TIME_FOREVER);
    if (self.stateus != EFWriterRecordingStatusStoppingRecording) {
        dispatch_semaphore_signal(self.recorderLock);
        return;
    }
    self.stateus = EFWriterRecordingStatusIdle;
    self.videoRecorder = nil;
    dispatch_semaphore_signal(self.recorderLock);
    if (self.recorderCallback) {
        self.recorderCallback(EFRecorderEventFinish, self.recorderURL);
    }
}

@end
