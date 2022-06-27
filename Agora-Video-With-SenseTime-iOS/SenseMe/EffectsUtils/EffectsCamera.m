//
//  STCamera.m
//
//  Created by sluin on 16/5/4.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "EffectsCamera.h"
#import <UIKit/UIKit.h>
#import "EFMachineVersion.h"

typedef NS_ENUM(NSUInteger, STExposureModel) {
    STExposureModelPositive5,
    STExposureModelPositive4,
    STExposureModelPositive3,
    STExposureModelPositive2,
    STExposureModelPositive1,
    STExposureModel0,
    STExposureModelNegative1,
    STExposureModelNegative2,
    STExposureModelNegative3,
    STExposureModelNegative4,
    STExposureModelNegative5,
    STExposureModelNegative6,
    STExposureModelNegative7,
    STExposureModelNegative8,
};

static char * kEffectsCamera = "EffectsCamera";

static STExposureModel currentExposureMode;

@interface EffectsCamera () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic , strong) AVCaptureDeviceInput * deviceInput;
@property (nonatomic , strong) AVCaptureVideoDataOutput * dataOutput;
@property (nonatomic , strong) AVCaptureMetadataOutput *metaOutput;
@property (nonatomic , strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic , readwrite) dispatch_queue_t bufferQueue;

@property (nonatomic , strong , readwrite) AVCaptureConnection *videoConnection;

@property (nonatomic , strong) AVCaptureDevice *videoDevice;
@property (nonatomic , strong) AVCaptureSession *session;


@end

@implementation EffectsCamera
{
    float _autoISOValue;
}

- (instancetype)initWithDevicePosition:(AVCaptureDevicePosition)iDevicePosition
                        sessionPresset:(AVCaptureSessionPreset)sessionPreset
                                   fps:(int)iFPS
                         needYuvOutput:(BOOL)needYuvOutput
{
    self = [super init];
    if (self) {
        
        self.bSessionPause = YES;
        
        self.bufferQueue = dispatch_queue_create("STCameraBufferQueue", NULL);
        self.session = [[AVCaptureSession alloc] init];
        
        self.videoDevice = [self cameraDeviceWithPosition:iDevicePosition];
        _devicePosition = iDevicePosition;
        NSError *error = nil;
        self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice
                                                                 error:&error];
        
        if (!self.deviceInput || error) {

            NSLog(@"create input error");

            return nil;
        }
        
        
        self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.dataOutput setAlwaysDiscardsLateVideoFrames:YES];
        self.dataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(needYuvOutput ? kCVPixelFormatType_420YpCbCr8BiPlanarFullRange : kCVPixelFormatType_32BGRA)};
        self.dataOutput.alwaysDiscardsLateVideoFrames = YES;
        [self.dataOutput setSampleBufferDelegate:self queue:self.bufferQueue];
        self.metaOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.metaOutput setMetadataObjectsDelegate:self queue:self.bufferQueue];
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        self.stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
        if ([self.stillImageOutput respondsToSelector:@selector(setHighResolutionStillImageOutputEnabled:)]) {

            self.stillImageOutput.highResolutionStillImageOutputEnabled = YES;
        }
        
        
        [self.session beginConfiguration];
        
        if ([self.session canAddInput:self.deviceInput]) {
            [self.session addInput:self.deviceInput];
        }else{
            NSLog( @"Could not add device input to the session" );
            return nil;
        }
        
        if ([self.session canSetSessionPreset:sessionPreset]) {
            [self.session setSessionPreset:sessionPreset];
            _sessionPreset = sessionPreset;
        }else if([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]){
            [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
            _sessionPreset = AVCaptureSessionPreset1280x720;
        }else{
            [self.session setSessionPreset:AVCaptureSessionPreset640x480];
            _sessionPreset = AVCaptureSessionPreset640x480;
        }
        
        if ([self.session canAddOutput:self.dataOutput]) {
            
            [self.session addOutput:self.dataOutput];
        }else{
            
            NSLog( @"Could not add video data output to the session" );
            return nil;
        }
        
        if ([self.session canAddOutput:self.metaOutput]) {
            [self.session addOutput:self.metaOutput];
            self.metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace].copy;
        }
        
        if ([self.session canAddOutput:self.stillImageOutput]) {

            [self.session addOutput:self.stillImageOutput];
        }else {

            NSLog(@"Could not add still image output to the session");
        }
        
        self.videoConnection =  [self.dataOutput connectionWithMediaType:AVMediaTypeVideo];
        
        
        if ([self.videoConnection isVideoOrientationSupported]) {
            
            [self.videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            self.videoOrientation = AVCaptureVideoOrientationPortrait;
        }
        
        
        if ([self.videoConnection isVideoMirroringSupported]) {
            
            [self.videoConnection setVideoMirrored:YES];
            self.needVideoMirrored = YES;
        }
        
        if ([_videoDevice lockForConfiguration:NULL] == YES) {
//            _videoDevice.activeFormat = bestFormat;
            _videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, iFPS);
            _videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, iFPS);
            [_videoDevice unlockForConfiguration];
        }
        
        
        [self.session commitConfiguration];
        
        NSMutableDictionary *tmpSettings = [[self.dataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie] mutableCopy];
        if (!EFMachineVersion.isiPhone5sOrLater) {
            NSNumber *tmpSettingValue = tmpSettings[AVVideoHeightKey];
            tmpSettings[AVVideoHeightKey] = tmpSettings[AVVideoWidthKey];
            tmpSettings[AVVideoWidthKey] = tmpSettingValue;
        }
        self.videoCompressingSettings = [tmpSettings copy];
        
        self.iExpectedFPS = iFPS;
    }
    
    return self;
}



