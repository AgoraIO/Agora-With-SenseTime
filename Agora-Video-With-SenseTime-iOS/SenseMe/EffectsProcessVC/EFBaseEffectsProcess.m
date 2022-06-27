//
//  BaseEffectsProcess.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/4.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFBaseEffectsProcess.h"
#import "SenseArSourceService.h"
#import "EFGlobalSingleton.h"
#import "EffectsImageUtils.h"

#define USE_SERVER_ONLINE_ACTIVATION 1
#define USE_SDK_ONLINE_ACTIVATION 0

@interface EFBaseEffectsProcess ()<UINavigationControllerDelegate>

@property (nonatomic, strong) SenseArMaterialService *service;

@end

@implementation EFBaseEffectsProcess

- (void)dealloc{
    [EAGLContext setCurrentContext:self.glContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_outTexture) glDeleteTextures(1, &_outTexture);
    if (_outputPixelBuffer) CVPixelBufferRelease(_outputPixelBuffer);
    if (_outputCVTexture) CFRelease(_outputCVTexture);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    self.service = [SenseArMaterialService sharedInstance];
    NSData *data = [self.service getLicenseData];
    self.packageID = -1;
#if USE_SERVER_ONLINE_ACTIVATION
#elif USE_SDK_ONLINE_ACTIVATION
    data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SENSEMEONLINE" ofType:@"lic"]];
#else
    data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"]];
#endif
    BOOL authorize = [EffectsProcess authorizeWithLicenseData:data];
    if (!authorize) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"授权失败,请检查网络或license", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *conform = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:conform];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self addNotifications];
}

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)appWillResignActive{}

- (void)appDidBecomeActive{}

//- (void)applicationWillTerminate{}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - NavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowNavBar = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowNavBar animated:YES];
}

#pragma mark - setter/getter

- (UIView *)performaceView{
    if (!_performaceView) {
        _performaceView = [[UIView alloc] initWithFrame:CGRectZero];
        _performaceView.backgroundColor = [UIColor whiteColor];
        
        [_performaceView addSubview:self.lblSpeed];
        [_performaceView addSubview:self.lblCPU];
        
        [self.lblSpeed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_performaceView).offset(5);
            make.height.mas_equalTo(15);
        }];
        [self.lblCPU mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.lblSpeed);
            make.top.equalTo(self.lblSpeed.mas_bottom).offset(5);
        }];
    }
    return _performaceView;
}

