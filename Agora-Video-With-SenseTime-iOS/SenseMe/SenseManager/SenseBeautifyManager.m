//
//  SenseBeautifyManager.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/19.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseBeautifyManager.h"
#import "st_mobile_common.h"
#import "STBMPCollectionView.h"
#import "STBeautySlider.h"
#import "STBmpStrengthView.h"
#import "STScrollTitleView.h"
#import "STCollectionView.h"
#import "STViewButton.h"
#import "STMobileLog.h"
#import "STFilterView.h"
#import <OpenGLES/ES2/glext.h>

//ST_MOBILE
#import "st_mobile_beautify.h"
#import "st_mobile_filter.h"
#import "st_mobile_makeup.h"

@interface SenseBeautifyManager () {
    
    st_handle_t _hBeautify; // beautify句柄
    st_handle_t _hFilter;   // filter句柄
    st_handle_t _hBmpHandle; // 美妆

    CVOpenGLESTextureRef _cvTextureBeautify;
    CVOpenGLESTextureRef _cvTextureFilter;
    CVOpenGLESTextureRef _cvTextureMakeup;
    
    CVPixelBufferRef _cvBeautifyBuffer;
    CVPixelBufferRef _cvFilterBuffer;
    CVPixelBufferRef _cvMakeUpBuffer;
    
    GLuint _textureBeautifyOutput;
    GLuint _textureFilterOutput;
    GLuint _textureMakeUpOutput;
    
    SenseBeautifyModel _senseBeautifyModel;
}

@property (nonatomic, assign) BOOL bMakeUp;
@property (nonatomic, readwrite, assign) BOOL bBeauty;
@property (nonatomic, readwrite, assign) BOOL bFilter;

//beauty value
@property (nonatomic, assign) float fWhitenStrength;
@property (nonatomic, assign) float fReddenStrength;
@property (nonatomic, assign) float fSmoothStrength;
@property (nonatomic, assign) float fDehighlightStrength;
@property (nonatomic, assign) float fShrinkFaceStrength;
@property (nonatomic, assign) float fNarrowFaceStrength;
@property (nonatomic, assign) float fEnlargeEyeStrength;
@property (nonatomic, assign) float fShrinkJawStrength;
@property (nonatomic, assign) float fThinFaceShapeStrength;
@property (nonatomic, assign) float fChinStrength;
@property (nonatomic, assign) float fHairLineStrength;
@property (nonatomic, assign) float fNarrowNoseStrength;
@property (nonatomic, assign) float fLongNoseStrength;
@property (nonatomic, assign) float fMouthStrength;
@property (nonatomic, assign) float fPhiltrumStrength;
@property (nonatomic, assign) float fContrastStrength;
@property (nonatomic, assign) float fSaturationStrength;
@property (nonatomic, assign) float fAppleMusleStrength;
@property (nonatomic, assign) float fProfileRhinoplastyStrength;
@property (nonatomic, assign) float fBrightEyeStrength;
@property (nonatomic, assign) float fRemoveDarkCirclesStrength;
@property (nonatomic, assign) float fWhiteTeethStrength;
@property (nonatomic, assign) float fEyeDistanceStrength;
@property (nonatomic, assign) float fEyeAngleStrength;
@property (nonatomic, assign) float fOpenCanthusStrength;
@property (nonatomic, assign) float fRemoveNasolabialFoldsStrength;

@property (nonatomic, copy) NSString *preFilterModelPath;
@property (nonatomic, copy) NSString *curFilterModelPath;

@property (nonatomic, readwrite, assign) BOOL filterStrengthViewHiddenState;

//beauty make up
@property (nonatomic, strong) STBMPModel *bmp_Current_Model;
@property (nonatomic, strong) STBMPModel *bmp_Eye_Model;
@property (nonatomic, strong) STBMPModel *bmp_EyeLiner_Model;
@property (nonatomic, strong) STBMPModel *bmp_EyeLash_Model;
@property (nonatomic, strong) STBMPModel *bmp_Lip_Model;
@property (nonatomic, strong) STBMPModel *bmp_Brow_Model;
@property (nonatomic, strong) STBMPModel *bmp_Nose_Model;
@property (nonatomic, strong) STBMPModel *bmp_Face_Model;
@property (nonatomic, strong) STBMPModel *bmp_Blush_Model;

@property (nonatomic, assign) float bmp_Eye_Value;
@property (nonatomic, assign) float bmp_EyeLiner_Value;
@property (nonatomic, assign) float bmp_EyeLash_Value;
@property (nonatomic, assign) float bmp_Lip_Value;
@property (nonatomic, assign) float bmp_Brow_Value;
@property (nonatomic, assign) float bmp_Nose_Value;
@property (nonatomic, assign) float bmp_Face_Value;
@property (nonatomic, assign) float bmp_Blush_Value;

@end

@implementation SenseBeautifyManager
- (instancetype)init {
    if(self = [super init]) {
        [self setDefaultValue];
        [self initBeautyValues];
        [self setupHandle];
    }
    return self;
}

