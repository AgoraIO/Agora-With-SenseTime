#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SenseTimeManager.h"



@interface SenseMeFilter : NSObject

@property (nonatomic, strong) SenseTimeManager *senseTimeManager;
@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, assign) BOOL isVideoMirrored;

@property (nonatomic, copy) void (^didCompletion)(CVPixelBufferRef originalPixelBuffer, CVPixelBufferRef resultPixelBuffer);

- (CVPixelBufferRef)processFrame:(CVPixelBufferRef)frame;

+ (SenseMeFilter *)shareManager;

@end
