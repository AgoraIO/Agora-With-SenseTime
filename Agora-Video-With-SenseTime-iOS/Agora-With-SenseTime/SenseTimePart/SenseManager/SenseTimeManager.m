//
//  SenseTimeManager.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/17.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseTimeManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreMotion/CoreMotion.h>

#import "SenseArSourceService.h"

#import "STMobileLog.h"
#import "STParamUtil.h"

//ST_MOBILE
#import "st_mobile_license.h"
#import "st_mobile_face_attribute.h"
#import "st_mobile_avatar.h"

#import "KeyCenter.h"

@interface SenseTimeManager ()
{
    st_handle_t _hDetector; // detector句柄
    st_handle_t _hAttribute;// attribute句柄
    
    CVOpenGLESTextureCacheRef _cvTextureCache;
    CVOpenGLESTextureRef _cvTextureOrigin;
    GLuint _textureOriginInput;
    
    st_mobile_human_action_t _detectResult;
    
    st_rotate_type _stMobileRotate;
}

@property (nonatomic, assign) int iBufferedCount;

@property (nonatomic, strong) CIContext *ciContext;

@property (nonatomic, assign) double lastTimeAttrDetected;

@property (nonatomic) dispatch_queue_t renderQueue;

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) CGFloat scale;  //视频充满全屏的缩放比例
@property (nonatomic, assign) int margin;

@property (nonatomic, assign) unsigned long long iCurrentAction;
@property (nonatomic, assign) BOOL bExposured;

@property (nonatomic , strong) NSData *licenseData;

@end

@implementation SenseTimeManager

#pragma mark - life cycle
- (instancetype)initWithSuccessBlock:(dispatch_block_t _Nonnull)setupSuccessBlock {
    if(self = [super init]) {
        [self setDefaultValue];
        [self setupUtilTools];
        [self setupSenseArService: setupSuccessBlock];
    }
    return self;
}

- (void)setSenseBeautifyManager:(SenseBeautifyManager*)senseBeautifyManager {
    _senseBeautifyManager = senseBeautifyManager;
    _senseBeautifyManager.senseBeautifyDelegate = self;
}
- (void)setSenseEffectsManager:(SenseEffectsManager*)senseEffectsManager {
    _senseEffectsManager = senseEffectsManager;
    _senseEffectsManager.senseEffectsDelegate = self;
}

- (void)setupUtilTools {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;
    self.motionManager.deviceMotionUpdateInterval = 1 / 25.0;
}

- (void)releaseOriginTexture {
    if (_cvTextureOrigin) {
        CFRelease(_cvTextureOrigin);
        _cvTextureOrigin = NULL;
    }
}

- (void)releaseResources
{
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopDeviceMotionUpdates];
    
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    if (_hDetector) {
        
        st_mobile_human_action_destroy(_hDetector);
        _hDetector = NULL;
    }
    
    if (_hAttribute) {
        
        st_mobile_face_attribute_destroy(_hAttribute);
        _hAttribute = NULL;
    }
    
    if (_cvTextureCache) {
        
        CFRelease(_cvTextureCache);
        _cvTextureCache = NULL;
    }
    
    [self.senseEffectsManager releaseResources];
    [self.senseBeautifyManager releaseResources];
    [self releaseOriginTexture];
    [self releaseResultTexture];
    
    [EAGLContext setCurrentContext:nil];
    self.glContext = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ciContext = nil;
    });
}


- (void)initResource
{
    // 设置SDK OpenGL 环境 , 只有在正确的 OpenGL 环境下 SDK 才会被正确初始化 .
    self.ciContext = [CIContext contextWithEAGLContext:self.glContext
                                               options:@{kCIContextWorkingColorSpace : [NSNull null]}];
    [EAGLContext setCurrentContext:self.glContext];
    
    // 初始化结果文理及纹理缓存
    CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, self.glContext, NULL, &_cvTextureCache);
    if (err) {
        NSLog(@"CVOpenGLESTextureCacheCreate %d" , err);
    }
    
    [self initResultTexture];
    
    ///ST_MOBILE：初始化句柄之前需要验证License
    if ([self checkActiveCodeWithData:self.licenseData]) {
        ///ST_MOBILE：初始化相关的句柄
        [self setupHandle];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"使用 license 文件生成激活码时失败，可能是授权文件过期。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    if ([self.motionManager isAccelerometerAvailable]) {
        [self.motionManager startAccelerometerUpdates];
    }
    
    if ([self.motionManager isDeviceMotionAvailable]) {
        [self.motionManager startDeviceMotionUpdates];
    }
}

