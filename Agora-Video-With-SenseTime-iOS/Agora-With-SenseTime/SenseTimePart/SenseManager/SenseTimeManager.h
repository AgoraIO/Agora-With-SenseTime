//
//  SenseTimeManager.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/17.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SenseBeautifyManager.h"
#import "SenseEffectsManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _SenseTimeModel {
    AVCaptureDevicePosition devicePosition;
    BOOL isVideoMirrored;

    GLuint *textureResult;
    CVPixelBufferRef pixelBuffer;
} SenseTimeModel;

@protocol SenseTimeDelegate <NSObject>
- (void)onDetectFaceExposureChange;
@end

@interface SenseTimeManager : NSObject<SenseEffectsDelegate, SenseBeautifyDelegate>

@property (nonatomic, weak) id<SenseTimeDelegate> senseTimeDelegate;

@property (nonatomic, strong) SenseBeautifyManager *senseBeautifyManager;
@property (nonatomic, strong) SenseEffectsManager *senseEffectsManager;

@property (nonatomic, readwrite, assign) CGFloat imageWidth;
@property (nonatomic, readwrite, assign) CGFloat imageHeight;

@property (nonatomic, assign) BOOL bAttribute;
@property (nonatomic, assign) BOOL isComparing;

@property (nonatomic, strong) EAGLContext * _Nullable glContext;

- (instancetype)initWithSuccessBlock:(dispatch_block_t)setupSuccessBlock;

- (CVPixelBufferRef)captureOutputWithSenseTimeModel:(SenseTimeModel)model;

- (void)releaseResources;

- (void)resetBmp;

- (st_rotate_type)getSTMobileRotate;

@end

NS_ASSUME_NONNULL_END