- (void)dealloc
{
    if (self.session) {
        
        self.bSessionPause = YES;
        
        [self.session beginConfiguration];
        
        [self.session removeOutput:self.dataOutput];
        [self.session removeInput:self.deviceInput];
        
        [self.session commitConfiguration];
        
        if ([self.session isRunning]) {
            
            [self.session stopRunning];
        }
        
        self.session = nil;
    }
}

- (void)setExposurePoint:(CGPoint)point inPreviewFrame:(CGRect)frame {
    
    BOOL isFrontCamera = self.devicePosition == AVCaptureDevicePositionFront;
    float fX = point.y / frame.size.height;
    float fY = isFrontCamera ? point.x / frame.size.width : (1 - point.x / frame.size.width);
    
    [self focusWithMode:self.videoDevice.focusMode exposureMode:self.videoDevice.exposureMode atPoint:CGPointMake(fX, fY)];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    NSError *error = nil;
    AVCaptureDevice * device = self.videoDevice;
    
    if ( [device lockForConfiguration:&error] ) {
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
//        - (void)setISOValue:(float)value{
        [self setISOValue:0];
//device.exposureTargetBias
        // Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation
        // Call -set(Focus/Exposure)Mode: to apply the new point of interest
        if ( focusMode != AVCaptureFocusModeLocked && device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
            device.focusPointOfInterest = point;
            device.focusMode = focusMode;
        }
        
        if ( exposureMode != AVCaptureExposureModeCustom && device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
            device.exposurePointOfInterest = point;
            device.exposureMode = exposureMode;
        }
        
        device.subjectAreaChangeMonitoringEnabled = YES;
        [device unlockForConfiguration];
        
        
    }
}

- (void)setWhiteBalance{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
    }];
}

- (void)changeDeviceProperty:(void(^)(AVCaptureDevice *))propertyChange{
    AVCaptureDevice *captureDevice= self.videoDevice;
    NSError *error;
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)setISOValue:(float)value exposeDuration:(int)duration{
    float currentISO = (value < self.videoDevice.activeFormat.minISO) ? self.videoDevice.activeFormat.minISO: value;
    currentISO = value > self.videoDevice.activeFormat.maxISO ? self.videoDevice.activeFormat.maxISO : value;
    NSError *error;
    if ([self.videoDevice lockForConfiguration:&error]){
        [self.videoDevice setExposureModeCustomWithDuration:AVCaptureExposureDurationCurrent ISO:currentISO completionHandler:nil];
        [self.videoDevice unlockForConfiguration];
    }
}