-(void)resetBmp {
    [self.senseBeautifyManager resetBmp];
}

#pragma mark - setup subviews

- (void)setDefaultValue {
    
    self.bAttribute = NO;
    self.bExposured = NO;
    
    self.iCurrentAction = 0;
    
    self.imageWidth = 720;
    self.imageHeight = 1280;
    
    self.renderQueue = dispatch_queue_create("com.sensetime.renderQueue", NULL);
    
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
}

#pragma - mark -
#pragma - mark Setup Service
- (void)setupSenseArService:(dispatch_block_t _Nonnull)setupSuccessBlock{
    
    STWeakSelf;
    [[SenseArMaterialService sharedInstance]
     authorizeWithAppID:[KeyCenter senseAppId]
     appKey:[KeyCenter senseAppKey]
     onSuccess:^{
        
#if USE_ONLINE_ACTIVATION
#else
        weakSelf.licenseData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"]];
#endif
        dispatch_async(dispatch_get_main_queue(), ^{
            
            setupSuccessBlock();
            
            [weakSelf initResource];
            
            
        });
        
        [[SenseArMaterialService sharedInstance] setMaxCacheSize:120000000];
    }
     onFailure:^(SenseArAuthorizeError iErrorCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            
            switch (iErrorCode) {
                    
                case AUTHORIZE_ERROR_KEY_NOT_MATCHED:
                {
                    [alert setMessage:@"无效 AppID/SDKKey"];
                }
                    break;
                    
                    
                case AUTHORIZE_ERROR_NETWORK_NOT_AVAILABLE:
                {
                    [alert setMessage:@"网络不可用"];
                }
                    break;
                    
                case AUTHORIZE_ERROR_DECRYPT_FAILED:
                {
                    [alert setMessage:@"解密失败"];
                }
                    break;
                    
                case AUTHORIZE_ERROR_DATA_PARSE_FAILED:
                {
                    [alert setMessage:@"解析失败"];
                }
                    break;
                    
                case AUTHORIZE_ERROR_UNKNOWN:
                {
                    [alert setMessage:@"未知错误"];
                }
                    break;
                    
                default:
                    break;
            }
            
            [alert show];
        });
    }];
}