- (UILabel *)lblSpeed {
    if (!_lblSpeed) {
        _lblSpeed = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblSpeed.textAlignment = NSTextAlignmentLeft;
        [_lblSpeed setTextColor:[UIColor whiteColor]];
        [_lblSpeed setBackgroundColor:[UIColor clearColor]];
        [_lblSpeed setFont:[UIFont systemFontOfSize:15.0]];
        [_lblSpeed setShadowColor:[UIColor blackColor]];
        [_lblSpeed setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
    return _lblSpeed;
}

- (UILabel *)lblCPU {
    if (!_lblCPU) {
        _lblCPU = [[UILabel alloc] initWithFrame:CGRectZero];
        _lblCPU.textAlignment = NSTextAlignmentLeft;
        [_lblCPU setTextColor:[UIColor whiteColor]];
        [_lblCPU setBackgroundColor:[UIColor clearColor]];
        [_lblCPU setFont:[UIFont systemFontOfSize:15.0]];
        [_lblCPU setShadowColor:[UIColor blackColor]];
        [_lblCPU setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
    return _lblCPU;
}


- (CGRect)getZoomedRectWithImageWidth:(int)iWidth
                               height:(int)iHeight
                               inRect:(CGRect)rect
                           scaleToFit:(BOOL)bScaleToFit{
    CGRect rectRet = rect;
    
    float fScaleX = iWidth / CGRectGetWidth(rect);
    float fScaleY = iHeight / CGRectGetHeight(rect);
    float fScale = bScaleToFit ? fmaxf(fScaleX, fScaleY) : fminf(fScaleX, fScaleY);
    
    
    iWidth /= fScale;
    iHeight /= fScale;
    
    CGFloat fX = rect.origin.x - (iWidth - rect.size.width) / 2.0f;
    CGFloat fY = rect.origin.y - (iHeight - rect.size.height) / 2.0f;
    
    rectRet = CGRectMake(fX, fY, iWidth, iHeight);
    
    return rectRet;
}

//- (void)showTriggerAction:(uint64_t)iAction {
- (void)showTriggerAction:(uint64_t)iAction andCustomAction:(uint64_t)customAction {
    NSMutableArray *contents = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    if (0 != iAction) {//有 trigger信息
        if (CHECK_FLAG(iAction, ST_MOBILE_BROW_JUMP)) {
            NSString *triggerContent = NSLocalizedString(@"请挑挑眉", nil);
            UIImage *image = [UIImage imageNamed:@"head_brow_jump"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_EYE_BLINK)) {
            NSString *triggerContent = NSLocalizedString(@"请眨眨眼", nil);
            UIImage *image = [UIImage imageNamed:@"eye_blink"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HEAD_YAW)) {
            NSString *triggerContent = NSLocalizedString(@"请摇摇头", nil);
            UIImage *image = [UIImage imageNamed:@"head_yaw"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HEAD_PITCH)) {
            NSString *triggerContent = NSLocalizedString(@"请点点头", nil);
            UIImage *image = [UIImage imageNamed:@"head_pitch"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_MOUTH_AH)) {
            NSString *triggerContent = NSLocalizedString(@"请张张嘴", nil);
            UIImage *image = [UIImage imageNamed:@"mouth_ah"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_GOOD)) {
            NSString *triggerContent = NSLocalizedString(@"请比个赞", nil);
            UIImage *image = [UIImage imageNamed:@"hand_good"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_PALM)) {
            NSString *triggerContent = NSLocalizedString(@"请伸手掌", nil);
            UIImage *image = [UIImage imageNamed:@"hand_palm"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_LOVE)) {
            NSString *triggerContent = NSLocalizedString(@"请双手比心", nil);
            UIImage *image = [UIImage imageNamed:@"hand_love"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_HOLDUP)) {
            NSString *triggerContent = NSLocalizedString(@"请托个手", nil);
            UIImage *image = [UIImage imageNamed:@"hand_holdup"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_CONGRATULATE)) {
            NSString *triggerContent = NSLocalizedString(@"请抱个拳", nil);
            UIImage *image = [UIImage imageNamed:@"hand_congratulate"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FINGER_HEART)) {
            NSString *triggerContent = NSLocalizedString(@"请单手比心", nil);
            UIImage *image = [UIImage imageNamed:@"hand_finger_heart"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FINGER_INDEX)) {
            NSString *triggerContent = NSLocalizedString(@"请伸出食指", nil);
            UIImage *image = [UIImage imageNamed:@"hand_finger"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_OK)) {
            NSString *triggerContent = NSLocalizedString(@"请亮出OK手势", nil);
            UIImage *image = [UIImage imageNamed:@"hand_ok"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_SCISSOR)) {
            NSString *triggerContent = NSLocalizedString(@"请比个剪刀手", nil);
            UIImage *image = [UIImage imageNamed:@"hand_victory"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_PISTOL)) {
            NSString *triggerContent = NSLocalizedString(@"请比个手枪", nil);
            UIImage *image = [UIImage imageNamed:@"hand_gun"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_666)) {
            NSString *triggerContent = NSLocalizedString(@"请亮出666手势", nil);
            UIImage *image = [UIImage imageNamed:@"666_selected"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_BLESS)) {
            NSString *triggerContent = NSLocalizedString(@"请双手合十", nil);
            UIImage *image = [UIImage imageNamed:@"bless_selected"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_ILOVEYOU)) {
            NSString *triggerContent = NSLocalizedString(@"请亮出我爱你手势", nil);
            UIImage *image = [UIImage imageNamed:@"love_selected"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FIST)) {
            NSString *triggerContent = NSLocalizedString(@"请举起拳头", nil);
            UIImage *image = [UIImage imageNamed:@"fist_selected"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_FACE_LIPS_POUTED)) {
            NSString *triggerContent = NSLocalizedString(@"请嘟嘴", nil);
            UIImage *image = [UIImage imageNamed:@"FACE_LIPS_POUTED"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
        if (CHECK_FLAG(iAction, ST_MOBILE_FACE_LIPS_UPWARD)) {
            NSString *triggerContent = NSLocalizedString(@"请笑一笑", nil);
            UIImage *image = [UIImage imageNamed:@"FACE_LIPS_UPWARD"];
            [contents addObject:triggerContent];
            [images addObject:image];
        }
    }
    if (customAction != 0) {
        switch (customAction) {
            case EFFECT_CUSTOM_INPUT_EVENT_SCREEN_TAP: {
                NSString *triggerContent = NSLocalizedString(@"请点击屏幕", nil);
                UIImage *image = [UIImage imageNamed:@"hand_touch"];
                [contents addObject:triggerContent];
                [images addObject:image];
            }
                break;
                
            case EFFECT_CUSTOM_INPUT_EVENT_SCREEN_DOUBLE_TAP: {
                NSString *triggerContent = NSLocalizedString(@"请双击屏幕", nil);
                UIImage *image = [UIImage imageNamed:@"hand_touch"];
                [contents addObject:triggerContent];
                [images addObject:image];
            }
                break;
                
            default:
                break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contents.count > 0) {
            [self.triggerView showTriggerViewWithContents:contents images:images];
        } else {
            self.triggerView.hidden = YES;
        }
    });
}

//状态栏 + 导航栏
- (CGFloat)getNavBarHight {
   float statusBarHeight = 0;
   if (@available(iOS 13.0, *)) {
       UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
       statusBarHeight = statusBarManager.statusBarFrame.size.height;
   }
   else {
       statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
   }
   return statusBarHeight + 44;
}

-(int)getCurrent3DBeautyInfoIndexFrom:(st_effect_3D_beauty_part_info_t *)originInfos andCount:(int)count byRenderModel:(EFRenderModel *)renderModel {
    NSDictionary *maps = @{
        @"eyeScale": @"眼睛比例",
        @"eyeHeight": @"眼高",
        @"eyeWidth": @"眼距",
        @"eyeOuterWidth": @"外眼角",
        @"eyeDepth": @"眼睛深浅",
        @"eyeLowerDepth": @"卧蚕深浅",
        @"eyeAngle": @"眼睛角度",
        @"noseScale": @"鼻子比例",
        @"noseWidth": @"鼻宽",
        @"noseHeight": @"鼻长",
        @"noseDepth": @"鼻高",
        @"noseRidgeUpper": @"鼻根",
        @"noseRidgeCurve": @"鼻子驼峰",
        @"noseTipHeight": @"鼻尖",
        @"nostrilWidth": @"鼻翼",
        @"mouthScale": @"嘴巴比例",
        @"mouthWidth": @"嘴巴宽度",
        @"mouthHeight": @"嘴巴高度",
        @"mouthDepth": @"嘴巴深度",
        @"lipThin": @"嘴巴厚度",
        @"headScale": @"头部比例",
        @"headOuterWidth": @"头部宽度",
        @"faceHeavy": @"脸部胖瘦",
        @"faceAngle": @"脸部角度",
        @"faceCenterDepthEnlarge": @"脸部外扩",
        @"faceCenterDepthShrink": @"脸部内缩",
        @"Beeplips": @"嘟嘟唇",
        @"Smilinglips": @"微笑唇",
        @"Cheekbone": @"苹果肌",
        @"Goldenline": @"脸部轮廓",
        @"Forehead": @"额头",
        @"Nasolabial": @"法令纹",
        @"Tearditch": @"泪沟",
        @"Browbone": @"眉骨",
        @"Raiseeyebrows": @"挑眉",
        @"Temple": @"太阳穴",
        @"Foreheadtwo": @"侧额头",
        @"Outereyetail": @"外眼尾",
        @"Innercorner": @"内眼角尖",
    };
    static NSArray *infos;
    if (!infos) {
        NSMutableArray *tmpInfos = [NSMutableArray array];
        for (int i = 0; i < count; i ++) {
            st_effect_3D_beauty_part_info_t info = originInfos[i];
            NSString *key = [NSString stringWithFormat:@"%s", info.name];
            if (maps[key]) {
                [tmpInfos addObject:maps[key]];
            } else {
                [tmpInfos addObject:key];
            }
        }
        infos = [tmpInfos copy];
    }
    
    return (int)[infos indexOfObject:renderModel.efName] ?: 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSUInteger touchCount = touches.anyObject.tapCount;
    EFGlobalSingleton *globalSingleton = [EFGlobalSingleton sharedInstance];

    if (touchCount == 1) {
        globalSingleton.efTouchTriggerAction = EFFECT_CUSTOM_INPUT_EVENT_SCREEN_TAP;
    } else if (touchCount > 1) {
        globalSingleton.efTouchTriggerAction = EFFECT_CUSTOM_INPUT_EVENT_SCREEN_DOUBLE_TAP;
    } else {
        globalSingleton.efTouchTriggerAction = 0;
    }
}

#pragma mark - 图片背景
-(void)setImageBackground:(UIImage *)image {
    if (self.packageID == -1) {
        DLog(@"未设置贴纸素材");
        return;
    }
    
    st_effect_module_info_t *module_info = malloc(sizeof(st_effect_module_info_t));
    [self.effectsProcess getModulesInPackage:self.packageID modules:module_info];

    int maxSize = 1080 * 1920;
    
    int iWidth = image.size.width;
    int iHeight = image.size.height;
    
    if (iWidth * iHeight > maxSize) {
        int multiple = 1;
        if (iWidth > 1080) {
            multiple = (int)ceil(iWidth / 1080);
        } else if (iHeight > 1920) {
            multiple = (int)ceil(iHeight / 1920);
        }
        iWidth /= multiple;
        iHeight /= multiple;
    }
    
    int iBytesPerRow = iWidth * 4;
    int dataSize = iWidth * iHeight * 4;
    unsigned char * pBGRAImageIn = (unsigned char * )malloc(dataSize);
    [EffectsImageUtils convertUIImage:image toBGRABytes:pBGRAImageIn];
    
    st_image_t st_image = {pBGRAImageIn, ST_PIX_FMT_RGBA8888, iWidth, iHeight, iBytesPerRow, 0.0};
    module_info->rsv_type = EFFECT_RESERVED_IMAGE;
    module_info->reserved = &st_image;

    [self.effectsProcess setModuleInfo:module_info];
    
    free(pBGRAImageIn);
    free(module_info);
}
@end