- (void)setISOValue:(float)value{
//    float newVlaue = (value - 0.5) * (5.0 / 0.5); // mirror [0,1] to [-8,8]
    DLog(@"%f", value);
    NSError *error = nil;
    if ( [self.videoDevice lockForConfiguration:&error] ) {
        [self.videoDevice setExposureTargetBias:value completionHandler:nil];
        [self.videoDevice unlockForConfiguration];
    }
    else {
        NSLog( @"Could not lock device for configuration: %@", error );
    }
}

- (void)setDevicePosition:(AVCaptureDevicePosition)devicePosition
{
    if (_devicePosition != devicePosition && devicePosition != AVCaptureDevicePositionUnspecified) {
        
        if (_session) {
            
            AVCaptureDevice *targetDevice = [self cameraDeviceWithPosition:devicePosition];
            
            if (targetDevice && [self judgeCameraAuthorization]) {
                
                NSError *error = nil;
                AVCaptureDeviceInput *deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:targetDevice error:&error];
                
                if(!deviceInput || error) {
                    
                    NSLog(@"Error creating capture device input: %@", error.localizedDescription);
                    return;
                }
                
                _bSessionPause = YES;
                
                [_session beginConfiguration];
                
                [_session removeInput:_deviceInput];
                
                if ([_session canAddInput:deviceInput]) {
                    
                    [_session addInput:deviceInput];
                    
                    _deviceInput = deviceInput;
                    _videoDevice = targetDevice;
                    
                    _devicePosition = devicePosition;
                }
                
                _videoConnection =  [_dataOutput connectionWithMediaType:AVMediaTypeVideo];
                
                if ([_videoConnection isVideoOrientationSupported]) {
                    
                    [_videoConnection setVideoOrientation:_videoOrientation];
                }
                
                if ([_videoConnection isVideoMirroringSupported]) {
                    
                    [_videoConnection setVideoMirrored:devicePosition == AVCaptureDevicePositionFront];
                }
                
                [_session commitConfiguration];
                
                [self setSessionPreset:_sessionPreset];
                
                _bSessionPause = NO;
            }
        }
    }
}

- (void)setSessionPreset:(NSString *)sessionPreset
{
    if (_session && _sessionPreset) {
        
//        if (![sessionPreset isEqualToString:_sessionPreset]) {
        
        _bSessionPause = YES;
        
        [_session beginConfiguration];
        
        if ([_session canSetSessionPreset:sessionPreset]) {
            
            [_session setSessionPreset:sessionPreset];
            
            _sessionPreset = sessionPreset;
        }
        
        
        [_session commitConfiguration];
        
        self.videoCompressingSettings = [[self.dataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeQuickTimeMovie] copy];
        
//        [self setIExpectedFPS:_iExpectedFPS];
        
        _bSessionPause = NO;
//        }
    }
}

