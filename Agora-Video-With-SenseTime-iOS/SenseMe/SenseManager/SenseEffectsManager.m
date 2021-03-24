//
//  SenseEffectsManager.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/19.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseEffectsManager.h"
#import "STParamUtil.h"
#import "STCustomMemoryCache.h"
#import "STMobileLog.h"
#import "STEffectsAudioPlayer.h"
#import <OpenGLES/ES2/glext.h>

//ST_MOBILE
#import "st_mobile_sticker.h"
#import "st_mobile_animal.h"
#import "st_mobile_object.h"

@protocol STEffectsMessageDelegate <NSObject>

- (void)loadSound:(NSData *)soundData name:(NSString *)strName;
- (void)playSound:(NSString *)strName loop:(int)iLoop;
- (void)pauseSound:(NSString *)strName;
- (void)resumeSound:(NSString *)strName;
- (void)stopSound:(NSString *)strName;
- (void)unloadSound:(NSString *)strName;

@end

@interface STEffectsMessageManager : NSObject

@property (nonatomic, readwrite, weak) id<STEffectsMessageDelegate> delegate;
@end

@implementation STEffectsMessageManager

@end

STEffectsMessageManager *messageManager = nil;

@interface SenseEffectsManager()<STEffectsAudioPlayerDelegate, STEffectsMessageDelegate, STCommonObjectContainerViewDelegate> {
    
    st_handle_t _hSticker;  // sticker句柄
    st_handle_t _hTracker;  // 通用物体跟踪句柄
    st_handle_t _animalHandle; //猫脸
    
    st_rect_t _rect;  // 通用物体位置
    float _result_score; //通用物体置信度
    
    SenseEffectsModel _senseEffectsModel;
    
    st_mobile_animal_face_t *_detectResult1;
    st_mobile_animal_face_t *_newDetectResult1;
    int _faceCount;
    
    CVOpenGLESTextureRef _cvTextureSticker;
    CVPixelBufferRef _cvStickerBuffer;
    GLuint _textureStickerOutput;
}

@property (nonatomic, readwrite, strong) STEffectsAudioPlayer *audioPlayer;

@property (nonatomic) dispatch_queue_t thumbDownlaodQueue;
@property (nonatomic, strong) NSOperationQueue *imageLoadQueue;
@property (nonatomic , strong) NSFileManager *fManager;
@property (nonatomic , copy) NSString *strThumbnailPath;

@property (nonatomic, assign) BOOL needDetectAnimal;
@property (nonatomic, readwrite, assign) BOOL isNullSticker;
@property (nonatomic, readwrite, assign) BOOL bSticker;

@end


@implementation SenseEffectsManager

-(instancetype)init {
    if(self = [super init]){
        
        [self setDefaultValue];
        [self setupUtilTools];
        [self setupThumbnailCache];
        [self fetchLists];
        [self setupHandle];
    }
    return self;
}

- (void)initResultTextureWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight cvTextureCache:(CVOpenGLESTextureCacheRef)cvTextureCache {
    
    [self setupTextureWithPixelBuffer:&_cvStickerBuffer
                                    w:imageWidth
                                    h:imageHeight
                            glTexture:&_textureStickerOutput
                            cvTexture:&_cvTextureSticker
                         textureCache:cvTextureCache];
}

#pragma mark - setup DefaultValue
- (void)setDefaultValue {
    self.needDetectAnimal = NO;
    self.isNullSticker = NO;
    self.bTracker = NO;
    self.bSticker = NO;
    
    _faceCount = 0;
    _result_score = 0.0;
}

#pragma mark - setup UtilTools
- (void)setupUtilTools {
    self.audioPlayer = [[STEffectsAudioPlayer alloc] init];
    self.audioPlayer.delegate = self;
    
    messageManager = [[STEffectsMessageManager alloc] init];
    messageManager.delegate = self;
}

