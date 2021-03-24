#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoFilterDelegate.h"
#import "SenseTimeManager.h"



@interface SenseMeFilter : NSObject <VideoFilterDelegate>

@property (nonatomic, assign) BOOL enabled;


@property (nonatomic, strong) SenseTimeManager *senseTimeManager;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, assign) BOOL isVideoMirrored;

@property (nonatomic, copy) void (^didCompletion)(CVPixelBufferRef originalPixelBuffer, CVPixelBufferRef resultPixelBuffer);

+ (SenseMeFilter *)shareManager;

@end