- (void)initResultTextureWithWidth:(CGFloat)imageWidth height:(CGFloat)imageHeight cvTextureCache:(CVOpenGLESTextureCacheRef)textureCache {

    [self setupTextureWithPixelBuffer:&_cvBeautifyBuffer
                                    w:imageWidth
                                    h:imageHeight
                            glTexture:&_textureBeautifyOutput
                            cvTexture:&_cvTextureBeautify
                         textureCache:textureCache];
    
    [self setupTextureWithPixelBuffer:&_cvMakeUpBuffer
                                    w:imageWidth
                                    h:imageHeight
                            glTexture:&_textureMakeUpOutput
                            cvTexture:&_cvTextureMakeup
                         textureCache:textureCache];
    
    [self setupTextureWithPixelBuffer:&_cvFilterBuffer
                                    w:imageWidth
                                    h:imageHeight
                            glTexture:&_textureFilterOutput
                            cvTexture:&_cvTextureFilter
                         textureCache:textureCache];
}

- (void)setupHandle {
    
    st_result_t iRet = ST_OK;
    
    //初始化美颜模块句柄
    iRet = st_mobile_beautify_create(&_hBeautify);
    
    if (ST_OK != iRet || !_hBeautify) {
        
        NSLog(@"st mobile beautify create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"美颜SDK初始化失败，可能是模型路径错误，SDK权限过期，与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }else{

        // 设置默认红润参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_REDDEN_STRENGTH, self.fReddenStrength);
        // 设置默认磨皮参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_SMOOTH_STRENGTH, self.fSmoothStrength);
        // 设置默认大眼参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_ENLARGE_EYE_RATIO, self.fEnlargeEyeStrength);
        // 设置默认瘦脸参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_SHRINK_FACE_RATIO, self.fShrinkFaceStrength);
        // 设置小脸参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_SHRINK_JAW_RATIO, self.fShrinkJawStrength);
        // 设置美白参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_WHITEN_STRENGTH, self.fWhitenStrength);
        //设置对比度参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_CONTRAST_STRENGTH, self.fContrastStrength);
        //设置饱和度参数
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_SATURATION_STRENGTH, self.fSaturationStrength);
        //瘦脸型
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO, self.fThinFaceShapeStrength);
        //窄脸
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_NARROW_FACE_STRENGTH, self.fNarrowFaceStrength);
        //下巴
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_CHIN_LENGTH_RATIO, self.fChinStrength);
        //额头
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_HAIRLINE_HEIGHT_RATIO, self.fHairLineStrength);
        //瘦鼻翼
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_NARROW_NOSE_RATIO, self.fNarrowNoseStrength);
        //长鼻
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO, self.fLongNoseStrength);
        //嘴形
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_MOUTH_SIZE_RATIO, self.fMouthStrength);
        //缩人中
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_PHILTRUM_LENGTH_RATIO, self.fPhiltrumStrength);
        
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_APPLE_MUSLE_RATIO, self.fAppleMusleStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_PROFILE_RHINOPLASTY_RATIO, self.fProfileRhinoplastyStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_EYE_DISTANCE_RATIO, self.fEyeDistanceStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_EYE_ANGLE_RATIO, self.fEyeAngleStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_OPEN_CANTHUS_RATIO, self.fOpenCanthusStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_BRIGHT_EYE_RATIO, self.fBrightEyeStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_REMOVE_DARK_CIRCLES_RATIO, self.fRemoveDarkCirclesStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_REMOVE_NASOLABIAL_FOLDS_RATIO, self.fRemoveNasolabialFoldsStrength);
        setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_WHITE_TEETH_RATIO, self.fWhiteTeethStrength);
    }
    
    // 初始化滤镜句柄
    iRet = st_mobile_gl_filter_create(&_hFilter);
    
    if (ST_OK != iRet || !_hFilter) {
        
        NSLog(@"st mobile gl filter create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"滤镜SDK初始化失败，可能是SDK权限过期或与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    //create beautyMakeUp handle
    iRet = st_mobile_makeup_create(&_hBmpHandle);
    
    if (ST_OK != iRet || !_hBmpHandle) {
        
        NSLog(@"st mobile object makeup create failed: %d", iRet);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"通用物体跟踪SDK初始化失败，可能是SDK权限过期或与绑定包名不符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

- (void)releaseResources {
    
    if (_hBeautify) {
        
        st_mobile_beautify_destroy(_hBeautify);
        _hBeautify = NULL;
    }
    
    if (_hBmpHandle) {
        st_mobile_makeup_destroy(_hBmpHandle);
        _hBmpHandle = NULL;
    }
    
    if (_hFilter) {
        
        st_mobile_gl_filter_destroy(_hFilter);
        _hFilter = NULL;
    }
}

- (CVPixelBufferRef)captureOutputSenseBeautifyModel:(SenseBeautifyModel)model textureResult:(GLuint*)textureResult pixelBufffer:(CVPixelBufferRef)pixelBufffer {
    
    st_result_t iRet = ST_OK;
    
    _senseBeautifyModel = model;
    
    if (model.isTextureOriginReady) {
        ///ST_MOBILE 以下为美颜部分
        if (_bBeauty && _hBeautify) {
            
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_SHRINK_FACE_RATIO, self.fShrinkFaceStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_ENLARGE_EYE_RATIO, self.fEnlargeEyeStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_SHRINK_JAW_RATIO, self.fShrinkJawStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_SMOOTH_STRENGTH, self.fSmoothStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_REDDEN_STRENGTH, self.fReddenStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_WHITEN_STRENGTH, self.fWhitenStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_CONTRAST_STRENGTH, self.fContrastStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_SATURATION_STRENGTH, self.fSaturationStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_NARROW_FACE_STRENGTH, self.fNarrowFaceStrength);
            
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_THIN_FACE_SHAPE_RATIO, self.fThinFaceShapeStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_CHIN_LENGTH_RATIO, self.fChinStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_HAIRLINE_HEIGHT_RATIO, self.fHairLineStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_NARROW_NOSE_RATIO, self.fNarrowNoseStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_NOSE_LENGTH_RATIO, self.fLongNoseStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_MOUTH_SIZE_RATIO, self.fMouthStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_PHILTRUM_LENGTH_RATIO, self.fPhiltrumStrength);
            
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_APPLE_MUSLE_RATIO, self.fAppleMusleStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_PROFILE_RHINOPLASTY_RATIO, self.fProfileRhinoplastyStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_EYE_DISTANCE_RATIO, self.fEyeDistanceStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_EYE_ANGLE_RATIO, self.fEyeAngleStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_OPEN_CANTHUS_RATIO, self.fOpenCanthusStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_BRIGHT_EYE_RATIO, self.fBrightEyeStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_REMOVE_DARK_CIRCLES_RATIO, self.fRemoveDarkCirclesStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_REMOVE_NASOLABIAL_FOLDS_RATIO, self.fRemoveNasolabialFoldsStrength);
            setBeautifyParam(_hBeautify, ST_BEAUTIFY_3D_WHITE_TEETH_RATIO, self.fWhiteTeethStrength);
            
            TIMELOG(keyBeautify);

            iRet = st_mobile_beautify_process_texture(_hBeautify, model.textureOriginInput, _senseBeautifyModel.iWidth, _senseBeautifyModel.iHeight, _senseBeautifyModel.stMobileRotate, &_senseBeautifyModel.newDetectResult, _textureBeautifyOutput, &_senseBeautifyModel.newDetectResult);
        
            TIMEPRINT(keyBeautify, "st_mobile_beautify_process_texture time:");
            if (ST_OK != iRet) {

                STLog(@"st_mobile_beautify_process_texture failed %d" , iRet);

            } else {
                *textureResult = _textureBeautifyOutput;
                pixelBufffer = _cvBeautifyBuffer;
            }
        }
    }
    
//    //makeup
    if (_hBmpHandle) {
        iRet = st_mobile_makeup_process_texture(_hBmpHandle, *textureResult, _senseBeautifyModel.iWidth, _senseBeautifyModel.iHeight, _senseBeautifyModel.stMobileRotate, &_senseBeautifyModel.newDetectResult, _textureMakeUpOutput);
        if (iRet != ST_OK) {
            NSLog(@"st_mobile_makeup_process_texture failed: %d", iRet);
        } else {
            *textureResult = _textureMakeUpOutput;
            pixelBufffer = _cvMakeUpBuffer;
        }
    }

    ///ST_MOBILE 以下为滤镜部分
    if (_bFilter && _hFilter) {

        if (self.curFilterModelPath != self.preFilterModelPath) {
            iRet = st_mobile_gl_filter_set_style(_hFilter, self.curFilterModelPath.UTF8String);
            if (iRet != ST_OK) {
                NSLog(@"st mobile filter set style failed: %d", iRet);
            }
            self.preFilterModelPath = self.curFilterModelPath;
        }

        TIMELOG(keyFilter);

        iRet = st_mobile_gl_filter_process_texture(_hFilter, *textureResult, _senseBeautifyModel.iWidth, _senseBeautifyModel.iHeight, _textureFilterOutput);

        TIMEPRINT(keyFilter, "st_mobile_gl_filter_process_texture time:");

        if (ST_OK != iRet) {
            STLog(@"st_mobile_gl_filter_process_texture %d" , iRet);
        }

        *textureResult = _textureFilterOutput;
        pixelBufffer = _cvFilterBuffer;
    }
    
    return pixelBufffer;
}