#pragma mark - setup handle
- (void)setupHandle {
    st_result_t iRet = ST_OK;
    
    //猫脸检测
    NSString *catFaceModel = [[NSBundle mainBundle] pathForResource:@"M_SenseME_CatFace_2.0.0" ofType:@"model"];
    
    TIMELOG(keyCat);
    
    iRet = st_mobile_tracker_animal_face_create(catFaceModel.UTF8String, ST_MOBILE_TRACKING_MULTI_THREAD, &_animalHandle);
    
    TIMEPRINT(keyCat, "cat handle create time:")
    
    if (iRet != ST_OK || !_animalHandle) {
        NSLog(@"st mobile tracker animal face create failed: %d", iRet);
    }

    
    //初始化贴纸模块句柄 , 默认开始时无贴纸 , 所以第一个路径参数传空
    TIMELOG(keySticker);
    
    iRet = st_mobile_sticker_create(&_hSticker);
    
    TIMEPRINT(keySticker, "sticker create time:");
    
    if (ST_OK != iRet || !_hSticker) {
        
        NSLog(@"st mobile sticker create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"贴纸SDK初始化失败 , SDK权限过期，或者与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    } else {
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_LOAD_FUNC_PTR, load_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set load sound func failed: %d", iRet);
        }
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_PLAY_FUNC_PTR, play_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set play sound func failed: %d", iRet);
        }
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_PAUSE_FUNC_PTR, pause_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set pause sound func failed: %d", iRet);
        }
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_RESUME_FUNC_PTR, resume_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set resume sound func failed: %d", iRet);
        }
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_STOP_FUNC_PTR, stop_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set stop sound func failed: %d", iRet);
        }
        
        iRet = st_mobile_sticker_set_param_ptr(_hSticker, -1, ST_STICKER_PARAM_SOUND_UNLOAD_FUNC_PTR, unload_sound);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set unload sound func failed: %d", iRet);
        }
    }
    
    // 初始化通用物体追踪句柄
    iRet = st_mobile_object_tracker_create(&_hTracker);
    
    if (ST_OK != iRet || !_hTracker) {
        
        NSLog(@"st mobile object tracker create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"通用物体跟踪SDK初始化失败，可能是SDK权限过期或与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)setupThumbnailCache
{
    self.thumbDownlaodQueue = dispatch_queue_create("com.sensetime.thumbDownloadQueue", NULL);
    self.imageLoadQueue = [[NSOperationQueue alloc] init];
    self.imageLoadQueue.maxConcurrentOperationCount = 20;
    
    self.thumbnailCache = [[STCustomMemoryCache alloc] init];
    self.fManager = [[NSFileManager alloc] init];
    
    // 可以根据实际情况实现素材列表缩略图的缓存策略 , 这里仅做演示 .
    self.strThumbnailPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"senseme_thumbnail"];
    
    NSError *error = nil;
    BOOL bCreateSucceed = [self.fManager createDirectoryAtPath:self.strThumbnailPath
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error];
    if (!bCreateSucceed || error) {
        
        STLog(@"create thumbnail cache directory failed !");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"创建列表图片缓存文件夹失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)fetchLists
{
    self.effectsDataSource = [[STCustomMemoryCache alloc] init];
    
    NSString *strLocalBundlePath = [[NSBundle mainBundle] pathForResource:@"my_sticker" ofType:@"bundle"];
    
    if (strLocalBundlePath) {
        
        NSMutableArray *arrLocalModels = [NSMutableArray array];
        
        NSFileManager *fManager = [[NSFileManager alloc] init];
        
        NSArray *arrFiles = [fManager contentsOfDirectoryAtPath:strLocalBundlePath error:nil];
        
        int indexOfItem = 0;
        for (NSString *strFileName in arrFiles) {
            
            if ([strFileName hasSuffix:@".zip"]) {
                
                NSString *strMaterialPath = [strLocalBundlePath stringByAppendingPathComponent:strFileName];
                NSString *strThumbPath = [[strMaterialPath stringByDeletingPathExtension] stringByAppendingString:@".png"];
                UIImage *imageThumb = [UIImage imageWithContentsOfFile:strThumbPath];
                
                if (!imageThumb) {
                    
                    imageThumb = [UIImage imageNamed:@"none"];
                }
                
                EffectsCollectionViewCellModel *model = [[EffectsCollectionViewCellModel alloc] init];
                
                model.iEffetsType = STEffectsTypeStickerMy;
                model.state = Downloaded;
                model.indexOfItem = indexOfItem;
                model.imageThumb = imageThumb;
                model.strMaterialPath = strMaterialPath;
                
                [arrLocalModels addObject:model];
                
                indexOfItem ++;
            }
        }
        
        NSString *strDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *localStickerPath = [strDocumentsPath stringByAppendingPathComponent:@"local_sticker"];
        if (![fManager fileExistsAtPath:localStickerPath]) {
            [fManager createDirectoryAtPath:localStickerPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSArray *arrFileNames = [fManager contentsOfDirectoryAtPath:localStickerPath error:nil];
        
        for (NSString *strFileName in arrFileNames) {
            
            if ([strFileName hasSuffix:@"zip"]) {
                
                NSString *strMaterialPath = [localStickerPath stringByAppendingPathComponent:strFileName];
                NSString *strThumbPath = [[strMaterialPath stringByDeletingPathExtension] stringByAppendingString:@".png"];
                UIImage *imageThumb = [UIImage imageWithContentsOfFile:strThumbPath];
                
                if (!imageThumb) {
                    
                    imageThumb = [UIImage imageNamed:@"none"];
                }
                
                EffectsCollectionViewCellModel *model = [[EffectsCollectionViewCellModel alloc] init];
                
                model.iEffetsType = STEffectsTypeStickerMy;
                model.state = Downloaded;
                model.indexOfItem = indexOfItem;
                model.imageThumb = imageThumb;
                model.strMaterialPath = strMaterialPath;
                
                [arrLocalModels addObject:model];
                
                indexOfItem ++;
            }
        }
        
        [self.effectsDataSource setObject:arrLocalModels
                                   forKey:@(STEffectsTypeStickerMy)];
    }
}

- (void)cacheThumbnailOfModel:(EffectsCollectionViewCellModel *)model
{
}

- (void)setMaterialModel:(EffectsCollectionViewCellModel *)targetModel triggerSuccessBlock:(nullable void(^)(NSString *contentText, NSString *imageName))successBlock triggerFailBlock:(nullable void(^)(void))failBlock
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NoticeUpdatePauseOutput object:@(YES)];

    self.bSticker = YES;
    
    const char *stickerPath = [targetModel.strMaterialPath UTF8String];
    
    if (!targetModel || IsSelected == targetModel.state) {
        stickerPath = NULL;
    }
    
    for (NSArray *arrModels in [self.effectsDataSource allValues]) {
        
        for (EffectsCollectionViewCellModel *model in arrModels) {
            
            if (model == targetModel) {
                
                if (IsSelected == model.state) {
                    
                    model.state = Downloaded;
                }else{
                    
                    model.state = IsSelected;
                }
            }else{
                
                if (IsSelected == model.state) {
                    
                    model.state = Downloaded;
                }
            }
        }
    }

    if (self.isNullSticker) {
        self.isNullSticker = NO;
    }
    
    // 获取触发动作类型
    unsigned long long iAction = 0;
    
    st_result_t iRet = ST_OK;
    iRet = st_mobile_sticker_change_package(_hSticker, stickerPath, NULL);
    
    if (iRet != ST_OK && iRet != ST_E_PACKAGE_EXIST_IN_MEMORY) {
        failBlock();
        STLog(@"st_mobile_sticker_change_package error %d" , iRet);
    } else {
        
        // 需要在 st_mobile_sticker_change_package 之后调用才可以获取新素材包的 trigger action .
        iRet = st_mobile_sticker_get_trigger_action(_hSticker, &iAction);
        
        if (ST_OK != iRet) {
            
            STLog(@"st_mobile_sticker_get_trigger_action error %d" , iRet);
            
            return;
        }
        
        NSString *triggerContent = @"";
        NSString *imageName = @"";
        
        if (0 != iAction) {//有 trigger信息
            
            if (CHECK_FLAG(iAction, ST_MOBILE_BROW_JUMP)) {
                triggerContent = [NSString stringWithFormat:@"%@请挑挑眉~", triggerContent];
                imageName = @"head_brow_jump";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_EYE_BLINK)) {
                triggerContent = [NSString stringWithFormat:@"%@请眨眨眼~", triggerContent];
                imageName = @"eye_blink";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HEAD_YAW)) {
                triggerContent = [NSString stringWithFormat:@"%@请摇摇头~", triggerContent];
                imageName = @"head_yaw";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HEAD_PITCH)) {
                triggerContent = [NSString stringWithFormat:@"%@请点点头~", triggerContent];
                imageName = @"head_pitch";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_MOUTH_AH)) {
                triggerContent = [NSString stringWithFormat:@"%@请张张嘴~", triggerContent];
                imageName = @"mouth_ah";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_GOOD)) {
                triggerContent = [NSString stringWithFormat:@"%@请比个赞~", triggerContent];
                imageName = @"hand_good";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_PALM)) {
                triggerContent = [NSString stringWithFormat:@"%@请伸手掌~", triggerContent];
                imageName = @"hand_palm";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_LOVE)) {
                triggerContent = [NSString stringWithFormat:@"%@请双手比心~", triggerContent];
                imageName = @"hand_love";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_HOLDUP)) {
                triggerContent = [NSString stringWithFormat:@"%@请托个手~", triggerContent];
                imageName = @"hand_holdup";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_CONGRATULATE)) {
                triggerContent = [NSString stringWithFormat:@"%@请抱个拳~", triggerContent];
                imageName = @"hand_congratulate";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FINGER_HEART)) {
                triggerContent = [NSString stringWithFormat:@"%@请单手比心~", triggerContent];
                imageName = @"hand_finger_heart";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FINGER_INDEX)) {
                triggerContent = [NSString stringWithFormat:@"%@请伸出食指~", triggerContent];
                imageName = @"hand_finger";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_OK)) {
                triggerContent = [NSString stringWithFormat:@"%@请亮出OK手势~", triggerContent];
                imageName = @"hand_ok";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_SCISSOR)) {
                triggerContent = [NSString stringWithFormat:@"%@请比个剪刀手~", triggerContent];
                imageName = @"hand_victory";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_PISTOL)) {
                triggerContent = [NSString stringWithFormat:@"%@请比个手枪~", triggerContent];
                imageName = @"hand_gun";
            }
            
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_666)) {
                triggerContent = [NSString stringWithFormat:@"%@请亮出666手势~", triggerContent];
                imageName = @"666_selected";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_BLESS)) {
                triggerContent = [NSString stringWithFormat:@"%@请双手合十~", triggerContent];
                imageName = @"bless_selected";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_ILOVEYOU)) {
                triggerContent = [NSString stringWithFormat:@"%@请亮出我爱你手势~", triggerContent];
                imageName = @"love_selected";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_HAND_FIST)) {
                triggerContent = [NSString stringWithFormat:@"%@请举起拳头~", triggerContent];
                imageName = @"fist_selected";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_FACE_LIPS_POUTED)) {
                triggerContent = [NSString stringWithFormat:@"%@请嘟嘴~", triggerContent];
                imageName = @"FACE_LIPS_POUTED";
            }
            if (CHECK_FLAG(iAction, ST_MOBILE_FACE_LIPS_UPWARD)) {
                triggerContent = [NSString stringWithFormat:@"%@请笑一笑~", triggerContent];
                imageName = @"FACE_LIPS_UPWARD";
            }
        }
        successBlock(triggerContent, imageName);
        
        //猫脸config
        unsigned long long animalConfig = 0;
        iRet = st_mobile_sticker_get_animal_detect_config(_hSticker, &animalConfig);
        if (iRet == ST_OK && animalConfig == ST_MOBILE_CAT_DETECT) {
            _needDetectAnimal = YES;
        } else {
            _needDetectAnimal = NO;
        }
    }
    
    [self.senseEffectsDelegate updateCurrentAction:iAction];
    [[NSNotificationCenter defaultCenter]postNotificationName:NoticeUpdatePauseOutput object:@(NO)];
}