#pragma mark - setup handle
- (void)setupHandle {
    
    st_result_t iRet = ST_OK;
    
    //初始化检测模块句柄
    NSString *strModelPath = [[NSBundle mainBundle] pathForResource:@"M_SenseME_Face_Video_5.3.3" ofType:@"model"];
    
    uint32_t config = ST_MOBILE_HUMAN_ACTION_DEFAULT_CONFIG_VIDEO;
    
    TIMELOG(key);
    
    iRet = st_mobile_human_action_create(strModelPath.UTF8String, config, &_hDetector);
    
    TIMEPRINT(key,"human action create time:");
    
    if (ST_OK != iRet || !_hDetector) {
        
        NSLog(@"st mobile human action create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"算法SDK初始化失败，可能是模型路径错误，SDK权限过期，与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    } else {
        
        addSubModel(_hDetector, @"M_SenseME_Face_Extra_5.22.0");
        addSubModel(_hDetector, @"M_SenseME_Iris_2.0.0");
        addSubModel(_hDetector, @"M_SenseME_Hand_5.4.0");
        addSubModel(_hDetector, @"M_SenseME_Segment_1.5.0");
        addSubModel(_hDetector, @"M_SenseME_Avatar_Help_new");
    }
    
    [self.senseEffectsManager setupHandle];
    [self.senseBeautifyManager setupHandle];
}

- (BOOL)checkActiveCodeWithData:(NSData *)dataLicense
{
    NSString *strKeyActiveCode = @"ACTIVE_CODE_ONLINE";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strActiveCode = [userDefaults objectForKey:strKeyActiveCode];
    st_result_t iRet = ST_E_FAIL;
    
    iRet = st_mobile_check_activecode_from_buffer(
                                                  [dataLicense bytes],
                                                  (int)[dataLicense length],
                                                  strActiveCode.UTF8String,
                                                  (int)[strActiveCode length]
                                                  );
    
    if (ST_OK == iRet) {
        
        return YES;
    }
    
    char active_code[1024];
    int active_code_len = 1024;
    
    iRet = st_mobile_generate_activecode_from_buffer(
                                                     [dataLicense bytes],
                                                     (int)[dataLicense length],
                                                     active_code,
                                                     &active_code_len
                                                     );
    
    strActiveCode = [[NSString alloc] initWithUTF8String:active_code];
    
    
    if (iRet == ST_OK && strActiveCode.length) {
        
        [userDefaults setObject:strActiveCode forKey:strKeyActiveCode];
        [userDefaults synchronize];
        
        return YES;
    }
    
    return NO;
}

#pragma mark - handle texture
- (void)initResultTexture {
    // 创建结果纹理
    [self.senseEffectsManager initResultTextureWithWidth:self.imageWidth height:self.imageHeight cvTextureCache:_cvTextureCache];
    [self.senseBeautifyManager initResultTextureWithWidth:self.imageWidth height:self.imageHeight cvTextureCache:_cvTextureCache];
}

- (void)releaseResultTexture {
    [self.senseEffectsManager releaseResultTexture];
    [self.senseBeautifyManager releaseResultTexture];
}

#pragma mark ---
- (CVPixelBufferRef)captureOutputWithSenseTimeModel:(SenseTimeModel)model {
    
    TIMELOG(frameCostKey);
    
    CVPixelBufferRef pixelBuffer = model.pixelBuffer;
    
    if (self.iBufferedCount >= 2) {
        return pixelBuffer;
    }

    //获取每一帧图像信息
    unsigned char* pBGRAImageIn = (unsigned char*)CVPixelBufferGetBaseAddress(pixelBuffer);
    
    int iBytesPerRow = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    int iWidth = (int)CVPixelBufferGetWidth(pixelBuffer);
    int iHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    size_t iTop , iBottom , iLeft , iRight;
    CVPixelBufferGetExtendedPixels(pixelBuffer, &iLeft, &iRight, &iTop, &iBottom);
    
    iWidth = iWidth + (int)iLeft + (int)iRight;
    iHeight = iHeight + (int)iTop + (int)iBottom;
    iBytesPerRow = iBytesPerRow + (int)iLeft + (int)iRight;
    
    _scale = MAX(SCREEN_HEIGHT / iHeight, SCREEN_WIDTH / iWidth);
    _margin = (iWidth * _scale - SCREEN_WIDTH) / 2;
    
    _stMobileRotate = [self getRotateTypeWithDevicePosition:model.devicePosition videoMirrored:model.isVideoMirrored];
    
    st_mobile_human_action_t detectResult;
    memset(&detectResult, 0, sizeof(st_mobile_human_action_t));
    
    // 如果需要做属性,每隔一秒做一次属性
    double dTimeNow = CFAbsoluteTimeGetCurrent();
    BOOL isAttributeTime = (dTimeNow - self.lastTimeAttrDetected) >= 1.0;
    if (isAttributeTime) {
        self.lastTimeAttrDetected = dTimeNow;
    }
    
    ///ST_MOBILE 人脸信息检测部分
    if (_hDetector) {
        
        if(self.bAttribute && isAttributeTime && _hAttribute) {
            uint64_t config = _iCurrentAction | ST_MOBILE_FACE_DETECT;
            _iCurrentAction = config;
        } else {
            _iCurrentAction = [self.senseBeautifyManager currentActionWithBeautify: _iCurrentAction];
        }
        
        _iCurrentAction = [self.senseBeautifyManager currentActionWithMakeUp: _iCurrentAction];
        
        
        if (self.iCurrentAction > 0) {
            
            TIMELOG(keyDetect);
            
            st_result_t iRet = st_mobile_human_action_detect(_hDetector, pBGRAImageIn, ST_PIX_FMT_BGRA8888, iWidth, iHeight, iBytesPerRow, _stMobileRotate, self.iCurrentAction, &detectResult);
            
            TIMEPRINT(keyDetect, "st_mobile_human_action_detect time:");
            
            if (detectResult.face_count > 0 && !self.bExposured) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.senseTimeDelegate onDetectFaceExposureChange];
                });
                
                self.bExposured = YES;
            }
            
            if (!detectResult.face_count) {
                self.bExposured = NO;
            }
            
            if(iRet != ST_OK) {
                STLog(@"st_mobile_human_action_detect failed %d" , iRet);
            }
        }
    }
    
    self.iBufferedCount ++;
    __block st_mobile_human_action_t newDetectResult;
    memset(&newDetectResult, 0, sizeof(st_mobile_human_action_t));
    copyHumanAction(&detectResult, &newDetectResult);
    
    // 设置 OpenGL 环境 , 需要与初始化 SDK 时一致
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
    
    // 当图像尺寸发生改变时需要对应改变纹理大小
    if (iWidth != self.imageWidth || iHeight != self.imageHeight) {
        
        [self releaseResultTexture];
        
        self.imageWidth = iWidth;
        self.imageHeight = iHeight;
        
        [self initResultTexture];
    }
    
    // 获取原图纹理
    BOOL isTextureOriginReady = [self setupOriginTextureWithPixelBuffer:pixelBuffer];
    *(model.textureResult) = _textureOriginInput;
    
    SenseBeautifyModel senseBeautifyModel;
    senseBeautifyModel.iWidth = iWidth;
    senseBeautifyModel.iHeight = iHeight;
    senseBeautifyModel.stMobileRotate = _stMobileRotate;
    senseBeautifyModel.newDetectResult = newDetectResult;
    senseBeautifyModel.isTextureOriginReady = isTextureOriginReady;
    senseBeautifyModel.textureOriginInput = _textureOriginInput;
    pixelBuffer = [self.senseBeautifyManager captureOutputSenseBeautifyModel:senseBeautifyModel textureResult:model.textureResult pixelBufffer:pixelBuffer];
    
    SenseEffectsModel senseEffectsModel;
    senseEffectsModel.scale = _scale;
    senseEffectsModel.margin = _margin;
    senseEffectsModel.iWidth = iWidth;
    senseEffectsModel.iHeight = iHeight;
    senseEffectsModel.iBytesPerRow = iBytesPerRow;
    senseEffectsModel.stMobileRotate = _stMobileRotate;
    senseEffectsModel.quaternion = self.motionManager.deviceMotion.attitude.quaternion;
    senseEffectsModel.devicePosition = model.devicePosition;
    senseEffectsModel.newDetectResult = newDetectResult;
    senseEffectsModel.pBGRAImageIn = pBGRAImageIn;
    pixelBuffer = [self.senseEffectsManager captureOutputSenseEffectsModel:senseEffectsModel textureResult:model.textureResult pixelBufffer:pixelBuffer];
    
    //对比
    if (self.isComparing) {
        *(model.textureResult) = _textureOriginInput;
        pixelBuffer = model.pixelBuffer;
    }
    
    [self releaseOriginTexture];
    freeHumanAction(&newDetectResult);
    [self.senseEffectsManager freeCatFace];
    
    CVOpenGLESTextureCacheFlush(_cvTextureCache, 0);
    self.iBufferedCount --;
    
    return pixelBuffer;
}
- (BOOL)setupOriginTextureWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    CVReturn cvRet = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                  _cvTextureCache,
                                                                  pixelBuffer,
                                                                  NULL,
                                                                  GL_TEXTURE_2D,
                                                                  GL_RGBA,
                                                                  self.imageWidth,
                                                                  self.imageHeight,
                                                                  GL_BGRA,
                                                                  GL_UNSIGNED_BYTE,
                                                                  0,
                                                                  &_cvTextureOrigin);
    
    if (!_cvTextureOrigin || kCVReturnSuccess != cvRet) {
        
        NSLog(@"OriginTexture CVOpenGLESTextureCacheCreateTextureFromImage %d" , cvRet);
        
        return NO;
    }
    
    _textureOriginInput = CVOpenGLESTextureGetName(_cvTextureOrigin);
    glBindTexture(GL_TEXTURE_2D , _textureOriginInput);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    return YES;
}