-(void)releaseResultTexture {
    
    _textureBeautifyOutput = 0;
    _textureFilterOutput = 0;
    _textureMakeUpOutput = 0;
    
    if (_cvTextureBeautify) {
        CFRelease(_cvTextureBeautify);
        _cvTextureBeautify = NULL;
    }
    if (_cvTextureFilter) {
        CFRelease(_cvTextureFilter);
        _cvTextureFilter = NULL;
    }
    if (_cvTextureMakeup) {
        CFRelease(_cvTextureMakeup);
        _cvTextureMakeup = NULL;
    }
    
    if (_cvBeautifyBuffer) {
        CVPixelBufferRelease(_cvBeautifyBuffer);
        _cvBeautifyBuffer = NULL;
    }
    if (_cvFilterBuffer) {
        CVPixelBufferRelease(_cvFilterBuffer);
        _cvFilterBuffer = NULL;
    }
    if (_cvMakeUpBuffer) {
        CVPixelBufferRelease(_cvMakeUpBuffer);
        _cvMakeUpBuffer = NULL;
    }
}

- (void)initBeautyValues {
    
    self.fFilterStrength = 0.65;
    
    self.fSmoothStrength = 0.74;
    self.fReddenStrength = 0.36;
    self.fWhitenStrength = 0.02;
    self.fDehighlightStrength = 0.0;
    
    self.fEnlargeEyeStrength = 0.13;
    self.fShrinkFaceStrength = 0.11;
    self.fShrinkJawStrength = 0.10;
    self.fThinFaceShapeStrength = 0.0;
    
    self.fChinStrength = 0.0;
    self.fHairLineStrength = 0.0;
    self.fNarrowNoseStrength = 0.0;
    self.fLongNoseStrength = 0.0;
    self.fMouthStrength = 0.0;
    self.fPhiltrumStrength = 0.0;
    
    self.fEyeDistanceStrength = 0.0;
    self.fEyeAngleStrength = 0.0;
    self.fOpenCanthusStrength = 0.0;
    self.fProfileRhinoplastyStrength = 0.0;
    self.fBrightEyeStrength = 0.0;
    self.fRemoveDarkCirclesStrength = 0.0;
    self.fRemoveNasolabialFoldsStrength = 0.0;
    self.fWhiteTeethStrength = 0.0;
    self.fAppleMusleStrength = 0.0;
    
    self.fContrastStrength = 0.0;
    self.fSaturationStrength = 0.0;
    
    self.baseBeautyModels[0].beautyValue = 2;
    self.baseBeautyModels[0].selected = NO;
    self.baseBeautyModels[1].beautyValue = 36;
    self.baseBeautyModels[1].selected = NO;
    self.baseBeautyModels[2].beautyValue = 74;
    self.baseBeautyModels[2].selected = NO;
    self.baseBeautyModels[3].beautyValue = 0;
    self.baseBeautyModels[3].selected = NO;
    
    self.microSurgeryModels[0].beautyValue = 0;
    self.microSurgeryModels[0].selected = NO;
    self.microSurgeryModels[1].beautyValue = 0;
    self.microSurgeryModels[1].selected = NO;
    self.microSurgeryModels[2].beautyValue = 0;
    self.microSurgeryModels[2].selected = NO;
    self.microSurgeryModels[3].beautyValue = 0;
    self.microSurgeryModels[3].selected = NO;
    self.microSurgeryModels[4].beautyValue = 0;
    self.microSurgeryModels[4].selected = NO;
    self.microSurgeryModels[5].beautyValue = 0;
    self.microSurgeryModels[5].selected = NO;
    self.microSurgeryModels[6].beautyValue = 0;
    self.microSurgeryModels[6].selected = NO;
    self.microSurgeryModels[7].beautyValue = 0;
    self.microSurgeryModels[7].selected = NO;
    self.microSurgeryModels[8].beautyValue = 0;
    self.microSurgeryModels[8].selected = NO;
    self.microSurgeryModels[9].beautyValue = 0;
    self.microSurgeryModels[9].selected = NO;
    self.microSurgeryModels[10].beautyValue = 0;
    self.microSurgeryModels[10].selected = NO;
    self.microSurgeryModels[11].beautyValue = 0;
    self.microSurgeryModels[11].selected = NO;
    self.microSurgeryModels[12].beautyValue = 0;
    self.microSurgeryModels[12].selected = NO;
    self.microSurgeryModels[13].beautyValue = 0;
    self.microSurgeryModels[13].selected = NO;
    self.microSurgeryModels[14].beautyValue = 0;
    self.microSurgeryModels[14].selected = NO;
    self.microSurgeryModels[15].beautyValue = 0;
    self.microSurgeryModels[15].selected = NO;
    
    self.beautyShapeModels[0].beautyValue = 11;
    self.beautyShapeModels[0].selected = NO;
    self.beautyShapeModels[1].beautyValue = 13;
    self.beautyShapeModels[1].selected = NO;
    self.beautyShapeModels[2].beautyValue = 10;
    self.beautyShapeModels[2].selected = NO;
    
    self.adjustModels[0].beautyValue = 0;
    self.adjustModels[0].selected = NO;
    self.adjustModels[1].beautyValue = 0;
    self.adjustModels[1].selected = NO;
    
    self.preFilterModelPath = nil;
    self.curFilterModelPath = nil;
}

