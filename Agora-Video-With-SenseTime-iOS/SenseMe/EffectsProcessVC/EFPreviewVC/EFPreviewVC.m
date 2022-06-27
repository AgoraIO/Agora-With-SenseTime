//
//  EFPreviewVC'.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/4.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFPreviewVC.h"
#import "EFEffectsView.h"
#import "EFNavigationView.h"
#import "EFEffectsCollectionView.h"
#import "EFMakeupFilterBeautyView.h"
#import "EFSettingPopView.h"
#import "EFResolutionPopView.h"
#import "EffectsCamera.h"
#import "EFAudioManager.h"
#import "EffectsGLPreview.h"
#import "EFStyleView.h"
#import "EFVideoRecorderView.h"
#import "EFMovieRecorderManager.h"
#import <Photos/Photos.h>
#import "EffectsImageUtils.h"
#import "EFToast.h"
#import "EFWebViewController.h"
#import "EFMotionManager.h"
#import "EFCommonObjectContainerView.h"
#import <mach/mach.h>
#import "HXAssetManager.h"
#import "UIViewController+HXExtension.h"

#import "EFScanViewController.h"
#import "EFScanResourceManager+datasource.h"
#import "EFDataSourceGenerator.h"

#import "EffectsPointsPainter.h"
#import "EFPreviewVC+EFStatusManagerDelegate.h"
#import "EFReachability.h"

#pragma mark - EFPreviewVC
@interface EFPreviewVC ()
<EFNavigationViewDelegate, EFEffectsViewDelegate,
UINavigationControllerDelegate,
EFNavigationViewDelegate, EFEffectsProcessDelegate,
EFSettingPopViewDelegate, EFResolutionPopViewDelegate,
EffectsCameraDelegate,
EFVideoRecorderViewDelegate, EFAudioManagerDelegate,
EFMakeupFilterBeautyViewDelegate, EFStyleViewDelegate,
EFEffectsViewDelegate,CAAnimationDelegate,
EFCommonObjectContainerViewDelegate, UIGestureRecognizerDelegate,
EFWebViewControllerDelegate,
EFEffectsCollectionViewDelegate,
EFScanResourceManagerDelegate>
{
    GLuint _width, _height;
    CMFormatDescriptionRef _videoForamt;
    CMFormatDescriptionRef _audioFormat;
    BOOL _bCompare;
    BOOL _needForcus;
    ResolutionType _resolutiuonType;
}
@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic, strong) EffectsCamera *effectsCamera;
@property (nonatomic, strong) NSString *curSessionPreset;
@property (nonatomic, strong) EFAudioManager *audioManager;
@property (nonatomic, strong) EFNavigationView *navigationView;
@property (nonatomic, strong) EFEffectsView *effectsView;
@property (nonatomic, strong) EFSettingPopView *setView;
///特效
@property (nonatomic, strong) EFEffectsCollectionView *efCollectionView;
///美妆 美颜 滤镜
@property (nonatomic, strong) EFMakeupFilterBeautyView *efMakeupFilterBeautyView;
///风格
@property (nonatomic, strong) EFStyleView *styleView;
@property (nonatomic, strong) EFVideoRecorderView *videoRecorderView;
@property (nonatomic, strong) EFMovieRecorderManager *videoRecroderManager;
@property (nonatomic, strong) EFResolutionPopView *resolutView;

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIImage *commonObject;
@property (nonatomic, strong) EFCommonObjectContainerView *commonObjectContainerView;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UISlider *ISOSlider;
@property (nonatomic, strong) EffectsPointsPainter * pointsPainter;

/// replay按钮
@property (nonatomic, strong) UIButton *replayButton;

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation EFPreviewVC
{
    float _lastSliderValue;
    
    UIImageView *_f_imageView;
}

static const float maxBrightnessValue = 2.9;
static const float minBrightnessValue = -2.9;

- (void)dealloc{
    if (_videoForamt) {
        CFRelease(_videoForamt);
    }
}

- (instancetype)init {
    self = [super init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
    [EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1].efDelegate = self;
#pragma clang diagnostic pop
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createEffectProcess];
    [self setDefaults];
    [self beforeAddSubviews];
    [self addEffectsViews];
    [self addNavigationSubView];
    
#if DISABLE_BEAUTY_OVERLAP_FLAG
    [self addOverlapButton];
#endif
    
#if DISABLE_MODULE_REORDER_FLAG
    [self addModuleReorderButton];
#endif
    
#if DISABLE_TOUCH_CLOSE_ACTION
    [self addHiddenButton];
#endif
    
    [[EFMotionManager sharedInstance] start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:@"appDidEnterBackground" object:nil];
    self.renderQueue = dispatch_queue_create("com.render.queue", DISPATCH_QUEUE_SERIAL);
    [self startCapture];
    
    //    [self f_ui];
    
    [self updateScanDatasource:nil];
}

-(void)updateScanDatasource:(void(^)(void))callback {
    EFDataSourceModel *datasourcesModel = [EFDataSourceGenerator sharedInstance].efDataSourceModel;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"特效"];
    NSArray *effectsList = [datasourcesModel.efSubDataSources filteredArrayUsingPredicate:predicate];
    predicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"同步"];
    EFDataSourceModel *effectsModel = effectsList.firstObject;
    EFDataSourceModel *scanModel = [effectsModel.efSubDataSources filteredArrayUsingPredicate:predicate].firstObject;
    [[EFScanResourceManager sharedManager] transformSuperModel:scanModel WithCallback:^(NSArray<EFDataSourceMaterialModel *> * _Nonnull models) {
        scanModel.efSubDataSources = models;
        if (callback) {
            callback();
        }
    }];
}

-(void)f_ui {
    UIImageView *f_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    f_imageView.backgroundColor = UIColor.whiteColor;
    f_imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:f_imageView];
    
    [f_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.equalTo(self.view);
        make.width.equalTo(@180);
        make.height.equalTo(@320);
    }];
    
    _f_imageView = f_imageView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)restoreAllCache {
    [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1] efTriggerAllStorage];
}

