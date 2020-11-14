//
//  STCamera.h
//
//  Created by sluin on 16/5/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol STCameraDelegate <NSObject>

// call back in bufferQueue
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

@interface STCamera : NSObject

@property (nonatomic , assign) id <STCameraDelegate> delegate;

@property (nonatomic , readonly) dispatch_queue_t bufferQueue;

@property (nonatomic , assign) AVCaptureDevicePosition devicePosition; // default AVCaptureDevicePositionFront

@property (nonatomic , assign) AVCaptureVideoOrientation videoOrientation;

@property (nonatomic , assign) BOOL needVideoMirrored;

@property (nonatomic , strong , readonly) AVCaptureConnection *videoConnection;

@property (nonatomic , strong) AVCaptureVideoDataOutput * dataOutput;

@property (nonatomic , copy) NSString *sessionPreset;  // default 640x480

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic , assign) BOOL bSessionPause;

@property (nonatomic , assign) int iExpectedFPS;

@property (nonatomic, readwrite, strong) NSDictionary *videoCompressingSettings;


- (instancetype)initWithDevicePosition:(AVCaptureDevicePosition)iDevicePosition
                        sessionPresset:(AVCaptureSessionPreset)sessionPreset
                                   fps:(int)iFPS
                         needYuvOutput:(BOOL)needYuvOutput;

- (void)setExposurePoint:(CGPoint)point inPreviewFrame:(CGRect)frame;

- (void)setISOValue:(float)value;

- (void)startRunning;

- (void)stopRunning;

- (void)snapStillImageCompletionHandler:(void (^)(CMSampleBufferRef imageDataSampleBuffer, NSError *error))handler;

- (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)bScaleToFit;

@end
