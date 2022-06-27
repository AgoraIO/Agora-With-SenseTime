//
//  CapturerManager.m
//  BeautifyExample
//
//  Created by LSQ on 2020/8/3.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "CapturerManager.h"
#import "EFMotionManager.h"

#define CM_DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

@interface CapturerManager ()
{
    CVOpenGLESTextureCacheRef _cvTextureCache;
    
    @public
    GLuint _outTexture;
    CVPixelBufferRef _outputPixelBuffer;
    CVOpenGLESTextureRef _outputCVTexture;
    BOOL _isFirstLaunch;
}

@property (nonatomic, strong) EffectsCamera *camera;
@property (nonatomic, strong) EffectsProcess *effectsProcess;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic) dispatch_queue_t renderQueue;
///贴纸id
@property (nonatomic, assign) int stickerId;

@end

@implementation CapturerManager
@synthesize consumer;

- (void)initCapturer {
    self.renderQueue = dispatch_queue_create("com.render.queue", DISPATCH_QUEUE_SERIAL);
    
    self.camera = [[EffectsCamera alloc] initWithDevicePosition:AVCaptureDevicePositionFront sessionPresset:AVCaptureSessionPreset1280x720 fps:30 needYuvOutput:YES];
    self.camera.delegate = self;
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    self.effectsProcess = [[EffectsProcess alloc] initWithType:EffectsTypeVideo glContext:self.glContext];
    //effects
    dispatch_async(self.renderQueue, ^{
        [self.effectsProcess setModelPath:[[NSBundle mainBundle] pathForResource:@"model" ofType:@"bundle"]];
        [EAGLContext setCurrentContext:self.glContext];
        self.effectsProcess.detectConfig = ST_MOBILE_FACE_DETECT;
        [self.effectsProcess setBeautyParam:EFFECT_BEAUTY_PARAM_ENABLE_WHITEN_SKIN_MASK andVal:1.0];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_RESHAPE_SHRINK_FACE value:1.0];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_BASE_WHITTEN value:1.0];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_RESHAPE_ENLARGE_EYE value:1.0];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_RESHAPE_ROUND_EYE value:1.0];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_PLASTIC_OPEN_CANTHUS value:1.0];
    });
}

#pragma mark Public
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initCapturer];
    }
    return self;
}

- (void)startCapture {
    [self.camera startRunning];
}

- (void)stopCapture {
    [self.camera stopRunning];
}

- (void)switchCamera {
    if (self.camera.devicePosition == AVCaptureDevicePositionBack) {
        self.camera.devicePosition = AVCaptureDevicePositionFront;
    }else {
        self.camera.devicePosition = AVCaptureDevicePositionBack;
    }
}

#pragma mark - AgoraVideoSourceProtocol
- (AgoraVideoBufferType)bufferType {
    return AgoraVideoBufferTypePixelBuffer;
}

- (void)shouldDispose {
    
}

- (BOOL)shouldInitialize {
    return YES;
}

- (void)shouldStart {
    
}

- (void)shouldStop {
    
}


- (AgoraVideoCaptureType)captureType {
    return AgoraVideoCaptureTypeCamera;
}

- (AgoraVideoContentHint)contentHint {
    return AgoraVideoContentHintNone;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!pixelBuffer) return;
    CMTime timeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if (!self.effectsProcess) {
        return;
    }
    // 设置 OpenGL 环境 , 需要与初始化 SDK 时一致
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int heigh = (int)CVPixelBufferGetHeight(pixelBuffer);
    if(!_outTexture){
        [self.effectsProcess createGLObjectWith:width
                                         height:heigh
                                        texture:&_outTexture
                                    pixelBuffer:&_outputPixelBuffer
                                      cvTexture:&_outputCVTexture];
    }
        
    st_mobile_human_action_t detectResult;
    memset(&detectResult, 0, sizeof(st_mobile_human_action_t));
    st_result_t ret = [self.effectsProcess detectWithPixelBuffer:pixelBuffer
                                                          rotate:[self getRotateType]
                                                  cameraPosition:self.camera.devicePosition
                                                     humanAction:&detectResult
                                                    animalResult:nil
                                                     animalCount:nil];
    if (ret != ST_OK) {
        DLog(@"人脸检测失败")
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        return;
    }

    [self.effectsProcess renderPixelBuffer:pixelBuffer
                                    rotate:[self getRotateType]
                               humanAction:detectResult
                              animalResult:nil
                               animalCount:0
                                outTexture:self->_outTexture
                            outPixelFormat:ST_PIX_FMT_BGRA8888
                                   outData:nil];


    if (self->_outputPixelBuffer) {
        [self.effecgGLPreview renderPixelBuffer:self->_outputPixelBuffer rotate:-1];
    }
    [self.consumer consumePixelBuffer:self->_outputPixelBuffer withTimestamp:timeStamp rotation:AgoraVideoRotationNone];
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

- (void)getDeviceOrientation:(CMAccelerometerData *)accelerometerData {
    if (accelerometerData.acceleration.x >= 0.75) {
        _deviceOrientation = UIDeviceOrientationLandscapeRight;
    } else if (accelerometerData.acceleration.x <= -0.75) {
        _deviceOrientation = UIDeviceOrientationLandscapeLeft;
    } else if (accelerometerData.acceleration.y <= -0.75) {
        _deviceOrientation = UIDeviceOrientationPortrait;
    } else if (accelerometerData.acceleration.y >= 0.75) {
        _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
    } else {
        _deviceOrientation = UIDeviceOrientationPortrait;
    }
}

- (st_rotate_type)getRotateType{
    BOOL isFrontCamera = self.camera.devicePosition == AVCaptureDevicePositionFront;
    BOOL isVideoMirrored = self.camera.videoConnection.isVideoMirrored;
    
    [self getDeviceOrientation:[EFMotionManager sharedInstance].motionManager.accelerometerData];
    
    switch (_deviceOrientation) {
            
        case UIDeviceOrientationPortrait:
            return ST_CLOCKWISE_ROTATE_0;
            
        case UIDeviceOrientationPortraitUpsideDown:
            return ST_CLOCKWISE_ROTATE_180;
            
        case UIDeviceOrientationLandscapeLeft:
            return ((isFrontCamera && isVideoMirrored) || (!isFrontCamera && !isVideoMirrored)) ? ST_CLOCKWISE_ROTATE_270 : ST_CLOCKWISE_ROTATE_90;
            
        case UIDeviceOrientationLandscapeRight:
            return ((isFrontCamera && isVideoMirrored) || (!isFrontCamera && !isVideoMirrored)) ? ST_CLOCKWISE_ROTATE_90 : ST_CLOCKWISE_ROTATE_270;
            
        default:
            return ST_CLOCKWISE_ROTATE_0;
    }
}

@end