#pragma mark -- private
void copyHumanAction(st_mobile_human_action_t *src , st_mobile_human_action_t *dst) {
    
    memcpy(dst, src, sizeof(st_mobile_human_action_t));
    
    // copy faces
    if ((*src).face_count > 0) {
        
        size_t faces_size = sizeof(st_mobile_face_t) * (*src).face_count;
        st_mobile_face_t *p_faces = malloc(faces_size);
        memset(p_faces, 0, faces_size);
        memcpy(p_faces, (*src).p_faces, faces_size);
        (*dst).p_faces = p_faces;
        
        for (int i = 0; i < (*src).face_count; i ++) {
            
            st_mobile_face_t face = (*src).p_faces[i];
            
            // p_extra_face_points
            if (face.extra_face_points_count > 0 && face.p_extra_face_points != NULL) {
                
                size_t extra_face_points_size = sizeof(st_pointf_t) * face.extra_face_points_count;
                st_pointf_t *p_extra_face_points = malloc(extra_face_points_size);
                memset(p_extra_face_points, 0, extra_face_points_size);
                memcpy(p_extra_face_points, face.p_extra_face_points, extra_face_points_size);
                (*dst).p_faces[i].p_extra_face_points = p_extra_face_points;
            }
            
            // p_tongue_points & p_tongue_points_score
            if (   face.tongue_points_count > 0
                && face.p_tongue_points != NULL
                && face.p_tongue_points_score != NULL) {
                
                size_t tongue_points_size = sizeof(st_pointf_t) * face.tongue_points_count;
                st_pointf_t *p_tongue_points = malloc(tongue_points_size);
                memset(p_tongue_points, 0, tongue_points_size);
                memcpy(p_tongue_points, face.p_tongue_points, tongue_points_size);
                (*dst).p_faces[i].p_tongue_points = p_tongue_points;
                
                size_t tongue_points_score_size = sizeof(float) * face.tongue_points_count;
                float *p_tongue_points_score = malloc(tongue_points_score_size);
                memset(p_tongue_points_score, 0, tongue_points_score_size);
                memcpy(p_tongue_points_score, face.p_tongue_points_score, tongue_points_score_size);
                (*dst).p_faces[i].p_tongue_points_score = p_tongue_points_score;
            }
            
            // p_eyeball_center
            if (face.eyeball_center_points_count > 0 && face.p_eyeball_center != NULL) {
                
                size_t eyeball_center_points_size = sizeof(st_pointf_t) * face.eyeball_center_points_count;
                st_pointf_t *p_eyeball_center = malloc(eyeball_center_points_size);
                memset(p_eyeball_center, 0, eyeball_center_points_size);
                memcpy(p_eyeball_center, face.p_eyeball_center, eyeball_center_points_size);
                (*dst).p_faces[i].p_eyeball_center = p_eyeball_center;
            }
            
            // p_eyeball_contour
            if (face.eyeball_contour_points_count > 0 && face.p_eyeball_contour != NULL) {
                
                size_t eyeball_contour_points_size = sizeof(st_pointf_t) * face.eyeball_contour_points_count;
                st_pointf_t *p_eyeball_contour = malloc(eyeball_contour_points_size);
                memset(p_eyeball_contour, 0, eyeball_contour_points_size);
                memcpy(p_eyeball_contour, face.p_eyeball_contour, eyeball_contour_points_size);
                (*dst).p_faces[i].p_eyeball_contour = p_eyeball_contour;
            }
        }
    }
    
    
    // copy hands
    if ((*src).hand_count > 0) {
        
        size_t hands_size = sizeof(st_mobile_hand_t) * (*src).hand_count;
        st_mobile_hand_t *p_hands = malloc(hands_size);
        memset(p_hands, 0, hands_size);
        memcpy(p_hands, (*src).p_hands, hands_size);
        (*dst).p_hands = p_hands;
        
        for (int i = 0; i < (*src).hand_count; i ++) {
            
            st_mobile_hand_t hand = (*src).p_hands[i];
            
            // p_key_points
            if (hand.key_points_count > 0 && hand.p_key_points != NULL) {
                
                size_t key_points_size = sizeof(st_pointf_t) * hand.key_points_count;
                st_pointf_t *p_key_points = malloc(key_points_size);
                memset(p_key_points, 0, key_points_size);
                memcpy(p_key_points, hand.p_key_points, key_points_size);
                (*dst).p_hands[i].p_key_points = p_key_points;
            }
            
            // p_skeleton_keypoints
            if (hand.skeleton_keypoints_count > 0 && hand.p_skeleton_keypoints != NULL) {
                
                size_t skeleton_keypoints_size = sizeof(st_pointf_t) * hand.skeleton_keypoints_count;
                st_pointf_t *p_skeleton_keypoints = malloc(skeleton_keypoints_size);
                memset(p_skeleton_keypoints, 0, skeleton_keypoints_size);
                memcpy(p_skeleton_keypoints, hand.p_skeleton_keypoints, skeleton_keypoints_size);
                (*dst).p_hands[i].p_skeleton_keypoints = p_skeleton_keypoints;
            }
            
            // p_skeleton_3d_keypoints
            if (hand.skeleton_3d_keypoints_count > 0 && hand.p_skeleton_3d_keypoints != NULL) {
                
                size_t skeleton_3d_keypoints_size = sizeof(st_point3f_t) * hand.skeleton_3d_keypoints_count;
                st_point3f_t *p_skeleton_3d_keypoints = malloc(skeleton_3d_keypoints_size);
                memset(p_skeleton_3d_keypoints, 0, skeleton_3d_keypoints_size);
                memcpy(p_skeleton_3d_keypoints, hand.p_skeleton_3d_keypoints, skeleton_3d_keypoints_size);
                (*dst).p_hands[i].p_skeleton_3d_keypoints = p_skeleton_3d_keypoints;
            }
        }
    }
    
    
    // copy body
    if ((*src).body_count > 0) {
        
        size_t bodys_size = sizeof(st_mobile_body_t) * (*src).body_count;
        st_mobile_body_t *p_bodys = malloc(bodys_size);
        memset(p_bodys, 0, bodys_size);
        memcpy(p_bodys, (*src).p_bodys, bodys_size);
        (*dst).p_bodys = p_bodys;
        
        for (int i = 0; i < (*src).body_count; i ++) {
            
            st_mobile_body_t body = (*src).p_bodys[i];
            
            // p_key_points & p_key_points_score
            if (   body.key_points_count > 0
                && body.p_key_points != NULL
                && body.p_key_points_score != NULL) {
                
                size_t key_points_size = sizeof(st_pointf_t) * body.key_points_count;
                st_pointf_t *p_key_points = malloc(key_points_size);
                memset(p_key_points, 0, key_points_size);
                memcpy(p_key_points, body.p_key_points, key_points_size);
                (*dst).p_bodys[i].p_key_points = p_key_points;
                
                size_t key_points_score_size = sizeof(float) * body.key_points_count;
                float *p_key_points_score = malloc(key_points_score_size);
                memset(p_key_points_score, 0, key_points_score_size);
                memcpy(p_key_points_score, body.p_key_points_score, key_points_score_size);
                (*dst).p_bodys[i].p_key_points_score = p_key_points_score;
            }
            
            
            // p_contour_points & p_contour_points_score
            if (   body.contour_points_count > 0
                && body.p_contour_points != NULL
                && body.p_contour_points_score != NULL) {
                
                size_t contour_points_size = sizeof(st_pointf_t) * body.contour_points_count;
                st_pointf_t *p_contour_points = malloc(contour_points_size);
                memset(p_contour_points, 0, contour_points_size);
                memcpy(p_contour_points, body.p_contour_points, contour_points_size);
                (*dst).p_bodys[i].p_contour_points = p_contour_points;
                
                size_t contour_points_score_size = sizeof(float) * body.contour_points_count;
                float *p_contour_points_score = malloc(contour_points_score_size);
                memset(p_contour_points_score, 0, contour_points_score_size);
                memcpy(p_contour_points_score, body.p_contour_points_score, contour_points_score_size);
                (*dst).p_bodys[i].p_contour_points_score = p_contour_points_score;
            }
        }
    }
    
    
    // p_background
    if ((*src).p_background != NULL) {
        
        st_image_t *p_background = malloc(sizeof(st_image_t));
        memcpy(p_background, (*src).p_background, sizeof(st_image_t));
        
        size_t image_data_size = sizeof(unsigned char) * (*src).p_background[0].width * (*src).p_background[0].height;
        unsigned char *data = malloc(image_data_size);
        memset(data, 0, image_data_size);
        memcpy(data, (*src).p_background[0].data, image_data_size);
        p_background[0].data = data;
        
        (*dst).p_background = p_background;
    }
    
    // p_hair
    if ((*src).p_hair != NULL) {
        
        st_image_t *p_hair = malloc(sizeof(st_image_t));
        memcpy(p_hair, (*src).p_hair, sizeof(st_image_t));
        
        size_t image_data_size = sizeof(unsigned char) * (*src).p_hair[0].width * (*src).p_hair[0].height;
        unsigned char *data = malloc(image_data_size);
        memset(data, 0, image_data_size);
        memcpy(data, (*src).p_hair[0].data, image_data_size);
        p_hair[0].data = data;
        
        (*dst).p_hair = p_hair;
    }
}