#pragma mark -- private
- (void)setDefaultValue {
    
    self.preFilterModelPath = nil;
    self.curFilterModelPath = nil;
    
    self.bBeauty = YES;
    self.bFilter = YES;
    
    self.fFilterStrength = 0.65;
    
    self.filterStrengthViewHiddenState = YES;
    
    self.microSurgeryModels = @[
        getModel([UIImage imageNamed:@"zhailian"], [UIImage imageNamed:@"zhailian_selected"], @"瘦脸型", 0, NO, 0, STEffectsTypeBeautyMicroSurgery, STBeautyTypeThinFaceShape),
        getModel([UIImage imageNamed:@"xiaba"], [UIImage imageNamed:@"xiaba_selected"], @"下巴", 0, NO, 1, STEffectsTypeBeautyMicroSurgery, STBeautyTypeChin),
        getModel([UIImage imageNamed:@"etou"], [UIImage imageNamed:@"etou_selected"], @"额头", 0, NO, 2, STEffectsTypeBeautyMicroSurgery, STBeautyTypeHairLine),
        getModel([UIImage imageNamed:@"苹果机-白"], [UIImage imageNamed:@"苹果机-紫"], @"苹果肌", 0, NO, 3, STEffectsTypeBeautyMicroSurgery, STBeautyTypeAppleMusle),
        getModel([UIImage imageNamed:@"shoubiyi"], [UIImage imageNamed:@"shoubiyi_selected"], @"瘦鼻翼", 0, NO, 4, STEffectsTypeBeautyMicroSurgery, STBeautyTypeNarrowNose),
        getModel([UIImage imageNamed:@"changbi"], [UIImage imageNamed:@"changbi_selected"], @"长鼻", 0, NO, 5, STEffectsTypeBeautyMicroSurgery, STBeautyTypeLengthNose),
        getModel([UIImage imageNamed:@"侧脸隆鼻-白"], [UIImage imageNamed:@"侧脸隆鼻-紫"], @"侧脸隆鼻", 0, NO, 6, STEffectsTypeBeautyMicroSurgery, STBeautyTypeProfileRhinoplasty),
        getModel([UIImage imageNamed:@"zuixing"], [UIImage imageNamed:@"zuixing_selected"], @"嘴形", 0, NO, 7, STEffectsTypeBeautyMicroSurgery, STBeautyTypeMouthSize),
        getModel([UIImage imageNamed:@"suorenzhong"], [UIImage imageNamed:@"suorenzhong_selected"], @"缩人中", 0, NO, 8, STEffectsTypeBeautyMicroSurgery, STBeautyTypeLengthPhiltrum),
        getModel([UIImage imageNamed:@"眼睛距离调整-白"], [UIImage imageNamed:@"眼睛距离调整-紫"], @"眼距", 0, NO, 9, STEffectsTypeBeautyMicroSurgery, STBeautyTypeEyeDistance),
        getModel([UIImage imageNamed:@"眼睛角度微调-白"], [UIImage imageNamed:@"眼睛角度微调-紫"], @"眼睛角度", 0, NO, 10, STEffectsTypeBeautyMicroSurgery, STBeautyTypeEyeAngle),
        getModel([UIImage imageNamed:@"开眼角-白"], [UIImage imageNamed:@"开眼角-紫"], @"开眼角", 0, NO, 11, STEffectsTypeBeautyMicroSurgery, STBeautyTypeOpenCanthus),
        getModel([UIImage imageNamed:@"亮眼-白"], [UIImage imageNamed:@"亮眼-紫"], @"亮眼", 0, NO, 12, STEffectsTypeBeautyMicroSurgery, STBeautyTypeBrightEye),
        getModel([UIImage imageNamed:@"去黑眼圈-白"], [UIImage imageNamed:@"去黑眼圈-紫"], @"祛黑眼圈", 0, NO, 13, STEffectsTypeBeautyMicroSurgery, STBeautyTypeRemoveDarkCircles),
        getModel([UIImage imageNamed:@"去法令纹-白"], [UIImage imageNamed:@"去法令纹-紫"], @"祛法令纹", 0, NO, 14, STEffectsTypeBeautyMicroSurgery, STBeautyTypeRemoveNasolabialFolds),
        getModel([UIImage imageNamed:@"牙齿美白-白"], [UIImage imageNamed:@"牙齿美白-紫"], @"白牙", 0, NO, 15, STEffectsTypeBeautyMicroSurgery, STBeautyTypeWhiteTeeth),
    ];
    
    self.baseBeautyModels = @[
        getModel([UIImage imageNamed:@"meibai"], [UIImage imageNamed:@"meibai_selected"], @"美白", 2, NO, 0, STEffectsTypeBeautyBase, STBeautyTypeWhiten),
        getModel([UIImage imageNamed:@"hongrun"], [UIImage imageNamed:@"hongrun_selected"], @"红润", 36, NO, 1, STEffectsTypeBeautyBase, STBeautyTypeRuddy),
        getModel([UIImage imageNamed:@"mopi"], [UIImage imageNamed:@"mopi_selected"], @"磨皮", 74, NO, 2, STEffectsTypeBeautyBase, STBeautyTypeDermabrasion),
        getModel([UIImage imageNamed:@"qugaoguang"], [UIImage imageNamed:@"qugaoguang_selected"], @"去高光", 0, NO, 3, STEffectsTypeBeautyBase, STBeautyTypeDehighlight),
    ];
    self.beautyShapeModels = @[
        getModel([UIImage imageNamed:@"shoulian"], [UIImage imageNamed:@"shoulian_selected"], @"瘦脸", 11, NO, 0, STEffectsTypeBeautyShape, STBeautyTypeShrinkFace),
        getModel([UIImage imageNamed:@"dayan"], [UIImage imageNamed:@"dayan_selected"], @"大眼", 13, NO, 1, STEffectsTypeBeautyShape, STBeautyTypeEnlargeEyes),
        getModel([UIImage imageNamed:@"xiaolian"], [UIImage imageNamed:@"xiaolian_selected"], @"小脸", 10, NO, 2, STEffectsTypeBeautyShape, STBeautyTypeShrinkJaw),
        getModel([UIImage imageNamed:@"zhailian2"], [UIImage imageNamed:@"zhailian2_selected"], @"窄脸", 0, NO, 3, STEffectsTypeBeautyShape, STBeautyTypeNarrowFace)
    ];
    self.adjustModels = @[
        getModel([UIImage imageNamed:@"contrast"], [UIImage imageNamed:@"contrast_selected"], @"对比度", 0, NO, 0, STEffectsTypeBeautyAdjust, STBeautyTypeContrast),
        getModel([UIImage imageNamed:@"saturation"], [UIImage imageNamed:@"saturation_selected"], @"饱和度", 0, NO, 1, STEffectsTypeBeautyAdjust, STBeautyTypeSaturation),
    ];
    
    _bmp_Eye_Value = _bmp_EyeLiner_Value = _bmp_EyeLash_Value = _bmp_Lip_Value = _bmp_Brow_Value = _bmp_Nose_Value = _bmp_Face_Value =_bmp_Blush_Value = 0.8;
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
        
        NSLog(@"BeautifyTexture CVOpenGLESTextureCacheCreateTextureFromImage %d" , cvRet);
        
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

- (st_makeup_type)getMakeUpType:(STBMPTYPE)bmpType
{
    st_makeup_type type;
    switch (bmpType) {
        case STBMPTYPE_EYE:
            type = ST_MAKEUP_TYPE_EYE;
            break;
        case STBMPTYPE_EYELINER:
            type = ST_MAKEUP_TYPE_EYELINER;
            break;
        case STBMPTYPE_EYELASH:
            type = ST_MAKEUP_TYPE_EYELASH;
            break;
        case STBMPTYPE_LIP:
            type =  ST_MAKEUP_TYPE_LIP;
            break;
        case STBMPTYPE_BROW:
            type =  ST_MAKEUP_TYPE_BROW;
            break;
        case STBMPTYPE_FACE:
            type =  ST_MAKEUP_TYPE_NOSE;
            break;
        case STBMPTYPE_BLUSH:
            type =  ST_MAKEUP_TYPE_FACE;
            break;
        case STBMPTYPE_COUNT:
            break;
    }
    
    return type;
}

- (void)resetBmp
{
    [self resetBmpModels];
    
    st_mobile_makeup_clear_makeups(_hBmpHandle);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetUIs" object:nil];
}

- (void)resetBmpModels
{
    _bmp_Eye_Value = _bmp_EyeLiner_Value = _bmp_EyeLash_Value = _bmp_Lip_Value = _bmp_Brow_Value = _bmp_Nose_Value = _bmp_Face_Value = _bmp_Blush_Value = 0.8;
}

#pragma mark -- get current action
- (uint64_t)currentActionWithBeautify:(uint64_t)originalAction {
    
    if((self.fEnlargeEyeStrength != 0 || self.fShrinkFaceStrength != 0 || self.fShrinkJawStrength != 0 || self.fThinFaceShapeStrength != 0 || self.fNarrowFaceStrength != 0 || self.fChinStrength != 0 || self.fHairLineStrength != 0 || self.fNarrowNoseStrength != 0 || self.fLongNoseStrength != 0 || self.fMouthStrength != 0 || self.fPhiltrumStrength != 0 || self.fEyeDistanceStrength != 0 || self.fEyeAngleStrength != 0 || self.fOpenCanthusStrength != 0 || self.fProfileRhinoplastyStrength != 0 || self.fBrightEyeStrength != 0 || self.fRemoveDarkCirclesStrength != 0 || self.fRemoveNasolabialFoldsStrength != 0 || self.fWhiteTeethStrength != 0 || self.fAppleMusleStrength != 0) && _hBeautify) {
        
        return (originalAction | ST_MOBILE_FACE_DETECT);
    }
    
    return originalAction;
}

- (uint64_t)currentActionWithMakeUp:(uint64_t)originalAction {
    
    if (_bMakeUp) {
        uint64_t config = originalAction | ST_MOBILE_FACE_DETECT | ST_MOBILE_DETECT_EXTRA_FACE_POINTS;
        return config;
    } else {
        uint64_t config = originalAction | ST_MOBILE_FACE_DETECT;
        return config;
    }
}

- (void)dealloc {
    [self releaseResources];
    [self releaseResultTexture];
}

#pragma mark -- for view

- (void)resetBeautyValuesWithType:(STEffectsType)type filterModelPath:(NSString *)filterModelPath {
    
    switch (type) {
        case STEffectsTypeBeautyFilter:
        {
            self.fFilterStrength = 0.65;
            self.curFilterModelPath = filterModelPath;
            st_mobile_gl_filter_set_param(_hFilter, ST_GL_FILTER_STRENGTH, self.fFilterStrength);
        }
            
            break;
        case STEffectsTypeBeautyBase:
            
            self.fSmoothStrength = 0.74;
            self.fReddenStrength = 0.36;
            self.fWhitenStrength = 0.02;
            self.fDehighlightStrength = 0.0;
            
            self.baseBeautyModels[0].beautyValue = 2;
            self.baseBeautyModels[1].beautyValue = 36;
            self.baseBeautyModels[2].beautyValue = 74;
            self.baseBeautyModels[3].beautyValue = 0;
            
            break;
        case STEffectsTypeBeautyShape:
            
            self.fEnlargeEyeStrength = 0.13;
            self.fShrinkFaceStrength = 0.11;
            self.fShrinkJawStrength = 0.10;
            self.fNarrowFaceStrength = 0.0;
            
            self.beautyShapeModels[0].beautyValue = 11;
            self.beautyShapeModels[1].beautyValue = 13;
            self.beautyShapeModels[2].beautyValue = 10;
            self.beautyShapeModels[3].beautyValue = 0;
            
            break;
            
        case STEffectsTypeBeautyMicroSurgery:
            
            self.fThinFaceShapeStrength = 0.0;
            self.fChinStrength = 0.0;
            self.fHairLineStrength = 0.0;
            self.fNarrowNoseStrength = 0.0;
            self.fLongNoseStrength = 0.0;
            self.fMouthStrength = 0.0;
            self.fPhiltrumStrength = 0.0;
            
            self.fEyeDistanceStrength = 0.0;
            self.fEyeAngleStrength = 0.0;
            self.fOpenCanthusStrength = 0.0;
            self.fProfileRhinoplastyStrength = 0.0;
            self.fBrightEyeStrength = 0.0;
            self.fRemoveNasolabialFoldsStrength = 0.0;
            self.fRemoveDarkCirclesStrength = 0.0;
            self.fWhiteTeethStrength = 0.0;
            self.fAppleMusleStrength = 0.0;
            
            self.microSurgeryModels[0].beautyValue = 0;
            self.microSurgeryModels[1].beautyValue = 0;
            self.microSurgeryModels[2].beautyValue = 0;
            self.microSurgeryModels[3].beautyValue = 0;
            self.microSurgeryModels[4].beautyValue = 0;
            self.microSurgeryModels[5].beautyValue = 0;
            self.microSurgeryModels[6].beautyValue = 0;
            self.microSurgeryModels[7].beautyValue = 0;
            self.microSurgeryModels[8].beautyValue = 0;
            self.microSurgeryModels[9].beautyValue = 0;
            self.microSurgeryModels[10].beautyValue = 0;
            self.microSurgeryModels[11].beautyValue = 0;
            self.microSurgeryModels[12].beautyValue = 0;
            self.microSurgeryModels[13].beautyValue = 0;
            self.microSurgeryModels[14].beautyValue = 0;
            self.microSurgeryModels[15].beautyValue = 0;
            
            break;
        case STEffectsTypeBeautyAdjust:
            
            self.fContrastStrength = 0.0;
            self.fSaturationStrength = 0.0;
            
            self.adjustModels[0].beautyValue = 0;
            self.adjustModels[1].beautyValue = 0;
            
            break;
            
        case STEffectsTypeBeautyMakeUp:
            
            [self resetBmp];
            
            break;
        default:
            break;
    }
}

- (NSArray *)getFilterModelsByType:(STEffectsType)type {
    
    NSArray *filterModelPath = [STParamUtil getFilterModelPathsByType:type];
    
    NSMutableArray *arrModels = [NSMutableArray array];
    
    NSString *natureImageName = @"";
    switch (type) {
        case STEffectsTypeFilterDeliciousFood:
            natureImageName = @"nature_food";
            break;
            
        case STEffectsTypeFilterStillLife:
            natureImageName = @"nature_stilllife";
            break;
            
        case STEffectsTypeFilterScenery:
            natureImageName = @"nature_scenery";
            break;
            
        case STEffectsTypeFilterPortrait:
            natureImageName = @"nature_portrait";
            break;
            
        default:
            break;
    }
    
    STCollectionViewDisplayModel *model1 = [[STCollectionViewDisplayModel alloc] init];
    model1.strPath = NULL;
    model1.strName = @"original";
    model1.image = [UIImage imageNamed:natureImageName];
    model1.index = 0;
    model1.isSelected = NO;
    model1.modelType = STEffectsTypeNone;
    [arrModels addObject:model1];
    
    for (int i = 1; i < filterModelPath.count + 1; ++i) {
        
        STCollectionViewDisplayModel *model = [[STCollectionViewDisplayModel alloc] init];
        model.strPath = filterModelPath[i - 1];
        model.strName = [[model.strPath.lastPathComponent stringByDeletingPathExtension] stringByReplacingOccurrencesOfString:@"filter_style_" withString:@""];
        
        UIImage *thumbImage = [UIImage imageWithContentsOfFile:[[model.strPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"]];
        
        model.image = thumbImage ?: [UIImage imageNamed:@"none"];
        model.index = i;
        model.isSelected = NO;
        model.modelType = type;
        
        [arrModels addObject:model];
    }
    return [arrModels copy];
}

- (void)filterSliderValueChanged:(float)value {
    
    _fFilterStrength = value;
    if (_hFilter) {
        
        st_result_t iRet = ST_OK;
        iRet = st_mobile_gl_filter_set_param(_hFilter, ST_GL_FILTER_STRENGTH, value);
        
        if (ST_OK != iRet) {
            
            STLog(@"st_mobile_gl_filter_set_param %d" , iRet);
        }
    }
}

- (void)beautySliderValueChanged:(float)value beautySelectModel:(STNewBeautyCollectionViewModel *)selectModel {
    
    switch (selectModel.beautyType) {
            
        case STBeautyTypeNone:
            break;
        case STBeautyTypeWhiten:
            self.fWhitenStrength = value;
            break;
        case STBeautyTypeRuddy:
            self.fReddenStrength = value;
            break;
        case STBeautyTypeDermabrasion:
            self.fSmoothStrength = value;
            break;
        case STBeautyTypeDehighlight:
            self.fDehighlightStrength = value;
            break;
        case STBeautyTypeShrinkFace:
            self.fShrinkFaceStrength = value;
            break;
        case STBeautyTypeNarrowFace:
            self.fNarrowFaceStrength = value;
            break;
        case STBeautyTypeEnlargeEyes:
            self.fEnlargeEyeStrength = value;
            break;
        case STBeautyTypeShrinkJaw:
            self.fShrinkJawStrength = value;
            break;
        case STBeautyTypeThinFaceShape:
            self.fThinFaceShapeStrength = value;
            break;
        case STBeautyTypeChin:
            self.fChinStrength = value;
            break;
        case STBeautyTypeHairLine:
            self.fHairLineStrength = value;
            break;
        case STBeautyTypeNarrowNose:
            self.fNarrowNoseStrength = value;
            break;
        case STBeautyTypeLengthNose:
            self.fLongNoseStrength = value;
            break;
        case STBeautyTypeMouthSize:
            self.fMouthStrength = value;
            break;
        case STBeautyTypeLengthPhiltrum:
            self.fPhiltrumStrength = value;
            break;
        case STBeautyTypeContrast:
            self.fContrastStrength = value;
            break;
        case STBeautyTypeSaturation:
            self.fSaturationStrength = value;
            break;
        case STBeautyTypeAppleMusle:
            self.fAppleMusleStrength = value;
            break;
        case STBeautyTypeProfileRhinoplasty:
            self.fProfileRhinoplastyStrength = value;
            break;
        case STBeautyTypeBrightEye:
            self.fBrightEyeStrength = value;
            break;
        case STBeautyTypeRemoveDarkCircles:
            self.fRemoveDarkCirclesStrength = value;
            break;
        case STBeautyTypeWhiteTeeth:
            self.fWhiteTeethStrength = value;
            break;
        case STBeautyTypeEyeDistance:
            self.fEyeDistanceStrength = value;
            break;
        case STBeautyTypeEyeAngle:
            self.fEyeAngleStrength = value;
            break;
        case STBeautyTypeOpenCanthus:
            self.fOpenCanthusStrength = value;
            break;
        case STBeautyTypeRemoveNasolabialFolds:
            self.fRemoveNasolabialFoldsStrength = value;
            break;
    }
}

- (void)bmpSliderValueChanged:(float)value {
    if (!_hBmpHandle) {
        return;
    }
    st_makeup_type makeupType;
    switch (_bmp_Current_Model.m_bmpType) {
        case STBMPTYPE_EYE:
            _bmp_Eye_Model.m_bmpStrength = value;
            _bmp_Eye_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_EYE];
            break;
        case STBMPTYPE_EYELINER:
            _bmp_EyeLiner_Model.m_bmpStrength = value;
            _bmp_EyeLiner_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_EYELINER];
            break;
        case STBMPTYPE_EYELASH:
            _bmp_EyeLash_Model.m_bmpStrength = value;
            _bmp_EyeLash_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_EYELASH];
            break;
        case STBMPTYPE_LIP:
            _bmp_Lip_Model.m_bmpStrength = value;
            _bmp_Lip_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_LIP];
            break;
        case STBMPTYPE_BROW:
            _bmp_Brow_Model.m_bmpStrength = value;
            _bmp_Brow_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_BROW];
            break;
        case STBMPTYPE_FACE:
            _bmp_Face_Model.m_bmpStrength = value;
            _bmp_Face_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_FACE];
            break;
        case STBMPTYPE_BLUSH:
            _bmp_Blush_Model.m_bmpStrength = value;
            _bmp_Blush_Value = value;
            makeupType = [self getMakeUpType:STBMPTYPE_BLUSH];
            break;
        case STBMPTYPE_COUNT:
            break;
    }
    
    st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, value);
}