- (void)appDidBecomeActive {
    [self.shapeLayer removeFromSuperlayer];
    _needForcus = YES;
}

- (void)appDidEnterBackground {
    if (self.videoRecroderManager != nil) {
        //暂停录制
        [self record:NO];
        [self.videoRecorderView pauseRecroding];
    }
}


- (void)setDefaults{
    _isFirstLaunch = YES;
    _needForcus = YES;
}

-(void)beforeAddSubviews {
    [self addSubviewsIsTryOn:NO];
}

- (void)addSubviewsIsTryOn:(BOOL)isTryOn {
    self.navigationView = [[EFNavigationView alloc]initWithFrame:CGRectZero type:EFViewTypePreview andIsTryOn:isTryOn];
    [self.view addSubview:self.navigationView];
    self.navigationView.delegate = self;
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(92);
    }];
}

-(void)addEffectsViews {
    self.effectsView = [[EFEffectsView alloc]initWithFrame:CGRectZero type:EFViewTypePreview];
    self.effectsView.delegate = self;
    [self.view addSubview:self.effectsView];
    [self.effectsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.efCollectionView = [[EFEffectsCollectionView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode1];
    self.efCollectionView.delegate = self;
    [self.view addSubview:self.efCollectionView];
    
    self.efMakeupFilterBeautyView = [[EFMakeupFilterBeautyView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode1];
    self.efMakeupFilterBeautyView.delegate = self;
    [self.view addSubview:self.efMakeupFilterBeautyView];
    
    self.styleView = [[EFStyleView alloc]initWithFrame:CGRectZero model:EFStatusManagerSingletonMode1];
    self.styleView.delegate = self;
    [self.view addSubview:self.styleView];
    
    self.videoRecorderView = [[EFVideoRecorderView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.videoRecorderView];
    self.videoRecorderView.delegate = self;
    [self.videoRecorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.bottom.equalTo(self.view);
    }];
    self.videoRecorderView.hidden = YES;
}

-(void)addNavigationSubView {
    [self.view addSubview:self.performaceView];
    [self.performaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(60);
    }];
    self.performaceView.hidden = YES;
    
    [self.navigationView layoutIfNeeded];
    CGPoint point = self.navigationView.scaleButton.center;
    point.y += 15;
    self.resolutView = [[EFResolutionPopView alloc]initWithOrigin:point Width:SCREEN_W - 40 Height:80 Type:XTTypeOfUpCenter];
    self.resolutView.delegate = self;
    
    CGPoint setPoint = self.navigationView.settingButton.center;
    setPoint.y += 15;
    self.setView = [[EFSettingPopView alloc]initWithOrigin:setPoint Width:SCREEN_W - 40 Height:80 Type:XTTypeOfUpCenter];
    self.setView.delegate = self;
    
    [self.effecgGLPreview addSubview:self.focusImageView];
    [self.effecgGLPreview addSubview:self.ISOSlider];
    [self addGestureRecoginzer];
    
    self.replayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replayButton.hidden = YES;
    [self.view addSubview:self.replayButton];
    
    [self.replayButton setBackgroundImage:[UIImage imageNamed:@"replay_button"] forState:UIControlStateNormal];
    [self.replayButton addTarget:self action:@selector(onReplayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.width.height.equalTo(@56);
        make.leading.equalTo(self.view).inset(10);
    }];
}

/// 禁用overlap按钮
-(void)addOverlapButton {
    UIButton *overlapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [overlapButton setTitle:@"disable overlap:off" forState:UIControlStateNormal];
    [overlapButton setTitle:@"disable overlap:no" forState:UIControlStateSelected];
    [overlapButton addTarget:self action:@selector(onOverlapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:overlapButton];
    
    [overlapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.width.equalTo(@150);
        make.height.equalTo(@44);
    }];
}

-(void)onOverlapButtonClick:(UIButton *)overlapButton {
    overlapButton.selected ^= 1;
    [self.effectsProcess disableOverlap:overlapButton.selected];
}

// 禁用重新排序module的渲染顺序按钮
-(void)addModuleReorderButton {
    UIButton *moduleReorderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [moduleReorderButton setTitle:@"disable reorder:off" forState:UIControlStateNormal];
    [moduleReorderButton setTitle:@"disable reorder:no" forState:UIControlStateSelected];
    [moduleReorderButton addTarget:self action:@selector(onModuleReorderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moduleReorderButton];

    [moduleReorderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(40);
        make.height.width.equalTo(@150);
        make.height.equalTo(@44);
    }];
}

-(void)onModuleReorderButtonClick:(UIButton *)moduleReorderButton {
    moduleReorderButton.selected ^= 1;
    [self.effectsProcess disableModuleReorder:moduleReorderButton.selected];
}

-(void)addHiddenButton {
    UIButton *hiddenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hiddenButton setTitle:@"hidden all list" forState:UIControlStateNormal];
    [hiddenButton addTarget:self action:@selector(onHiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hiddenButton];

    [hiddenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-40);
        make.height.width.equalTo(@150);
        make.height.equalTo(@44);
    }];
}

-(void)onHiddenButtonClick:(UIButton *)sender {
    [self.effectsView hideSubview:NO];
    [self.efCollectionView dismiss:self.view];
    [self.effectsView hideSubview:NO];
    [self.efMakeupFilterBeautyView dismiss:self.view];
    
    [self.styleView dismiss:self.view];
    [self.effectsView contentOffset:100];
}