#pragma mark - scroll title click events
- (void)cancelStickerAndObjectTrack {
    if (_hSticker) {
        self.isNullSticker = YES;
    }

    self.bTracker = NO;
}

- (CVPixelBufferRef)captureOutputSenseEffectsModel:(SenseEffectsModel)model textureResult:(GLuint*)textureResult pixelBufffer:(CVPixelBufferRef)pixelBufffer {
    
    _senseEffectsModel = model;
    
    st_result_t iRet = ST_OK;

    CGFloat _scale = _senseEffectsModel.scale;
    int _margin = _senseEffectsModel.margin;

    unsigned char* pBGRAImageIn = _senseEffectsModel.pBGRAImageIn;
    
    ///ST_MOBILE 以下为通用物体跟踪部分
    if (_bTracker && _hTracker) {

        if (self.isCommonObjectViewAdded) {

            if (!self.isCommonObjectViewSetted) {

                iRet = st_mobile_object_tracker_set_target(_hTracker, pBGRAImageIn, ST_PIX_FMT_BGRA8888, _senseEffectsModel.iWidth, _senseEffectsModel.iHeight, _senseEffectsModel.iBytesPerRow, &_rect);

                if (iRet != ST_OK) {
                    NSLog(@"st mobile object tracker set target failed: %d", iRet);
                    _rect.left = 0;
                    _rect.top = 0;
                    _rect.right = 0;
                    _rect.bottom = 0;
                } else {
                    self.commonObjectViewSetted = YES;
                }
            }

            if (self.isCommonObjectViewSetted) {

                TIMELOG(keyTracker);
                iRet = st_mobile_object_tracker_track(_hTracker, pBGRAImageIn, ST_PIX_FMT_BGRA8888, _senseEffectsModel.iWidth, _senseEffectsModel.iHeight, _senseEffectsModel.iBytesPerRow, &_rect, &_result_score);
                //                NSLog(@"tracking, result_score: %f,rect.left: %d, rect.top: %d, rect.right: %d, rect.bottom: %d", _result_score, _rect.left, _rect.top, _rect.right, _rect.bottom);
                TIMEPRINT(keyTracker, "st_mobile_object_tracker_track time:");

                if (iRet != ST_OK) {

                    NSLog(@"st mobile object tracker track failed: %d", iRet);
                    _rect.left = 0;
                    _rect.top = 0;
                    _rect.right = 0;
                    _rect.bottom = 0;
                }

                CGRect rectDisplay = CGRectMake(_rect.left * _scale - _margin,
                                                _rect.top * _scale,
                                                _rect.right * _scale - _rect.left * _scale,
                                                _rect.bottom * _scale - _rect.top * _scale);
                CGPoint center = CGPointMake(rectDisplay.origin.x + rectDisplay.size.width / 2,
                                             rectDisplay.origin.y + rectDisplay.size.height / 2);
                
                __block st_rect_t trackRect = _rect;
                dispatch_async(dispatch_get_main_queue(), ^{

                    if(self.onTrackBlock != nil){
                        self.onTrackBlock(trackRect, center);
                    }
                });
            }
        }
    }


    int catFaceCount = -1;
    ///cat face
    if (_needDetectAnimal && _animalHandle) {

        st_result_t iRet = st_mobile_tracker_animal_face_track(_animalHandle, pBGRAImageIn, ST_PIX_FMT_BGRA8888, _senseEffectsModel.iWidth, _senseEffectsModel.iHeight, _senseEffectsModel.iBytesPerRow, _senseEffectsModel.stMobileRotate, &_detectResult1, &catFaceCount);

        if (iRet != ST_OK) {
            NSLog(@"st mobile animal face tracker failed: %d", iRet);
        } else {
//            NSLog(@"cat face count: %d", catFaceCount);
        }
    }
    
    _faceCount = catFaceCount;
    if (_faceCount > 0) {
        _newDetectResult1 = malloc(sizeof(st_mobile_animal_face_t) * _faceCount);
        memset(_newDetectResult1, 0, sizeof(st_mobile_animal_face_t) * _faceCount);
        copyCatFace(_detectResult1, _faceCount, _newDetectResult1);
    }

    ///ST_MOBILE 以下为贴纸部分
    if (_bSticker && _hSticker) {
        
        TIMELOG(stickerProcessKey);
    
        st_mobile_input_params_t inputEvent;
        memset(&inputEvent, 0, sizeof(st_mobile_input_params_t));
        
        int type = ST_INPUT_PARAM_NONE;
        iRet = st_mobile_sticker_get_needed_input_params(_hSticker, &type);
        
        if (CHECK_FLAG(type, ST_INPUT_PARAM_CAMERA_QUATERNION)) {
            
            CMQuaternion quaternion = _senseEffectsModel.quaternion;
            inputEvent.camera_quaternion[0] = quaternion.x;
            inputEvent.camera_quaternion[1] = quaternion.y;
            inputEvent.camera_quaternion[2] = quaternion.z;
            inputEvent.camera_quaternion[3] = quaternion.w;
            
            if (_senseEffectsModel.devicePosition == AVCaptureDevicePositionBack) {
                inputEvent.is_front_camera = false;
            } else {
                inputEvent.is_front_camera = true;
            }
        } else {
            
            inputEvent.camera_quaternion[0] = 0;
            inputEvent.camera_quaternion[1] = 0;
            inputEvent.camera_quaternion[2] = 0;
            inputEvent.camera_quaternion[3] = 1;
        }
    
        iRet = st_mobile_sticker_process_texture_both(_hSticker, *textureResult, _senseEffectsModel.iWidth, _senseEffectsModel.iHeight, _senseEffectsModel.stMobileRotate, ST_CLOCKWISE_ROTATE_0, false, &_senseEffectsModel.newDetectResult, &inputEvent, _newDetectResult1, _faceCount, _textureStickerOutput);

        *textureResult = _textureStickerOutput;
        pixelBufffer = _cvStickerBuffer;

        TIMEPRINT(stickerProcessKey, "st_mobile_sticker_process_texture time:");
        
        if (ST_OK != iRet) {
            
            STLog(@"st_mobile_sticker_process_texture %d" , iRet);
            
        }
    }

    if (self.isNullSticker && _hSticker) {
        iRet = st_mobile_sticker_change_package(_hSticker, NULL, NULL);
        
        if (ST_OK != iRet) {
            NSLog(@"st_mobile_sticker_change_package error %d", iRet);
        }
    }
    
    return pixelBufffer;
}