- (void)handleBMPChanged:(STBMPModel *)model sliderValueBlock:(nullable void(^)(float)) block {
    
    _bmp_Current_Model = model;
    st_makeup_type makeupType = [self getMakeUpType:model.m_bmpType];
    if (model.m_zipPath) {
        st_mobile_makeup_set_makeup_for_type(_hBmpHandle, makeupType, model.m_zipPath.UTF8String, NULL);
    }else{
        st_mobile_makeup_set_makeup_for_type(_hBmpHandle, makeupType, NULL, NULL);
    }
    
    switch (model.m_bmpType) {
        case STBMPTYPE_EYE:
            _bmp_Eye_Model = model;
            block(_bmp_Eye_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_Eye_Value);
            break;
        case STBMPTYPE_EYELINER:
            _bmp_EyeLiner_Model = model;
            block(_bmp_EyeLiner_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_EyeLiner_Value);
            break;
        case STBMPTYPE_EYELASH:
            _bmp_EyeLash_Model = model;
            block(_bmp_EyeLash_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_EyeLash_Value);
            break;
        case STBMPTYPE_LIP:
            _bmp_Lip_Model = model;
            block(_bmp_Lip_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_Lip_Value);
            break;
        case STBMPTYPE_BROW:
            _bmp_Brow_Model = model;
            block(_bmp_Brow_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_Brow_Value);
            break;
        case STBMPTYPE_FACE:
            _bmp_Face_Model = model;
            block(_bmp_Face_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_Face_Value);
            break;
        case STBMPTYPE_BLUSH:
            _bmp_Blush_Model = model;
            block(_bmp_Blush_Value);
            st_mobile_makeup_set_strength_for_type(_hBmpHandle, makeupType, _bmp_Blush_Value);
            break;
        case STBMPTYPE_COUNT:
            break;
    }
}

- (void)handleFilterChanged:(STCollectionViewDisplayModel *)model {
    
    [self.senseBeautifyDelegate updateEAGLContext];
    
    self.bFilter = model.index > 0;
    
    // 切换滤镜
    if (_hFilter) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NoticeUpdatePauseOutput object:@(YES)];
        
        self.curFilterModelPath = model.strPath;
        st_result_t iRet = ST_OK;
        iRet = st_mobile_gl_filter_set_param(_hFilter, ST_GL_FILTER_STRENGTH, self.fFilterStrength);
        if (iRet != ST_OK) {
            STLog(@"st_mobile_gl_filter_set_param %d" , iRet);
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NoticeUpdatePauseOutput object:@(NO)];
    }
}

@end