- (void)createEffectProcess{
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.ciContext = [CIContext contextWithEAGLContext:self.glContext];
    
    //effects
    self.effectsProcess = [[EffectsProcess alloc] initWithType:EffectsTypePreview
                                                     glContext:self.glContext];
    self.effectsProcess.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.effectsProcess setModelPath:[[NSBundle mainBundle] pathForResource:@"model" ofType:@"bundle"]];
        if (![[EAGLContext currentContext] isEqual:self.glContext]) {
            [EAGLContext setCurrentContext:self.glContext];
        }
        NSString *microPlasticDefaultPath = [[NSBundle mainBundle] pathForResource:@"3DMicroPlasticDefault" ofType:@"zip"];
        [self.effectsProcess setEffectType:EFFECT_BEAUTY_3D_MICRO_PLASTIC path:microPlasticDefaultPath];
        [self.effectsProcess getMeshList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self restoreAllCache];
        });
    });
    
    
    
    //camera
    self.curSessionPreset = AVAssetExportPreset1280x720;
    _resolutiuonType = _1280x720;
    EffectsCamera *camera = [[EffectsCamera alloc] initWithDevicePosition:AVCaptureDevicePositionFront sessionPresset:self.curSessionPreset fps:30 needYuvOutput:YES];
    self.effectsCamera = camera;
    [self.effectsCamera setISOValue:(maxBrightnessValue + minBrightnessValue) / 2.0];
    camera.delegate = self;
    
    CGRect frame = [camera getZoomedRectWithRect:CGRectMake(0, 0, SCREEN_W, SCREEN_H) scaleToFit:YES];
    EAGLContext *previewContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3 sharegroup:self.glContext.sharegroup];
    self.effecgGLPreview = [[EffectsGLPreview alloc] initWithFrame:frame context:previewContext];
    [self.view addSubview:self.effecgGLPreview];
    
    self.commonObjectContainerView = [[EFCommonObjectContainerView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_W, SCREEN_H)];
    self.commonObjectContainerView.delegate = self;
    [self.view addSubview:self.commonObjectContainerView];
    self.commonObjectContainerView.hidden = YES;
    
    self.triggerView = [[EFTriggerView alloc] init];
    [self.view addSubview:self.triggerView];
    
    //audio capture
    EFAudioManager *audio = [[EFAudioManager alloc] init];
    audio.delegate = self;
    self.audioManager = audio;
}

- (void)addCommonObject:(UIImage *)image filePath:(NSString *)filePath{
    UIImage *curImage = image;
    if (!curImage) {
        curImage = [UIImage imageWithContentsOfFile:filePath];
    }
    if (!curImage) return;
    if (![self.commonObject isEqual:curImage]) {
        self.effectsCamera.devicePosition = AVCaptureDevicePositionBack;
        self.commonObject = curImage;
        self.commonObjectContainerView.hidden = NO;
        [self.commonObjectContainerView addCommonObjectViewWithImage:curImage];
        self.commonObjectContainerView.currentCommonObjectView.onFirst = YES;
    }else{
        st_rect_t rect = {0,0,0,0};
        [self.effectsProcess setObjectTrackRect:rect];
        [self.commonObjectContainerView.currentCommonObjectView removeFromSuperview];
        self.commonObjectContainerView.hidden = YES;
        self.commonObject = nil;
    }
}

#pragma mark - 全部效果点击
- (void)actionWith:(EFDataSourceModel *)model selectIndex:(int)index {
    
    if ([model.efName isEqualToString:@"风格"]) {
        self.styleView.selectIndex = index;
        [self.styleView show:self.view];
        return;
    }
    if ([model.efName isEqualToString:@"Avatar"]) {
        NSMutableArray <EFDataSourceModel *> *dataSource = [[EFDataSourceGenerator sharedInstance].efDataSourceModel.efSubDataSources mutableCopy];
        EFDataSourceModel *model = [[EFDataSourceModel alloc]init];
        int index = 0;
        for (int i = 0; i < dataSource.count; i ++) {
            if ([dataSource[i].efName isEqualToString:@"特效"]) {
                model = dataSource[i];
                for (int j = 0; j < dataSource[i].efSubDataSources.count; j ++) {
                    EFDataSourceModel *efmodel = dataSource[i].efSubDataSources[j];
                    if ([efmodel.efAlias isEqualToString:@"Avatar"]) {
                        index = j;
                        break;
                    }
                }
                break;
            }
        }
        [self efEffectsView:self.effectsView effectsAction:model index:index];
        return;
    }
    [self efEffectsView:self.effectsView effectsAction:model index:index];
}


#pragma mark - EFNavigationViewDelegate
- (void)EFNavigationView:(EFNavigationView *)view didSelect:(NSInteger)index sender:(id)sender{
    switch (index) {
        case 0:
        {
            
            [self stopCapture];
            [[EFMotionManager sharedInstance] stop];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            //设置
        case 1:
        {
            [self.setView popView];
        }
            break;
            //缩放
        case 2:
        {
            [self.resolutView popView];
        }
            break;
            
#pragma mark - 切换摄像头
            //切换摄像头
        case 3: {
            [self resetCommonObjectViewPosition];
            if (self.effectsCamera.devicePosition != AVCaptureDevicePositionBack) {
                self.effectsCamera.devicePosition = AVCaptureDevicePositionBack;
            }else{
                self.effectsCamera.devicePosition = AVCaptureDevicePositionFront;
            }
            //            self.effectsCamera.sessionPreset = self.curSessionPreset;
            [self.effectsProcess resetHumanAction];
            _needForcus = YES;
        }
            break;
            
        case 4: { // 扫码
            [self scanAction];
            break;
        }
            
        default:
            break;
    }
}

- (void)resetCommonObjectViewPosition {
    if (self.commonObjectContainerView.currentCommonObjectView) {
        st_rect_t rect = {0,0,0,0};
        [self.effectsProcess setObjectTrackRect:rect];
        self.commonObjectContainerView.currentCommonObjectView.hidden = NO;
        self.commonObjectContainerView.currentCommonObjectView.onFirst = YES;
        self.commonObjectContainerView.currentCommonObjectView.center = CGPointMake(SCREEN_W / 2, SCREEN_H / 2);
    }
}

- (void)startCapture{
    [self.audioManager startRunning];
    [self.effectsCamera startRunning];
}

- (void)stopCapture{
    [self.audioManager stopRunning];
    [self.effectsCamera stopRunning];
}

#pragma mark - EFSettingPopViewDelegate  select 反选
- (void)EFSettingPopView:(EFSettingPopView *)view didSelectIndex:(NSInteger)index select:(BOOL)select {
    // 0 性能展示  1语言切换  2使用条款  3 replay button显示/隐藏
    switch (index) {
        case 0://性能展示
            self.performaceView.hidden = !select;
            break;
        case 1://语言切换
            [self languageSwitch:select];
            break;
        case 2://YUV/RGB
            //            [self swithCamerPixFormat:select];
            //            break;
            //        case 3://使用条款
        {
            [self stopCapture];
            [self.setView dismiss];
            EFWebViewController *webView = [[EFWebViewController alloc]init];
            webView.delegate = self;
            [webView configWebViewWithTitle:@"使用条款" html:[[NSBundle mainBundle] URLForResource:@"使用条款" withExtension:@"html"]];
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
            
        case 3: { // replay button hidden
            self.replayButton.hidden = !select;
            break;
        }
            
        default:
            break;
    }
}

- (void)perFrameCost:(double)start{
    double dCost = CFAbsoluteTimeGetCurrent() - start;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *speed = NSLocalizedString(@"单帧耗时", nil);
        NSString *cpu = NSLocalizedString(@"CPU占用率", nil);
        [self.lblSpeed setText:[NSString stringWithFormat:@"%@: %.0fms", speed, dCost * 1000.0]];
        [self.lblCPU setText:[NSString stringWithFormat:@"%@: %.1f%%" , cpu, [self getCpuUsage]]];
    });
}