#pragma mark - release
- (void)releaseResultTexture {
     _textureStickerOutput = 0;
    
    if (_cvTextureSticker) {
        CFRelease(_cvTextureSticker);
        _cvTextureSticker = NULL;
    }
    
    if (_cvStickerBuffer) {
        CVPixelBufferRelease(_cvStickerBuffer);
        _cvStickerBuffer = NULL;
    }
}

- (void)releaseResources {
    _result_score = 0.0;
    
    if (_hSticker) {
        st_mobile_sticker_destroy(_hSticker);
        _hSticker = NULL;
    }
    
    if (_animalHandle) {
        st_mobile_tracker_animal_face_destroy(_animalHandle);
        _animalHandle = NULL;
    }
    
    if (_hTracker) {
        st_mobile_object_tracker_destroy(_hTracker);
        _hTracker = NULL;
    }
}

#pragma mark - sound
void load_sound(void* handle, void* sound, const char* sound_name, int length) {
    
    //    NSLog(@"STEffectsAudioPlayer load sound");
    
    if ([messageManager.delegate respondsToSelector:@selector(loadSound:name:)]) {
        
        NSData *soundData = [NSData dataWithBytes:sound length:length];
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        
        [messageManager.delegate loadSound:soundData name:strName];
    }
}

void play_sound(void* handle, const char* sound_name, int loop) {
    
    //    NSLog(@"STEffectsAudioPlayer play sound");
    
    if ([messageManager.delegate respondsToSelector:@selector(playSound:loop:)]) {
        
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        
        [messageManager.delegate playSound:strName loop:loop];
    }
}

