//
//  SenseRecordView.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseRecordView.h"
#import "STMovieRecorder.h"
#import "STAudioManager.h"
#import "SaveToastUtil.h"
#import "STParamUtil.h"
#import "STEffectsTimer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "STGLPreview.h"
#import "SenseTimeUtil.h"

typedef NS_ENUM(NSInteger, STWriterRecordingStatus){
    STWriterRecordingStatusIdle = 0,
    STWriterRecordingStatusStartingRecording,
    STWriterRecordingStatusRecording,
    STWriterRecordingStatusStoppingRecording
};

@interface SenseRecordView() <STAudioManagerDelegate, STMovieRecorderDelegate, STEffectsTimerDelegate>

@property (nonatomic, readwrite, strong) UIImageView *recordImageView;
@property (nonatomic, readwrite, strong) UILabel *recordTimeLabel;

//record
@property (nonatomic, readwrite, strong) STMovieRecorder *stRecoder;
@property (nonatomic, readwrite, strong) dispatch_queue_t callBackQueue;
@property (nonatomic, readwrite, assign, getter=isRecording) BOOL recording;
@property (nonatomic, readwrite, assign) STWriterRecordingStatus recordStatus;
@property (nonatomic, readwrite, strong) NSURL *recorderURL;
@property (nonatomic, readwrite, assign) CMFormatDescriptionRef outputVideoFormatDescription;
@property (nonatomic, readwrite, assign) CMFormatDescriptionRef outputAudioFormatDescription;
@property (nonatomic, readwrite, assign) double recordStartTime;
@property (nonatomic, readwrite, strong) STEffectsTimer *timer;

@property (nonatomic, strong) STAudioManager *audioManager;

@end


@implementation SenseRecordView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self initDeafultValue];
        [self setupTools];
        [self setupSubviews];
        [self startRecordCapture];
    }
    return self;
}

-(void)setupSubviews{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.recordImageView];
    [self addSubview:self.recordTimeLabel];
    
    self.userInteractionEnabled = NO;
}

// cancel recording when Interval greater than 10 seconds
- (BOOL)isOvertimeRecording {
    double current = CFAbsoluteTimeGetCurrent();
    return (self.recording && (current - self.recordStartTime) > 10);
}

- (void)captureOutputOriginalCVPixelBufferRef:(CVPixelBufferRef)originalPixelBuffer
                       resultCVPixelBufferRef:(CVPixelBufferRef)resultPixelBuffer
                                    timeStamp:(CMTime)timeStamp
{
    
    if ([self isOvertimeRecording]) {
        [self.timer stop];
        [self.timer reset];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopRecorder];
            if(self.senseRecordDelegate != nil) {
                [self.senseRecordDelegate onOvertimeRecording];
            }
        });
    }
    
    if (!self.outputVideoFormatDescription) {
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, originalPixelBuffer, &(_outputVideoFormatDescription));
    }
    
    if (self.recordStatus == STWriterRecordingStatusRecording) {
        [self.stRecoder appendVideoPixelBuffer:resultPixelBuffer withPresentationTime:timeStamp];
    }
}

- (void)captureOutputPixelBufferRef:(CVPixelBufferRef)pixelBuffer
                          timeStamp:(CMTime)timeStamp {
    [self captureOutputOriginalCVPixelBufferRef:pixelBuffer resultCVPixelBufferRef:pixelBuffer timeStamp:timeStamp];
}

- (void)captureOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer  originalCVPixelBufferRef:(CVPixelBufferRef)originalPixelBuffer resultCVPixelBufferRef:(CVPixelBufferRef)resultPixelBuffer {
    
    if ([self isOvertimeRecording]) {
        [self.timer stop];
        [self.timer reset];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopRecorder];
            if(self.senseRecordDelegate != nil) {
                [self.senseRecordDelegate onOvertimeRecording];
            }
        });
    }
    
    if (!self.outputVideoFormatDescription) {
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, originalPixelBuffer, &(_outputVideoFormatDescription));
    }
    
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (self.recordStatus == STWriterRecordingStatusRecording) {
        [self.stRecoder appendVideoPixelBuffer:resultPixelBuffer withPresentationTime:timestamp];
    }
}


#pragma mark - lazy load views
- (UILabel *)recordTimeLabel {
    
    if (!_recordTimeLabel) {
        
        _recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, SCREEN_HEIGHT - 100, 70, 35)];
        _recordTimeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _recordTimeLabel.layer.cornerRadius = 5;
        _recordTimeLabel.clipsToBounds = YES;
        _recordTimeLabel.font = [UIFont systemFontOfSize:11];
        _recordTimeLabel.textAlignment = NSTextAlignmentCenter;
        _recordTimeLabel.textColor = [UIColor whiteColor];
        _recordTimeLabel.text = @"• 00:00:00";
        _recordTimeLabel.hidden = YES;
    }
    
    return _recordTimeLabel;
}
- (UIImageView *)recordImageView {
    
    if (!_recordImageView) {
        
        UIImage *image = [UIImage imageNamed:@"record_video.png"];
        _recordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - image.size.width / 2, SCREEN_HEIGHT - 80 - image.size.height, image.size.width, image.size.height)];
        _recordImageView.image = image;
        _recordImageView.hidden = YES;
    }
    return _recordImageView;
}