# pragma mark - 语言切换
- (void)languageSwitch:(BOOL)selected {
    NSString *language = [NSBundle currentLanguage];
    if ([language hasPrefix:@"zh-Hans"] || language == nil) {
        [self changeLanguage:@"en"];
    }
    if ([language hasPrefix:@"en"]) {
        [self changeLanguage:@"zh-Hans"];
    }
}

- (void)changeLanguage:(NSString *)language {
    [NSBundle setLanguage:language];
    self.setView.hidden = YES;
    [self stopCapture];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)swithCamerPixFormat:(BOOL)bYUV{
    [self.effectsCamera stopRunning];
    EffectsCamera *camera = [[EffectsCamera alloc] initWithDevicePosition:AVCaptureDevicePositionFront sessionPresset:(AVCaptureSessionPreset)self.curSessionPreset fps:30 needYuvOutput:bYUV];
    camera.delegate = self;
    self.effectsCamera = camera;
    [self.effectsCamera startRunning];
}

#pragma mark - replay
-(void)onReplayButtonClick:(UIButton *)sender {
    EFStatusManager *statusManager = [EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1];
    NSArray<EFRenderModel *> *stickers = statusManager.efStickers;
    if (stickers.count > 0) {
        for (EFRenderModel *model in stickers) {
            [self.effectsProcess replayStickerWithPackage:(int)model.efId];
        }
    }
}

#pragma mark - EFResolutionPopViewDelegate 切换分辨率
- (void)EFResolutionPopView:(EFResolutionPopView *)view didSelectType:(ResolutionType)type {
    if (_resolutiuonType == type) return;
    _resolutiuonType = type;
    [self resetCommonObjectViewPosition];
    [self.effectsCamera stopRunning];
    CGFloat screenY = 0;
    switch (type) {
        case _640x480:
            [self.effectsCamera setSessionPreset:AVCaptureSessionPreset640x480];
            self.curSessionPreset = AVCaptureSessionPreset640x480;
            [self.effectsView effectsWithDark:YES];
            screenY = 0;
            [self.navigationView.scaleButton setBackgroundImage:[UIImage imageNamed:@"640x480_dark"] forState:UIControlStateNormal];
            break;
        case _1280x720:
            [self.effectsCamera setSessionPreset:AVCaptureSessionPreset1280x720];
            self.curSessionPreset = AVCaptureSessionPreset1280x720;
            [self.effectsView effectsWithDark:NO];
            screenY = 20;
            [self.navigationView.scaleButton setBackgroundImage:[UIImage imageNamed:@"scale_icon"] forState:UIControlStateNormal];
            break;
        case _1920x1080:
            [self.effectsCamera setSessionPreset:AVCaptureSessionPreset1920x1080];
            self.curSessionPreset = AVCaptureSessionPreset1920x1080;
            [self.effectsView effectsWithDark:NO];
            screenY = 20;
            [self.navigationView.scaleButton setBackgroundImage:[UIImage imageNamed:@"1920x1080_dark"] forState:UIControlStateNormal];
            break;
    }
    [self changePreviewSize:screenY];
    [self.effectsCamera startRunning];
}

- (void)changePreviewSize:(CGFloat)screenY {
    CGRect rect = [self.effectsCamera getZoomedRectWithRect:CGRectMake(0,
                                                                       screenY,
                                                                       SCREEN_W,
                                                                       SCREEN_H)
                                                 scaleToFit:YES];
    
    [self.effecgGLPreview setFrame:rect];
}

- (void)changePreviewY:(CGFloat)y {
    
    CGRect rect = [self.effectsCamera getZoomedRectWithRect:CGRectMake(0,
                                                                       0,
                                                                       SCREEN_W,
                                                                       SCREEN_H)
                                                 scaleToFit:YES];
    rect.origin.y = y;
    [self.effecgGLPreview setFrame:rect];
}



#pragma mark - NavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowNavBar = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowNavBar animated:YES];
}

#pragma mark - EFEffectsViewDelegate
- (void)efEffectsView:(EFEffectsView *)view amplificationContrastAction:(NSInteger)index sender:(nonnull id)sender{
    switch (index) {
        case 0:{
            static BOOL bScale = YES;
            bScale = !bScale;
            if (bScale) {
                self.effecgGLPreview.scale = 0.0;
            }else {
                self.effecgGLPreview.scale = 0.1;
            }
        }
            break;
        case 1:{
            _bCompare = ((UIButton *)sender).selected;
        }
            break;
        default:
            break;
    }
}