void freeHumanAction(st_mobile_human_action_t *src) {
    
    // free faces
    if ((*src).face_count > 0) {
        
        for (int i = 0; i < (*src).face_count; i ++) {
            
            st_mobile_face_t face = (*src).p_faces[i];
            
            // p_extra_face_points
            if (face.extra_face_points_count > 0 && face.p_extra_face_points != NULL) {
                
                free(face.p_extra_face_points);
                face.p_extra_face_points = NULL;
            }
            
            // p_tongue_points & p_tongue_points_score
            if (   face.tongue_points_count > 0
                && face.p_tongue_points != NULL
                && face.p_tongue_points_score != NULL) {
                
                free(face.p_tongue_points);
                face.p_tongue_points = NULL;
                
                free(face.p_tongue_points_score);
                face.p_tongue_points_score = NULL;
            }
            
            // p_eyeball_center
            if (face.eyeball_center_points_count > 0 && face.p_eyeball_center != NULL) {
                
                free(face.p_eyeball_center);
                face.p_eyeball_center = NULL;
            }
            
            // p_eyeball_contour
            if (face.eyeball_contour_points_count > 0 && face.p_eyeball_contour != NULL) {
                
                free(face.p_eyeball_contour);
                face.p_eyeball_contour = NULL;
            }
        }
        
        free((*src).p_faces);
        (*src).p_faces = NULL;
    }
    
    
    // free hands
    if ((*src).hand_count > 0) {
        
        for (int i = 0; i < (*src).hand_count; i ++) {
            
            st_mobile_hand_t hand = (*src).p_hands[i];
            
            // p_key_points
            if (hand.key_points_count > 0 && hand.p_key_points != NULL) {
                
                free(hand.p_key_points);
                hand.p_key_points = NULL;
            }
            
            // p_skeleton_keypoints
            if (hand.skeleton_keypoints_count > 0 && hand.p_skeleton_keypoints != NULL) {
                
                free(hand.p_skeleton_keypoints);
                hand.p_skeleton_keypoints = NULL;
            }
            
            // p_skeleton_3d_keypoints
            if (hand.skeleton_3d_keypoints_count > 0 && hand.p_skeleton_3d_keypoints != NULL) {
                
                free(hand.p_skeleton_3d_keypoints);
                hand.p_skeleton_3d_keypoints = NULL;
            }
        }
        
        free((*src).p_hands);
        (*src).p_hands = NULL;
    }
    
    
    // free body
    if ((*src).body_count > 0) {
        
        for (int i = 0; i < (*src).body_count; i ++) {
            
            st_mobile_body_t body = (*src).p_bodys[i];
            
            // p_key_points & p_key_points_score
            if (   body.key_points_count > 0
                && body.p_key_points != NULL
                && body.p_key_points_score != NULL) {
                
                free(body.p_key_points);
                body.p_key_points = NULL;
                
                free(body.p_key_points_score);
                body.p_key_points_score = NULL;
            }
            
            
            // p_contour_points & p_contour_points_score
            if (   body.contour_points_count > 0
                && body.p_contour_points != NULL
                && body.p_contour_points_score != NULL) {
                
                free(body.p_contour_points);
                body.p_contour_points = NULL;
                
                free(body.p_contour_points_score);
                body.p_contour_points_score = NULL;
            }
        }
        
        free((*src).p_bodys);
        (*src).p_bodys = NULL;
    }
    
    
    // p_background
    if ((*src).p_background != NULL) {
        
        if ((*src).p_background[0].data != NULL) {
            
            free((*src).p_background[0].data);
            (*src).p_background[0].data = NULL;
        }
        
        free((*src).p_background);
        (*src).p_background = NULL;
    }
    
    // p_hair
    if ((*src).p_hair != NULL) {
        
        if ((*src).p_hair[0].data != NULL) {
            
            free((*src).p_hair[0].data);
            (*src).p_hair[0].data = NULL;
        }
        
        free((*src).p_hair);
        (*src).p_hair = NULL;
    }
    
    memset(src, 0, sizeof(st_mobile_human_action_t));
}