#pragma record
- (void)initDeafultValue {
    self.recordStatus = STWriterRecordingStatusIdle;
    self.recording = NO;
    self.recorderURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"Movie.MOV"]]];
    
    self.outputAudioFormatDescription = nil;
    self.outputVideoFormatDescription = nil;
}

-(void)startRecordCapture {
    [self.audioManager startRunning];
}
-(void)stopRecordCapture {
    [self.audioManager stopRunning];
}

-(void)setupTools {
    self.audioManager = [[STAudioManager alloc] init];
    self.audioManager.delegate = self;
    
    self.timer = [[STEffectsTimer alloc] init];
    self.timer.delegate = self;
}

#pragma mark - STMovieRecorderDelegate
- (void)movieRecorder:(STMovieRecorder *)recorder didFailWithError:(NSError *)error {
    
    @synchronized (self) {
        
        self.stRecoder = nil;
        
        self.recordStatus = STWriterRecordingStatusIdle;
    }
    
    NSLog(@"movie recorder did fail with error: %@", error.localizedDescription);
}

- (void)movieRecorderDidFinishPreparing:(STMovieRecorder *)recorder {
    
    @synchronized(self) {
        if (_recordStatus != STWriterRecordingStatusStartingRecording) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Expected to be in StartingRecording state" userInfo:nil];
            return;
        }
        
        self.recordStatus = STWriterRecordingStatusRecording;
    }
}

- (void)movieRecorderDidFinishRecording:(STMovieRecorder *)recorder {
    
    @synchronized(self) {
        
        if (_recordStatus != STWriterRecordingStatusStoppingRecording) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Expected to be in StoppingRecording state" userInfo:nil];
            return;
        }
        
        self.recordStatus = STWriterRecordingStatusIdle;
    }
    
    _stRecoder = nil;
    
    self.recording = NO;
    
    double recordTime = CFAbsoluteTimeGetCurrent() - self.recordStartTime;
    //    NSLog(@"st_effects_recored_time end: %f", recordTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (recordTime < 2.0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"视频录制时间小于2s，请重新录制" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            
            [library writeVideoAtPathToSavedPhotosAlbum:_recorderURL completionBlock:^(NSURL *assetURL, NSError *error) {
                
                [[NSFileManager defaultManager] removeItemAtURL:_recorderURL error:NULL];
                [SaveToastUtil showToastInView:UIApplication.sharedApplication.keyWindow text:@"视频已存储到相册"];
            }];
        }
    });
}

- (void)startRecorder:(NSDictionary *)videoCompressingSettings {
    
    self.recordImageView.hidden = NO;
    self.recordTimeLabel.hidden = NO;

    [self.timer start];
        
    @synchronized (self) {
        
        if (self.recordStatus != STWriterRecordingStatusIdle) {
            
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Already recording" userInfo:nil];
            return;
        }
        
        self.recordStatus = STWriterRecordingStatusStartingRecording;
        
        _callBackQueue = dispatch_queue_create("com.sensetime.recordercallback", DISPATCH_QUEUE_SERIAL);
        
        STMovieRecorder *recorder = [[STMovieRecorder alloc] initWithURL:self.recorderURL delegate:self callbackQueue:_callBackQueue];
        
        if ([SenseTimeUtil checkMediaStatus:AVMediaTypeVideo]) {

            [recorder addVideoTrackWithSourceFormatDescription:self.outputVideoFormatDescription transform:CGAffineTransformIdentity settings:videoCompressingSettings];
        }

        if ([SenseTimeUtil checkMediaStatus:AVMediaTypeAudio]) {
            [recorder addAudioTrackWithSourceFormatDescription:self.outputAudioFormatDescription settings:self.audioManager.audioCompressingSettings];
        }
        
        _stRecoder = recorder;
        
        self.recording = YES;
        
        [_stRecoder prepareToRecord];
        
        self.recordStartTime = CFAbsoluteTimeGetCurrent();
    }
}

- (void)stopRecorder {
    
    self.recordImageView.hidden = YES;
    self.recordTimeLabel.hidden = YES;
    
    if (self.recording) {
        [self.timer stop];
        [self.timer reset];
        
        self.recording = NO;
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @synchronized (self) {
                
                if (self.recordStatus != STWriterRecordingStatusRecording) {
                    return;
                }
                
                self.recordStatus = STWriterRecordingStatusStoppingRecording;
                
                [self.stRecoder finishRecording];
            }
        });
    }
}

#pragma mark - STAudioManagerDelegate
- (void)audioCaptureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    self.outputAudioFormatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);

    @synchronized (self) {
        if (self.recordStatus == STWriterRecordingStatusRecording) {
            [self.stRecoder appendAudioSampleBuffer:sampleBuffer];
        }
    }
}

#pragma mark - STEffectsTimerDelegate
- (void)effectsTimer:(STEffectsTimer *)timer currentRecordHour:(int)hours minutes:(int)minutes seconds:(int)seconds {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordTimeLabel.text = [NSString stringWithFormat:@"• %02d:%02d:%02d", hours, minutes, seconds];
    });
}

- (void)releaseResources {
    [self stopRecorder];
    [self stopRecordCapture];
}
@end