- (void)efEffectsView:(EFEffectsView *)view effectsAction:(EFDataSourceModel *)model index:(int)index {
    if ([model.efName isEqualToString:@"特效"]) {
        self.efCollectionView.dataSource = [model.efSubDataSources mutableCopy];
        [self.efCollectionView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"美妆"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemMakeup;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"滤镜"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemFilter;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    if ([model.efName isEqualToString:@"美颜"]) {
        self.efMakeupFilterBeautyView.dataSource = [model.efSubDataSources mutableCopy];
        self.efMakeupFilterBeautyView.itemType = effectsItemBeauty;
        [self.efMakeupFilterBeautyView show:self.view select:index];
    }
    
    [self.effectsView hideSubview:YES];
    [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1] efGetOverLapAndUpdateCurrentStorage];
}

- (void)efEffectsView:(EFEffectsView *)view videoCamearStyleAction:(EffectsActionType)type {
    
    switch (type) {
        case effectsPhoto:
            [self.styleView dismiss:self.view];
            [self.effectsView hideSubview:NO];
            break;
        case effectsStyle:
            [[EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1] efGetOverLapAndUpdateCurrentStorage];
            [self.styleView show:self.view];
            break;
        case effectsVideo:
            [self.styleView dismiss:self.view];
            [self.effectsView hideSubview:NO];
            break;
        case effectsRecord:
            [self.effectsView hideSubview:YES];
            [self.navigationView hideSubview:YES];
            self.videoRecorderView.hidden = NO;
            [self.videoRecorderView startRecroding];
            self.videoRecorderView.isDark = self.resolutView.resolutType == _640x480 ? YES : NO;
            
            if (self.resolutView.resolutType == _640x480) {
                [self changePreviewY:[self getNavBarHight]];
            }
            
            break;
        case effectsTakePhoto:
            _bTakePhoto = YES;
            break;
    }
}


#pragma mark - EFMakeupFilterBeautyViewDelegate
- (void)compareClick:(UIButton *)btn{
    _bCompare = btn.selected;
}

- (Byte *)solvePaddingImage:(Byte *)pImage width:(int)iWidth height:(int)iHeight bytesPerRow:(int *)pBytesPerRow
{
    //pBytesPerRow 每行字节数
    int iBytesPerPixel = *pBytesPerRow / iWidth;
    int iBytesPerRowCopied = iWidth * iBytesPerPixel;
    int iCopiedImageSize = sizeof(Byte) * iWidth * iBytesPerPixel * iHeight;
    
    Byte * copyData = (Byte *)malloc(iCopiedImageSize);
    memset(copyData, 0, iCopiedImageSize);
    
    for (int i = 0; i < iHeight; i ++) {
        memcpy(copyData + i * iBytesPerRowCopied,
               pImage + i * *pBytesPerRow,
               iBytesPerRowCopied);
    }
    
    *pBytesPerRow = iBytesPerRowCopied;
    return copyData;
}

-(void)capturedidOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer handler: (void (^)(CVPixelBufferRef))callback {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    //get the video pixel information videoFormat/width/height
    if (!_videoForamt) {
        CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &(_videoForamt));
    }
    int width = (int)CVPixelBufferGetWidth(pixelBuffer);
    int heigh = (int)CVPixelBufferGetHeight(pixelBuffer);
    st_rotate_type rotateType = [self getRotateType];
    if(!_outTexture || _width != width || _height != heigh){
        _width = width; _height = heigh;
        if(_outTexture) {
            CVPixelBufferRelease(_outputPixelBuffer);
            _outputPixelBuffer = NULL;
            CFRelease(_outputCVTexture);
            _outputCVTexture = 0;
        }
        [self.effectsProcess createGLObjectWith:width
                                         height:heigh
                                        texture:&_outTexture
                                    pixelBuffer:&_outputPixelBuffer
                                      cvTexture:&_outputCVTexture];
        
        [self.pointsPainter createMetalTextureWithWidth:width height:heigh andPixelBuffer:_outputPixelBuffer];
    }
    
    st_mobile_human_action_t detectResult;
    memset(&detectResult, 0, sizeof(st_mobile_human_action_t));
    st_mobile_animal_face_t *animalResult = NULL;
    int animalCount = 0;
    st_result_t ret = [self.effectsProcess detectWithPixelBuffer:pixelBuffer
                                                          rotate:rotateType
                                                  cameraPosition:self.effectsCamera.devicePosition
                                                     humanAction:&detectResult
                                                    animalResult:&animalResult
                                                     animalCount:&animalCount];
    
    if (detectResult.p_segments) { // 查看mask
        st_mobile_segment_t *f_targetSegment = detectResult.p_segments->p_figure;
        if (f_targetSegment && f_targetSegment->p_segment) {
            int f_width = f_targetSegment->p_segment->width;
            int f_height = f_targetSegment->p_segment->height;
            CGColorSpaceRef f_colorSpace = CGColorSpaceCreateDeviceGray();
            
            int f_iBytesPerPixel = 1;
            int f_iBitsPerRow = f_iBytesPerPixel * f_width;
            int f_iBitsPerComponent = 8;
            CGContextRef context = CGBitmapContextCreate(f_targetSegment->p_segment->data,
                                                         f_width,
                                                         f_height,
                                                         f_iBitsPerComponent,
                                                         f_iBitsPerRow,
                                                         f_colorSpace,
                                                         kCGImageAlphaNone | kCGBitmapByteOrderDefault
                                                         );
            CGImageRef quartzImage = CGBitmapContextCreateImage(context);
            
            CGContextRelease(context);
            CGColorSpaceRelease(f_colorSpace);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *f_image = [UIImage imageWithCGImage:quartzImage];
                self->_f_imageView.image = f_image;
                CGImageRelease(quartzImage);
            });
        }
    }
    
    st_mobile_human_action_t detectResultCopy;
    memset(&detectResultCopy, 0, sizeof(st_mobile_human_action_t));
    st_mobile_human_action_copy(&detectResult, &detectResultCopy);
    
    st_mobile_animal_face_t *animalResultCopy = NULL;
    int animalCountCopy = animalCount;
    if(animalResult != NULL){
        animalResultCopy = malloc(sizeof(st_mobile_animal_face_t) * animalCount);
        memset(animalResultCopy, 0, sizeof(st_mobile_animal_face_t) * animalCount);
        st_mobile_animal_face_copy(animalResult, animalCount, animalResultCopy, animalCountCopy);
    }
    
    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    CVPixelBufferRef pixelBufferCopy = CVPixelBufferRetain(pixelBuffer);
    dispatch_async(self.renderQueue, ^{
        //        static int framecount = 0;
        //        if (framecount == 200)
        //        {
        //            glInsertEventMarkerEXT(0, "com.apple.GPUTools.event.debug-frame");
        //        }
        //        framecount ++;
        if (self.videoRecroderManager.stateus == EFWriterRecordingStatusRecording) {
            CVPixelBufferLockBaseAddress(self -> _outputPixelBuffer, 0);
        }
        [self.effectsProcess renderPixelBuffer:pixelBufferCopy
                                        rotate:rotateType
                                   humanAction:detectResultCopy
                                  animalResult:animalResultCopy
                                   animalCount:animalCountCopy
                                    outTexture:self->_outTexture
                                outPixelFormat:ST_PIX_FMT_BGRA8888
                                       outData:nil];
        
        if (detectResultCopy.face_count > 0 || detectResultCopy.foot_count > 0) {
            //        metalTexture
            [self.pointsPainter renderPointsWithDetectResult:detectResultCopy];
        }
        
        [self.effecgGLPreview renderTexture:self->_bCompare?self.effectsProcess.inputTexture:self->_outTexture rotate:-1];
        
        //snap image
        [self snapWithTexture:self->_outTexture width:width height:heigh];
        //record video
        [self.videoRecroderManager appendPixelBuffer:self->_outputPixelBuffer
                                           timeStamp:timestamp];
        CVOpenGLESTextureCacheFlush(self->_cvTextureCache, 0);
        
        st_mobile_human_action_delete(&detectResultCopy);
        if (animalResultCopy) {
            st_mobile_animal_face_delete(animalResultCopy, animalCountCopy);
            free(animalResultCopy);
        }
        CVPixelBufferRelease(pixelBufferCopy);
        if (callback) {
            callback(self->_outputPixelBuffer);
        }
        if (self.videoRecroderManager.stateus == EFWriterRecordingStatusRecording) {
            CVPixelBufferUnlockBaseAddress(self -> _outputPixelBuffer, 0);
        }
    });
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}
#pragma mark - EffectsCameraDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    EFFECTSTIMELOG(total_cost);
    double dStart = CFAbsoluteTimeGetCurrent();
    [self capturedidOutputSampleBuffer:sampleBuffer handler:^(CVPixelBufferRef) { }];
    EFFECTSTIMEPRINT(total_cost, "total_cost");
    [self perFrameCost:dStart];
}

