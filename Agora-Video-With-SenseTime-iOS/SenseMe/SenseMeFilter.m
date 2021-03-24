
#import "SenseMeFilter.h"
#import "SenseTimeManager.h"
#import "SenseBeautifyManager.h"
#import "SenseEffectsManager.h"

@interface SenseMeFilter() <SenseTimeDelegate>{
}


@end

static SenseMeFilter *shareManager = NULL;

@implementation SenseMeFilter

+ (SenseMeFilter *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[SenseMeFilter alloc] init];
    });

    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.senseTimeManager = [[SenseTimeManager alloc] initWithSuccessBlock:^{
            NSLog(@"SenseTimeManager Success");
    }];
        self.senseTimeManager.senseTimeDelegate = self;
    }
    
    return self;
}

#pragma mark - VideoFilterDelegate
/// process your video frame here
- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)frame {
    //获取每一帧图像信息
    CVPixelBufferRef originalPixelBuffer = frame;
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
     self.didCompletion(originalPixelBuffer, pixelBufferRefResult);
    }

    CVPixelBufferUnlockBaseAddress(originalPixelBuffer, 0);
    return pixelBufferRefResult;
}

- (void)onDetectFaceExposureChange {
        NSLog(@"SenseTimeManager onDetectFaceExposureChange");
}

@end
