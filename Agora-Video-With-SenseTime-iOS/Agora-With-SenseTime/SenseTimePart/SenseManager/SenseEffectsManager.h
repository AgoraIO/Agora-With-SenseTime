//
//  SenseEffectsManager.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/19.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

#import "st_mobile_common.h"
#import "st_mobile_human_action.h"

#import "STCustomMemoryCache.h"
#import "EffectsCollectionViewCell.h"
#import "STCommonObjectContainerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _SenseEffectsModel {
    //视频充满全屏的缩放比例
    CGFloat scale;
    int margin;
    
    int iWidth;
    int iHeight;
    int iBytesPerRow;
    st_rotate_type stMobileRotate;
    CMQuaternion quaternion;
    AVCaptureDevicePosition devicePosition;
    st_mobile_human_action_t newDetectResult;

    unsigned char *pBGRAImageIn;
} SenseEffectsModel;

@protocol SenseEffectsDelegate <NSObject>
- (void)updateCurrentAction:(unsigned long long)iAction;
@end

@interface SenseEffectsManager : NSObject

@property (nonatomic, weak) id<SenseEffectsDelegate> senseEffectsDelegate;

//- (void)setupUtilTools;
- (void)setupHandle;

- (void)initResultTextureWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight cvTextureCache:(CVOpenGLESTextureCacheRef)textureCache;

- (void)releaseResources;
- (void)releaseResultTexture;
- (void)freeCatFace;
    
- (CVPixelBufferRef)captureOutputSenseEffectsModel:(SenseEffectsModel)model textureResult:(GLuint *)textureResult pixelBufffer:(CVPixelBufferRef)pixelBufffer;

// for view
@property (nonatomic, strong) STCustomMemoryCache *thumbnailCache;
@property (nonatomic, strong) STCustomMemoryCache *effectsDataSource;

@property (nonatomic, assign, getter=isCommonObjectViewAdded) BOOL commonObjectViewAdded;
@property (nonatomic, assign, getter=isCommonObjectViewSetted) BOOL commonObjectViewSetted;

@property (nonatomic, assign) BOOL bTracker;

@property (nonatomic, strong) void (^onTrackBlock) (st_rect_t trackRect, CGPoint displayCenter);

- (void)setMaterialModel:(EffectsCollectionViewCellModel *)targetModel triggerSuccessBlock:(nullable void(^)(NSString *contentText, NSString *imageName))successBlock triggerFailBlock:(nullable void(^)(void))failBlock;

// on click cancel button
- (void)cancelStickerAndObjectTrack;

- (void)resetTrackingFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
