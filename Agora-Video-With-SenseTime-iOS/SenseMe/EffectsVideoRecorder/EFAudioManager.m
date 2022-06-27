//
//  STAudioManager.m
//  SenseMeEffects
//
//  Created by Sunshine on 22/09/2017.
//  Copyright © 2017 SenseTime. All rights reserved.
//

#import "EFAudioManager.h"
#import <UIKit/UIKit.h>

@interface EFAudioManager () <AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;
@property (nonatomic, strong) AVCaptureSession *audioSession;
@property (nonatomic, strong) AVCaptureDevice *audioDevice;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioDataOutput;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

@end

@implementation EFAudioManager

- (void)dealloc {
    if (self.audioSession) {
        [self.audioSession beginConfiguration];
        [self.audioSession removeOutput:self.audioDataOutput];
        [self.audioSession removeInput:self.audioDeviceInput];
        [self.audioSession commitConfiguration];
        
        if (self.audioSession.isRunning) {
            [self.audioSession stopRunning];
        }
        self.audioSession = nil;
    }
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupCaptureSession];
    }
    return self;
}

- (void)setupCaptureSession {
    
    self.callbackQueue = dispatch_queue_create("com.sensetime.STAudioManager.callbackQueue", NULL);
    self.audioSession = [[AVCaptureSession alloc] init];
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSError *error = nil;
    self.audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:&error];
    if (error) {
        DLog(@"AVCaptureDeviceInput error: %@", error.localizedDescription);
    }
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:self.callbackQueue];
    
    [self.audioSession beginConfiguration];
    if ([self.audioSession canAddInput:self.audioDeviceInput]) {
        [self.audioSession addInput:self.audioDeviceInput];
    }
    
    if ([self.audioSession canAddOutput:self.audioDataOutput]) {
        [self.audioSession addOutput:self.audioDataOutput];
    }
    [self.audioSession commitConfiguration];
    
    self.audioConnection = [self.audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
    self.audioCompressingSettings = [[self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie] copy];
}

- (void)startRunning {
    if (![self judgeMicrophoneAuthorization]) {
        return;
    }
    
    if (!self.audioDataOutput) {
        return;
    }
    
    if (self.audioSession && ![self.audioSession isRunning]) {
        [self.audioSession startRunning];
    }
}


- (void)stopRunning {
    if (self.audioSession && [self.audioSession isRunning]) {
        [self.audioSession stopRunning];
    }
}


- (BOOL)judgeMicrophoneAuthorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if ([self.delegate respondsToSelector:@selector(audioCaptureOutput:didOutputSampleBuffer:fromConnection:)]) {
        
        [self.delegate audioCaptureOutput:output didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

@end




