- (void)setIExpectedFPS:(int)iExpectedFPS
{
    _iExpectedFPS = iExpectedFPS;
    
    if (iExpectedFPS <= 0 || !_dataOutput.videoSettings || !_videoDevice) {
        
        return;
    }
    
    CGFloat fWidth = [[_dataOutput.videoSettings objectForKey:@"Width"] floatValue];
    CGFloat fHeight = [[_dataOutput.videoSettings objectForKey:@"Height"] floatValue];
    
    AVCaptureDeviceFormat *bestFormat = nil;
    AVFrameRateRange *bestFrameRateRange = nil;
    
    for (AVCaptureDeviceFormat *format in [_videoDevice formats]) {
        
        CMFormatDescriptionRef description = format.formatDescription;
        
        if (CMFormatDescriptionGetMediaSubType(description) != kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
            
            continue;
        }
        
        CMVideoDimensions videoDimension = CMVideoFormatDescriptionGetDimensions(description);
        if ((videoDimension.width == fWidth && videoDimension.height == fHeight)
            ||
            (videoDimension.height == fWidth && videoDimension.width == fHeight)) {
            
            for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges) {
                
                if (range.maxFrameRate >= bestFrameRateRange.maxFrameRate) {
                    bestFormat = format;
                    bestFrameRateRange = range;
                }
            }
        }
    }
    
    if (bestFormat) {
        
        CMTime minFrameDuration;
        
        if (bestFrameRateRange.minFrameDuration.timescale / bestFrameRateRange.minFrameDuration.value < iExpectedFPS) {
            
            minFrameDuration = bestFrameRateRange.minFrameDuration;
        }else{
            
            minFrameDuration = CMTimeMake(1, iExpectedFPS);
        }
        
//        if ([_videoDevice lockForConfiguration:NULL] == YES) {
//            _videoDevice.activeFormat = bestFormat;
//            _videoDevice.activeVideoMinFrameDuration = minFrameDuration;
//            _videoDevice.activeVideoMaxFrameDuration = minFrameDuration;
//            [_videoDevice unlockForConfiguration];
//        }
    }
}

- (void)startRunning
{
    if (![self judgeCameraAuthorization]) {
        
        return;
    }
    
    if (!self.dataOutput) {

        return;
    }
    
    if (self.session && ![self.session isRunning]) {
        
        [self.session startRunning];
        self.bSessionPause = NO;
    }
}


- (void)stopRunning
{
    if (self.session && [self.session isRunning]) {
        
        [self.session stopRunning];
        self.bSessionPause = YES;
    }
}

- (CGRect)getZoomedRectWithRect:(CGRect)rect scaleToFit:(BOOL)bScaleToFit
{
    CGRect rectRet = rect;
    
    if (self.dataOutput.videoSettings) {
        
        CGFloat fWidth = [[self.dataOutput.videoSettings objectForKey:@"Width"] floatValue];
        CGFloat fHeight = [[self.dataOutput.videoSettings objectForKey:@"Height"] floatValue];
        
        float fScaleX = fWidth / CGRectGetWidth(rect);
        float fScaleY = fHeight / CGRectGetHeight(rect);
        float fScale = bScaleToFit ? fmaxf(fScaleX, fScaleY) : fminf(fScaleX, fScaleY);
        
        fWidth /= fScale;
        fHeight /= fScale;
        
        CGFloat fX = rect.origin.x - (fWidth - rect.size.width) / 2.0f;
        CGFloat fY = rect.origin.y - (fHeight - rect.size.height) / 2.0f;
        
        rectRet = CGRectMake(fX, fY, fWidth, fHeight);
    }
    
    return rectRet;
}

- (BOOL)judgeCameraAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    
    return YES;
}

- (AVCaptureDevice *)cameraDeviceWithPosition:(AVCaptureDevicePosition)position
{
    AVCaptureDevice *deviceRet = nil;
    
    if (position != AVCaptureDevicePositionUnspecified) {
        
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        for (AVCaptureDevice *device in devices) {
            
            if ([device position] == position) {
                
                deviceRet = device;
            }
        }
    }
    
    return deviceRet;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    
    return _previewLayer;
}

- (void)snapStillImageCompletionHandler:(void (^)(CMSampleBufferRef imageDataSampleBuffer, NSError *error))handler
{
    if ([self judgeCameraAuthorization]) {
        self.bSessionPause = YES;
        
        NSString *strSessionPreset = [self.sessionPreset mutableCopy];
        self.sessionPreset = AVCaptureSessionPresetPhoto;
        
        // 改变preset会黑一下
        [NSThread sleepForTimeInterval:0.3];
        
        dispatch_async(self.bufferQueue, ^{
            
            [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                
                self.bSessionPause = NO;
                self.sessionPreset = strSessionPreset;
                handler(imageDataSampleBuffer , error);
            }];
        } );
    }
}
BOOL updateExporureModel(STExposureModel model){
    if (currentExposureMode == model) return NO;
    currentExposureMode = model;
    return YES;
}