void pause_sound(void *handle, const char *sound_name) {
    if ([messageManager.delegate respondsToSelector:@selector(pauseSound:)]) {
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        [messageManager.delegate pauseSound:strName];
    }
}

void resume_sound(void *handle, const char *sound_name) {
    if ([messageManager.delegate respondsToSelector:@selector(resumeSound:)]) {
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        [messageManager.delegate resumeSound:strName];
    }
}

void stop_sound(void* handle, const char* sound_name) {
    
    //    NSLog(@"STEffectsAudioPlayer stop sound");
    if ([messageManager.delegate respondsToSelector:@selector(stopSound:)]) {
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        [messageManager.delegate stopSound:strName];
    }
}

void unload_sound(void *handle, const char *sound_name) {
    if ([messageManager.delegate respondsToSelector:@selector(unloadSound:)]) {
        NSString *strName = [NSString stringWithUTF8String:sound_name];
        [messageManager.delegate unloadSound:strName];
    }
}

#pragma mark - STEffectsMessageManagerDelegate

- (void)loadSound:(NSData *)soundData name:(NSString *)strName {
    
    if ([self.audioPlayer loadSound:soundData name:strName]) {
        NSLog(@"STEffectsAudioPlayer load %@ successfully", strName);
    }
}

- (void)playSound:(NSString *)strName loop:(int)iLoop {
    
    if ([self.audioPlayer playSound:strName loop:iLoop]) {
        NSLog(@"STEffectsAudioPlayer play %@ successfully", strName);
    }
}

