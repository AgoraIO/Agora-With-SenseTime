//
//  BaseEffectsProcess.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/4.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectsProcess.h"
#import "EffectsGLPreview.h"
#import "EFTriggerView.h"
#import "NSBundle+language.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFBaseEffectsProcess : UIViewController
{
    CVOpenGLESTextureCacheRef _cvTextureCache;
    
    @public
    GLuint _outTexture;
    CVPixelBufferRef _outputPixelBuffer;
    CVOpenGLESTextureRef _outputCVTexture;
    BOOL _isFirstLaunch;
}

@property (nonatomic, strong) EffectsProcess *effectsProcess;
@property (nonatomic, strong) EffectsGLPreview *effecgGLPreview;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CIContext *ciContext;
//UI
@property (nonatomic, strong) UIView  *performaceView;
@property (nonatomic, strong) UILabel *lblSpeed;
@property (nonatomic, strong) UILabel *lblCPU;

@property (nonatomic, assign) int packageID;


@property (nonatomic, strong) EFTriggerView *triggerView;

- (CGFloat)getNavBarHight;

//- (void)showTriggerAction:(uint64_t)iAction;
- (void)showTriggerAction:(uint64_t)iAction andCustomAction:(uint64_t)customAction;

- (CGRect)getZoomedRectWithImageWidth:(int)iWidth
                               height:(int)iHeight
                               inRect:(CGRect)rect
                           scaleToFit:(BOOL)bScaleToFit;

-(int)getCurrent3DBeautyInfoIndexFrom:(st_effect_3D_beauty_part_info_t *)originInfos andCount:(int)count byRenderModel:(EFRenderModel *)renderModel;

-(void)setImageBackground:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