#pragma mark - EFAudioManagerDelegate
- (void)audioCaptureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if(!_audioFormat){
        _audioFormat = CMSampleBufferGetFormatDescription(sampleBuffer);
    }
    [self.videoRecroderManager appendSampleBuffer:sampleBuffer];
}

#pragma mark - hidden touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
#if DISABLE_TOUCH_CLOSE_ACTION
    return;
#endif
    UIView *view = [touches anyObject].view;
    //特效
    if (view.tag == 1000) {
        [self.effectsView hideSubview:NO];
        [self.efCollectionView dismiss:self.view];
    }
    //美妆 滤镜 美颜
    if (view.tag == 1001) {
        [self.effectsView hideSubview:NO];
        [self.efMakeupFilterBeautyView dismiss:self.view];
    }
    
    if ([view isEqual:self.effecgGLPreview] || [view isEqual:self.commonObjectContainerView]) {
        [self.styleView dismiss:self.view];
        [self.effectsView contentOffset:100];
    }
}

- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusImageView.image = [UIImage imageNamed:@"camera_focus_red"];
        _focusImageView.alpha = 0;
    }
    return _focusImageView;
}

- (UISlider *)ISOSlider
{
    if (!_ISOSlider) {
        UISlider *slider = [[UISlider alloc] init];
        slider.frame = CGRectMake(0, 0, 200, 50);
        slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        slider.center= CGPointMake(SCREEN_W - 15, SCREEN_H / 2);
        slider.maximumTrackTintColor = [UIColor whiteColor];
        slider.minimumTrackTintColor = [UIColor whiteColor];
        slider.hidden = YES;
        
        //resize image
        UIImage *imageOriginal = [UIImage imageNamed:@"brightness"];
        UIGraphicsBeginImageContext(CGSizeMake(40, 40));
        [imageOriginal drawInRect:CGRectMake(0, 0, 40, 40)];
        imageOriginal = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [slider setThumbImage:imageOriginal forState:UIControlStateNormal];
        
        slider.minimumValue = minBrightnessValue;
        slider.maximumValue = maxBrightnessValue;
        slider.value = (maxBrightnessValue + minBrightnessValue) / 2.0;
        _lastSliderValue = slider.value;
        [slider addTarget:self action:@selector(ISOSliderValueChanging:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(ISOSliderValueDidChanged:) forControlEvents:UIControlEventTouchUpInside];
        _ISOSlider = slider;
    }
    return _ISOSlider;
}

- (void)ISOSliderValueChanging:(UISlider *)sender {
    _lastSliderValue = (sender.value - _lastSliderValue) / 50.0 + _lastSliderValue;
    sender.value = _lastSliderValue;
    [self.effectsCamera setISOValue:_lastSliderValue];
}

- (void)ISOSliderValueDidChanged:(UISlider *)sender {
    
}

- (void)addGestureRecoginzer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    tapGesture.delegate = self;
    [self.effecgGLPreview addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture {
    CGPoint point = [tapGesture locationInView:self.effecgGLPreview];
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1.0;
    self.ISOSlider.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.focusImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusImageView.alpha = 0;
    }];
    [self.effectsCamera setExposurePoint:point inPreviewFrame:self.effecgGLPreview.frame];
    _lastSliderValue = (maxBrightnessValue + minBrightnessValue) / 2.0;
    self.ISOSlider.value = _lastSliderValue;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.ISOSlider.hidden = YES;
    });
}