- (void)pauseSound:(NSString *)strName {
    [self.audioPlayer pauseSound:strName];
}

- (void)resumeSound:(NSString *)strName {
    [self.audioPlayer resumeSound:strName];
}

- (void)stopSound:(NSString *)strName {
    
    [self.audioPlayer stopSound:strName];
}

- (void)unloadSound:(NSString *)strName {
    [self.audioPlayer unloadSound:strName];
}

#pragma mark - STEffectsAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(STEffectsAudioPlayer *)player successfully:(BOOL)flag name:(NSString *)strName {
    
    if (_hSticker) {
        st_result_t iRet = ST_OK;
        iRet = st_mobile_sticker_set_param_str(_hSticker, -1, ST_STICKER_PARAM_SOUND_COMPLETED_STR, strName.UTF8String);
        if (iRet != ST_OK) {
            NSLog(@"st mobile set sound complete str failed: %d", iRet);
        }
    }
}

void copyCatFace(st_mobile_animal_face_t *src, int faceCount, st_mobile_animal_face_t *dst) {
    memcpy(dst, src, sizeof(st_mobile_animal_face_t) * faceCount);
    for (int i = 0; i < faceCount; ++i) {
        
        size_t key_points_size = sizeof(st_pointf_t) * src[i].key_points_count;
        st_pointf_t *p_key_points = malloc(key_points_size);
        memset(p_key_points, 0, key_points_size);
        memcpy(p_key_points, src[i].p_key_points, key_points_size);
        
        dst[i].p_key_points = p_key_points;
    }
}