#pragma mark - SenseEffectsDelegate
- (void)updateCurrentAction:(unsigned long long)iAction {
    self.iCurrentAction = iAction;
}
#pragma mark - SenseBeautifyDelegate
- (void)updateEAGLContext {
    if ([EAGLContext currentContext] != self.glContext) {
        [EAGLContext setCurrentContext:self.glContext];
    }
}

- (UIDeviceOrientation)getDeviceOrientation:(CMAccelerometerData *)accelerometerData {
    
    UIDeviceOrientation deviceOrientation;
    
    if (accelerometerData.acceleration.x >= 0.75) {
        deviceOrientation = UIDeviceOrientationLandscapeRight;
    } else if (accelerometerData.acceleration.x <= -0.75) {
        deviceOrientation = UIDeviceOrientationLandscapeLeft;
    } else if (accelerometerData.acceleration.y <= -0.75) {
        deviceOrientation = UIDeviceOrientationPortrait;
    } else if (accelerometerData.acceleration.y >= 0.75) {
        deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
    } else {
        deviceOrientation = UIDeviceOrientationPortrait;
    }
    
    return deviceOrientation;
}
- (st_rotate_type)getRotateTypeWithDevicePosition:(AVCaptureDevicePosition)devicePosition videoMirrored:(BOOL)isVideoMirrored
{
    BOOL isFrontCamera = devicePosition == AVCaptureDevicePositionFront;
    
    UIDeviceOrientation deviceOrientation = [self getDeviceOrientation:self.motionManager.accelerometerData];
    
    switch (deviceOrientation) {
            
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

- (st_rotate_type)getSTMobileRotate {
    return _stMobileRotate;
}
@end