#pragma mark - EFVideoRecorderViewDelegate

- (void)cancelBlock:(void (^)(BOOL))block{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"放弃保存当前拍摄视频", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
        block(NO);
    }];
    [alertVC addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        block(YES);
        dispatch_async(dispatch_get_main_queue(), ^{
            //restore UI
            [self.effectsView hideSubview:NO];
            [self.navigationView hideSubview:NO];
            self.videoRecorderView.hidden = YES;
            [self changePreviewSize:self.resolutView.resolutType == _640x480 ? 0 : 20];
            
        });
    }];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)saveVideoWithBlock:(void (^)(void))block{
    if (self.videoURL) {
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.videoURL];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveVideoFinish:error?NO:YES Block:block];
            });
        }];
    }else{
        [self saveVideoFinish:NO Block:block];
    }
}

- (void)saveVideoFinish:(BOOL)success Block:(void (^)(void))block{
    [self changePreviewSize:self.resolutView.resolutType == _640x480 ? 0 : 20];
    [EFToast show:self.view description:success ? NSLocalizedString(@"视频保存成功", nil) :NSLocalizedString(@"视频保存失败", nil)];
    block();
    self.videoRecorderView.hidden = YES;
    [self.effectsView hideSubview:NO];
    [self.navigationView hideSubview:NO];
}

- (void)record:(BOOL)bStart{
    if (bStart) {
        self.videoRecroderManager = [[EFMovieRecorderManager alloc] init];
        [self.videoRecroderManager startRecrodWithVideoSettings:self.effectsCamera.videoCompressingSettings
                                                  audioSettings:self.audioManager.audioCompressingSettings
                                         videoFormatDescription:_videoForamt
                                         audioFormatDescription:_audioFormat];
        weakSelf(self)
        self.videoRecroderManager.recorderCallback = ^(EFRecorderEvent event, NSURL *url) {
            [weakself recordFinish:event url:url];
        };
    }else{
        [self.videoRecroderManager stopRecorder];
    }
}

- (void)recordFinish:(EFRecorderEvent)event url:(NSURL *)url{
    if (url) {
        self.videoURL = [url copy];
    }
}

- (void)snapWithTexture:(GLuint)iTexture width:(int)iWidth height:(int)iHeight{
    if (_bTakePhoto){
        _bTakePhoto = NO;
        CGImageRef cgImage = [EffectsImageUtils getCGImageWithTexture:iTexture
                                                                width:iWidth
                                                               height:iHeight
                                                            ciContext:self.ciContext];
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [EFToast show:self.view description:error ? NSLocalizedString(@"图片保存失败", nil)  : NSLocalizedString(@"图片保存成功", nil)];
            });
        }];
    }
}

#pragma mark - EFStyleViewDelegate
- (void)efStyleViewAction:(UIView *)sender{
    static BOOL bScale = NO;
    bScale = !bScale;
    if (bScale) {
        self.effecgGLPreview.scale = 0.0;
    }else {
        self.effecgGLPreview.scale = 0.1;
    }
}


#pragma mark - EFEffectsProcessDelegate
- (void)updateEffectsFacePoint:(CGPoint)point{
    static int frameCount = 0;
    frameCount++;
    if(!_needForcus) {
        frameCount = 0;
        return;
    }
    if (frameCount%10 == 0) {
        _needForcus = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint center = CGPointMake(self.effecgGLPreview.frame.size.width * point.x,
                                         self.effecgGLPreview.frame.size.height * point.y);
            [self addAnimationToView:self.effecgGLPreview point:center];
        });
    }
}

- (void)updateCommonObjectPosition:(st_rect_t)rect{
    CGFloat scale = MAX(SCREEN_W / _width, SCREEN_H / _height);
    CGFloat margin = (_width * scale - SCREEN_W) / 2;
    CGRect rectDisplay = CGRectMake(rect.left * scale - margin,
                                    rect.top * scale,
                                    rect.right * scale - rect.left * scale,
                                    rect.bottom * scale - rect.top * scale);
    CGPoint center = CGPointMake(rectDisplay.origin.x + rectDisplay.size.width / 2,
                                 rectDisplay.origin.y + rectDisplay.size.height / 2);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.commonObjectContainerView.currentCommonObjectView.isOnFirst) {
            //用作同步,防止再次改变currentCommonObjectView的位置
            
        } else if (rect.left == 0 && rect.top == 0 && rect.right == 0 && rect.bottom == 0) {
            
            self.commonObjectContainerView.currentCommonObjectView.hidden = YES;
            
        } else {
            self.commonObjectContainerView.currentCommonObjectView.hidden = NO;
            self.commonObjectContainerView.currentCommonObjectView.center = center;
        }
    });
}

#pragma mark - EFCommonObjectContainerViewDelegate
- (void)commonObjectViewStartTrackingFrame:(CGRect)frame {
    CGRect cgRect = frame;
    
    CGFloat scale = MAX(SCREEN_W / _width, SCREEN_H / _height);
    CGFloat margin = (_width * scale - SCREEN_W) / 2;
    
    st_rect_t rect;
    rect.left = (cgRect.origin.x + margin) / scale;
    rect.top = cgRect.origin.y / scale;
    rect.right = (cgRect.origin.x + cgRect.size.width + margin) / scale;
    rect.bottom = (cgRect.origin.y + cgRect.size.height) / scale;
    
    [self.effectsProcess setObjectTrackRect:rect];
}