- (void)freeCatFace {
    if (_faceCount > 0) {
        for (int i = 0; i < _faceCount; ++i) {
            if (_newDetectResult1[i].p_key_points != NULL) {
                free(_newDetectResult1[i].p_key_points);
                _newDetectResult1[i].p_key_points = NULL;
            }
        }
        free(_newDetectResult1);
        _newDetectResult1 = NULL;
    }
}

- (BOOL)setupTextureWithPixelBuffer:(CVPixelBufferRef *)pixelBufferOut
                                  w:(int)iWidth
                                  h:(int)iHeight
                          glTexture:(GLuint *)glTexture
                          cvTexture:(CVOpenGLESTextureRef *)cvTexture
                        textureCache:(CVOpenGLESTextureCacheRef)cvTextureCache {
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault,
                                               NULL,
                                               NULL,
                                               0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks);
    
    CFMutableDictionaryRef attrs = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                             1,
                                                             &kCFTypeDictionaryKeyCallBacks,
                                                             &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(attrs, kCVPixelBufferIOSurfacePropertiesKey, empty);
    
    CVReturn cvRet = CVPixelBufferCreate(kCFAllocatorDefault,
                                         iWidth,
                                         iHeight,
                                         kCVPixelFormatType_32BGRA,
                                         attrs,
                                         pixelBufferOut);
    
    if (kCVReturnSuccess != cvRet) {
        
        NSLog(@"CVPixelBufferCreate %d" , cvRet);
    }
    
    cvRet = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                         cvTextureCache,
                                                         *pixelBufferOut,
                                                         NULL,
                                                         GL_TEXTURE_2D,
                                                         GL_RGBA,
                                                         iWidth,
                                                         iHeight,
                                                         GL_BGRA,
                                                         GL_UNSIGNED_BYTE,
                                                         0,
                                                         cvTexture);
    
    CFRelease(attrs);
    CFRelease(empty);
    
    if (kCVReturnSuccess != cvRet) {
        
        NSLog(@"EffectTexture CVOpenGLESTextureCacheCreateTextureFromImage %d" , cvRet);
        
        return NO;
    }
    
    *glTexture = CVOpenGLESTextureGetName(*cvTexture);
    glBindTexture(CVOpenGLESTextureGetTarget(*cvTexture), *glTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    return YES;
}

- (void)resetTrackingFrame:(CGRect)frame {
    CGFloat _scale = _senseEffectsModel.scale;
    int _margin = _senseEffectsModel.margin;
    
    CGRect rect = frame;
    _rect.left = (rect.origin.x + _margin) / _scale;
    _rect.top = rect.origin.y / _scale;
    _rect.right = (rect.origin.x + rect.size.width + _margin) / _scale;
    _rect.bottom = (rect.origin.y + rect.size.height) / _scale;
}

- (void)dealloc {
    messageManager = nil;
    [self releaseResources];
    [self releaseResultTexture];
}
@end