- (void)test:(AVCaptureExposureMode)model{
    if ([self.videoDevice lockForConfiguration:nil]) {
        if ([self.videoDevice  isExposureModeSupported:model]) {
            [self.videoDevice setExposureMode:model];
        }
        [self.videoDevice unlockForConfiguration];
    }
}

- (void)setExposureTime:(CMTime)time{
    if ([self.videoDevice lockForConfiguration:nil]) {
        if (@available(iOS 12.0, *)) {
            self.videoDevice.activeMaxExposureDuration = time;
        } else {
            // Fallback on earlier versions
        }
        [self.videoDevice unlockForConfiguration];
    }
}
- (void)setFPS:(float)fps{
    if ([_videoDevice lockForConfiguration:NULL] == YES) {
//            _videoDevice.activeFormat = bestFormat;
        _videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, fps);
        _videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, fps);
        [_videoDevice unlockForConfiguration];
    }
}

- (void)updateExposure:(CMSampleBufferRef)sampleBuffer{
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary * metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary *)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if(brightnessValue > 2 && updateExporureModel(STExposureModelPositive2)){
        [self setISOValue:500 exposeDuration:30];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
        [self setFPS:30];
    }else if(brightnessValue > 1 && brightnessValue < 2 && updateExporureModel(STExposureModelPositive1)){
        [self setISOValue:500 exposeDuration:30];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
        [self setFPS:30];
    }else if(brightnessValue > 0 && brightnessValue < 1 && updateExporureModel(STExposureModel0)){
        [self setISOValue:500 exposeDuration:30];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
        [self setFPS:30];
    }else if (brightnessValue > -1 && brightnessValue < 0 && updateExporureModel(STExposureModelNegative1)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:40];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -2 && brightnessValue < -1 && updateExporureModel(STExposureModelNegative2)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:35];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -2.5 && brightnessValue < -2 && updateExporureModel(STExposureModelNegative3)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:30];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -3 && brightnessValue < -2.5 && updateExporureModel(STExposureModelNegative4)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:25];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -3.5 && brightnessValue < -3 && updateExporureModel(STExposureModelNegative5)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:20];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -4 && brightnessValue < -3.5 && updateExporureModel(STExposureModelNegative6)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 250 exposeDuration:15];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if (brightnessValue > -5 && brightnessValue < -4 && updateExporureModel(STExposureModelNegative7)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 200 exposeDuration:10];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }else if(brightnessValue < -5 && updateExporureModel(STExposureModelNegative8)){
        [self setISOValue:self.videoDevice.activeFormat.maxISO - 150 exposeDuration:5];
        [self test:AVCaptureExposureModeContinuousAutoExposure];
    }

//    NSLog(@"current brightness %f min iso %f max iso %f min exposure %f max exposure %f", brightnessValue, self.videoDevice.activeFormat.minISO, self.videoDevice.activeFormat.maxISO, CMTimeGetSeconds(self.videoDevice.activeFormat.minExposureDuration),   CMTimeGetSeconds(self.videoDevice.activeFormat.maxExposureDuration));
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!self.bSessionPause) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {
            //[connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
            [self.delegate captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
        }
    }
    [self updateExposure:sampleBuffer];
}


- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    AVMetadataFaceObject *faceObject = nil;
    for(AVMetadataObject *object  in metadataObjects){
        if (AVMetadataObjectTypeFace == object.type) {
            faceObject = (AVMetadataFaceObject*)object;
        }
    }
    static BOOL hasFace = NO;
    if (!hasFace && faceObject.faceID) {
        hasFace = YES;
    }
    if (!faceObject.faceID) {
        hasFace = NO;
    }
}
@end