- (void)commonObjectViewFinishTrackingFrame:(CGRect)frame{
    st_rect_t rect = {0,0,0,0};
    [self.effectsProcess setObjectTrackRect:rect];
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer new];
        _shapeLayer.frame = CGRectMake(0, 0, 200, 200);
        _shapeLayer.lineWidth = 2;
        _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
        _shapeLayer.path = [circlePath CGPath];
    }
    return _shapeLayer;
}

- (void)addAnimationToView:(UIView *)view point:(CGPoint)point{
    [self.view.layer addSublayer:self.shapeLayer];
    self.shapeLayer.position = point;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    anim.duration = 0.5;
    anim.values = @[@(1.0),@(0.5),@(0.45),@(0.44),@(0.43),@(0.42)];
    anim.removedOnCompletion= NO;
    anim.fillMode = kCAFillModeBoth;
    anim.delegate = self;
    [self.shapeLayer addAnimation:anim forKey:@"anim"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.shapeLayer removeAllAnimations];
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
}


- (st_rotate_type)getRotateType{
    BOOL isFrontCamera = self.effectsCamera.devicePosition == AVCaptureDevicePositionFront;
    BOOL isVideoMirrored = self.effectsCamera.videoConnection.isVideoMirrored;
    
    [self getDeviceOrientation:[EFMotionManager sharedInstance].motionManager.accelerometerData];
    
    switch (_deviceOrientation) {
            
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

- (void)getDeviceOrientation:(CMAccelerometerData *)accelerometerData {
    if (accelerometerData.acceleration.x >= 0.75) {
        _deviceOrientation = UIDeviceOrientationLandscapeRight;
    } else if (accelerometerData.acceleration.x <= -0.75) {
        _deviceOrientation = UIDeviceOrientationLandscapeLeft;
    } else if (accelerometerData.acceleration.y <= -0.75) {
        _deviceOrientation = UIDeviceOrientationPortrait;
    } else if (accelerometerData.acceleration.y >= 0.75) {
        _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
    } else {
        _deviceOrientation = UIDeviceOrientationPortrait;
    }
}

#pragma mark - EFWebViewControllerDelegate
-(void)webViewControllerDismiss:(EFWebViewController *)webViewController {
    [self startCapture];
}

- (float)getCpuUsage{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

-(EffectsPointsPainter *)pointsPainter {
#ifdef POINTS
    if (!_pointsPainter) {
        _pointsPainter = [[EffectsPointsPainter alloc] init];
    }
#endif
    return _pointsPainter;
}

#pragma mark - EFEffectsCollectionView & EFEffectsCollectionViewDelegate
-(void)setShowPhotoStripView:(BOOL)showPhotoStripView {
    _showPhotoStripView = showPhotoStripView;
    self.efCollectionView.showPhotoStripView = showPhotoStripView;
}

-(void)effectsCollectionView:(EFEffectsCollectionView *)effectsCollectionView selectedImage:(UIImage *)image {
    [self setImageBackground:image];
}

#pragma mark - scan & EFScanResourceManagerDelegate
-(void)scanAction {
    EFScanViewController *scanViewController = [[EFScanViewController alloc] init];
    scanViewController.scanCallback = ^(EFScanResultObject * _Nonnull result) {
        
        EFReachability *reachability = [EFReachability reachabilityForInternetConnection];
        if ([reachability currentReachabilityStatus] == SenseArNetWorkStatusNotReachable) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.label.text = NSLocalizedString(@"网络异常，请稍后再试", nil);
            [self.hud hideAnimated:YES afterDelay:1];
            return;
        }
        
        [EFScanResourceManager sharedManager].delegate = self;
        [[EFScanResourceManager sharedManager] efProcessingScanResultObject:result];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.label.text = NSLocalizedString(@"下载中", nil);
    };
    [self showViewController:scanViewController sender:nil];
}

-(void)scanResourceManager:(EFScanResourceManager *)manager downloadStatusChanged:(EFScanResourceDownloadStatus)stauts {
    if (stauts == EFScanResourceDownloadStatusSuccessed) {
        [self updateScanDatasource:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.hud.mode = MBProgressHUDModeDeterminate;
                self.hud.label.text = NSLocalizedString(@"下载成功", nil);
                [self scanSuccessedAndNeedShowEffectsList];
                [self.hud hideAnimated:YES afterDelay:1];
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud.mode = MBProgressHUDModeDeterminate;
            self.hud.label.text = NSLocalizedString(@"下载失败，请重试", nil);
            [self.hud hideAnimated:YES afterDelay:1];
        });
    }
}

-(void)scanSuccessedAndNeedShowEffectsList {
    NSArray<EFDataSourceModel *> *dataSource = [EFDataSourceGenerator sharedInstance].efDataSourceModel.efSubDataSources;
    NSPredicate *effectsPredicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"特效"];
    NSArray<EFDataSourceModel *> *effects = [dataSource filteredArrayUsingPredicate:effectsPredicate];
    if (effects.count > 0) {
        EFDataSourceModel *effectsModel = effects.firstObject;
        NSPredicate *syncPredicate = [NSPredicate predicateWithFormat:@"SELF.efName == %@", @"同步"];
        NSArray<EFDataSourceModel *> *syncs = [effectsModel.efSubDataSources filteredArrayUsingPredicate:syncPredicate];
        
        NSPredicate *avatarPredicate = [NSPredicate predicateWithFormat:@"SELF.efAlias == %@", @"Avatar"];
        NSArray<EFDataSourceModel *> *avatars = [effectsModel.efSubDataSources filteredArrayUsingPredicate:avatarPredicate];

        if (syncs.count > 0) {
            EFDataSourceModel *syncModel = syncs.firstObject;
            int index = (int)([effectsModel.efSubDataSources indexOfObject:syncModel] - avatars.count + 1);
            [self actionWith:effectsModel selectIndex:index];
        }
    }
}

@end
