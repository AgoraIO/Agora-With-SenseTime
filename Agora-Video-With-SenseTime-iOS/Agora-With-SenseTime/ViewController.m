//
//  ViewController.m
//
//  Created by HaifengMay on 16/11/7.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "STParamUtil.h"
#import "STViewButton.h"
#import "SenseTimeUtil.h"

#import "SenseTimeManager.h"
#import "SenseBeautifyManager.h"
#import "SenseEffectsManager.h"

#import "SenseBeautifyView.h"
#import "SenseEffectsView.h"
#import "SenseTouchView.h"
#import "SenseSettingView.h"
#import "SenseAttributeView.h"
#import "SenseRecordView.h"

#import "STGLPreview.h"
#import "STCamera.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

typedef NS_ENUM(NSInteger, STViewTag) {
    
    STViewTagSpecialEffectsBtn = 10000,
    STViewTagBeautyBtn,
};

@interface ViewController () <STViewButtonDelegate, STCameraDelegate, SenseSettingDelegate, SenseTouchViewDelegate, SenseRecordDelegate, SenseEffectsViewDelegate, SenseTimeDelegate, AgoraRtcEngineDelegate, AgoraVideoSourceProtocol> {
    
}

@property (nonatomic, strong) STGLPreview *renderView;
@property (nonatomic, strong) STCamera *stCamera;

@property (nonatomic, strong) SenseTimeManager *senseTimeManager;

@property (nonatomic, strong) SenseBeautifyView *senseBeautifyView;
@property (nonatomic, strong) SenseEffectsView *senseEffectsView;
@property (nonatomic, strong) SenseSettingView *senseSettingView;
@property (nonatomic, strong) SenseTouchView *senseTouchView;
@property (nonatomic, strong) SenseAttributeView *senseAttributeView;
@property (nonatomic, strong) SenseRecordView *senseRecordView;

@property (nonatomic, assign) BOOL isFirstLaunch;
@property (nonatomic, assign) BOOL needSnap;
@property (nonatomic, assign) BOOL pauseOutput;
@property (nonatomic, assign) BOOL isAppActive;

//bottom tab bar
@property (nonatomic, readwrite, strong) STViewButton *specialEffectsBtn;
@property (nonatomic, readwrite, strong) STViewButton *beautyBtn;

@property (nonatomic, readwrite, strong) UIView *gradientView;
@property (nonatomic, readwrite, strong) STViewButton *snapBtn;

@property (nonatomic, readwrite, strong) UIButton *btnChangeCamera;
@property (nonatomic, readwrite, strong) UIButton *btnCompare;
@property (nonatomic, readwrite, strong) UIButton *btnSetting;

#pragma Agora
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;    //Agora Engine
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteCanvas;
@property (nonatomic, weak)   UIView *remoteRenderView;
@property (nonatomic, strong) AgoraRtcVideoCanvas *localCanvas;
@property (nonatomic, weak)   UIView *localRenderView;
@property (nonatomic, assign) NSInteger count;

@end

@implementation ViewController

@synthesize consumer;

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestPermissions];
    [self addNotifications];
    
    self.isAppActive = YES;
    self.pauseOutput = NO;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    STWeakSelf
    self.senseTimeManager = [[SenseTimeManager alloc] initWithSuccessBlock:^{
        [weakSelf initSenseModule];
        [weakSelf setupSubviews];
        [weakSelf loadAgoraKit];
    }];
    self.senseTimeManager.senseTimeDelegate = self;
}

-(void)initSenseModule {
    
#pragma mark RenderView
    {
        EAGLContext *previewContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:self.senseTimeManager.glContext.sharegroup];
        
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        NSDictionary<NSString *, id> *videoSettings = self.stCamera.dataOutput.videoSettings;
        CGFloat fWidth = [[videoSettings objectForKey:@"Width"] floatValue];
        CGFloat fHeight = [[videoSettings objectForKey:@"Height"] floatValue];
        
        rect = [SenseTimeUtil getZoomedRectWithRect:rect scaleToFit:NO videoSettingSize:CGSizeMake(fWidth, fHeight)];
        
        self.renderView = [[STGLPreview alloc] initWithFrame:rect context:previewContext];
        [self.view addSubview:self.renderView];
    }
    
#pragma mark SenseTouchView
    {
        self.senseTouchView = [[SenseTouchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.senseTouchView addSubview:self.senseEffectsView.commonObjectContainerView];
        _senseTouchView.senseTouchDelegate = self;
        [self.view addSubview:self.senseTouchView];
    }

#pragma mark SenseBeautify
    {
        SenseBeautifyManager *senseBeautifyManager = [SenseBeautifyManager new];
        self.senseTimeManager.senseBeautifyManager = senseBeautifyManager;

        [self.senseBeautifyView initSenseBeautifyManager:senseBeautifyManager];
        [self.view addSubview:self.senseBeautifyView];
    }

#pragma mark SenseEffects
    {
        SenseEffectsManager *senseEffectsManager = [SenseEffectsManager new];
        self.senseTimeManager.senseEffectsManager = senseEffectsManager;

        self.senseEffectsView.senseEffectsDelegate = self;
        [self.senseEffectsView initSenseEffectsManager:senseEffectsManager];
        [self.view addSubview:self.senseEffectsView];
        [self.view addSubview:_senseEffectsView.triggerView];
    }

#pragma mark SenseSettingView
    {
        self.senseSettingView = [[SenseSettingView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 230)];
        self.senseSettingView.senseSettingDelegate = self;
        self.senseSettingView.hidden = YES;
        [self.view addSubview:self.senseSettingView];
    }

#pragma mark SenseAttributeView
    {
        self.senseAttributeView = [[SenseAttributeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.senseAttributeView.hidden = YES;
        [self.view addSubview:self.senseAttributeView];
    }

#pragma mark SenseRecordView
    {
        self.senseRecordView = [[SenseRecordView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.senseRecordView.senseRecordDelegate = self;
        [self.view addSubview:self.senseRecordView];
    }
}

- (void)requestPermissions {
    ALAssetsLibrary *photoLibrary = [[ALAssetsLibrary alloc] init];
    [photoLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:nil failureBlock:nil];
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
    
    _isFirstLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:@"FIRSTLAUNCH"] == nil;
    if (_isFirstLaunch) {
        [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"FIRSTLAUNCH"];
    }
}

- (void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePauseOutput:) name:NoticeUpdatePauseOutput object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setExclusiveTouchForButtons:self.view];
    
    if (_isFirstLaunch
        &&
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized) {
        
        _isFirstLaunch = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"点击屏幕底部圆形按钮可拍照，长按可录制视频" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.senseTimeManager resetBmp];
}

-(void)setExclusiveTouchForButtons:(UIView *)myView {
    for (UIView * v in [myView subviews]) {
        [v setExclusiveTouch:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.senseTimeManager = nil;
    
    [self.stCamera stopRunning];
    self.stCamera = nil;
    
    [self.senseTimeManager releaseResources];
}

#pragma mark - handle system notifications
- (void)appWillResignActive {
    self.isAppActive = NO;
    self.pauseOutput = YES;
}

- (void)appDidEnterBackground {
    self.isAppActive = NO;
}

- (void)appWillEnterForeground {
    self.isAppActive = YES;
}

- (void)appDidBecomeActive {
    self.pauseOutput = NO;
    self.isAppActive = YES;
}

- (void)updatePauseOutput:(NSNotification *)notification{
    NSNumber *pauseObj = [notification object];
    if (pauseObj != nil){
        self.pauseOutput = [pauseObj boolValue];
    }
}

#pragma mark - lazy view
- (STCamera *)stCamera {
    if (!_stCamera) {
        
        _stCamera = [[STCamera alloc] initWithDevicePosition:AVCaptureDevicePositionFront
                                              sessionPresset:AVCaptureSessionPreset640x480
                                                         fps:30
                                               needYuvOutput:NO];
        _stCamera.delegate = self;
    }
    return _stCamera;
}

- (SenseBeautifyView *)senseBeautifyView {
    if (!_senseBeautifyView) {
        _senseBeautifyView = [[SenseBeautifyView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 260 - SliderHeight, SCREEN_WIDTH, 260 + SliderHeight)];
        _senseBeautifyView.hidden = YES;
    }
    return _senseBeautifyView;
}

- (SenseEffectsView *)senseEffectsView {
    if (!_senseEffectsView) {
        _senseEffectsView = [[SenseEffectsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 230)];
        _senseEffectsView.hidden = YES;
    }
    return _senseEffectsView;
}

- (STViewButton *)specialEffectsBtn {
    if (!_specialEffectsBtn) {
        
        _specialEffectsBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        [_specialEffectsBtn setExclusiveTouch:YES];
        
        UIImage *image = [UIImage imageNamed:@"btn_special_effects.png"];
        
        _specialEffectsBtn.frame = CGRectMake([SenseTimeUtil layoutWidthWithValue:143], SCREEN_HEIGHT - 50, image.size.width, 50);
        _specialEffectsBtn.center = CGPointMake(_specialEffectsBtn.center.x, self.snapBtn.center.y);
        _specialEffectsBtn.backgroundColor = [UIColor clearColor];
        _specialEffectsBtn.imageView.image = [UIImage imageNamed:@"btn_special_effects.png"];
        _specialEffectsBtn.imageView.highlightedImage = [UIImage imageNamed:@"btn_special_effects_selected.png"];
        _specialEffectsBtn.titleLabel.textColor = [UIColor whiteColor];
        _specialEffectsBtn.titleLabel.highlightedTextColor = UIColorFromRGB(0xc086e5);
        _specialEffectsBtn.titleLabel.text = @"特效";
        _specialEffectsBtn.tag = STViewTagSpecialEffectsBtn;
        
        STWeakSelf;
        
        _specialEffectsBtn.tapBlock = ^{
            [weakSelf clickBottomViewButton:weakSelf.specialEffectsBtn];
        };
    }
    return _specialEffectsBtn;
}

- (STViewButton *)beautyBtn {
    if (!_beautyBtn) {
        _beautyBtn = [[[NSBundle mainBundle] loadNibNamed:@"STViewButton" owner:nil options:nil] firstObject];
        [_beautyBtn setExclusiveTouch:YES];
        
        UIImage *image = [UIImage imageNamed:@"btn_beauty.png"];
        
        _beautyBtn.frame = CGRectMake(SCREEN_WIDTH - [SenseTimeUtil layoutWidthWithValue:143] - image.size.width, SCREEN_HEIGHT - 50, image.size.width, 50);
        _beautyBtn.center = CGPointMake(_beautyBtn.center.x, self.snapBtn.center.y);
        _beautyBtn.backgroundColor = [UIColor clearColor];
        _beautyBtn.imageView.image = [UIImage imageNamed:@"btn_beauty.png"];
        _beautyBtn.imageView.highlightedImage = [UIImage imageNamed:@"btn_beauty_selected.png"];
        _beautyBtn.titleLabel.textColor = [UIColor whiteColor];
        _beautyBtn.titleLabel.highlightedTextColor = UIColorFromRGB(0xc086e5);
        _beautyBtn.titleLabel.text = @"美颜";
        _beautyBtn.tag = STViewTagBeautyBtn;
        
        STWeakSelf;
        
        _beautyBtn.tapBlock = ^{
            [weakSelf clickBottomViewButton:weakSelf.beautyBtn];
        };
    }
    return _beautyBtn;
}

- (STViewButton *)snapBtn {
    if (!_snapBtn) {
        _snapBtn = [[STViewButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 28.5, SCREEN_HEIGHT - 73.5, 57, 57)];
        _snapBtn.layer.cornerRadius = 28.5;
        _snapBtn.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        STWeakSelf;
        _snapBtn.tapBlock = ^{
            weakSelf.needSnap = YES;
        };
        _snapBtn.delegate = self;
    }
    return _snapBtn;
}

- (UIButton *)btnChangeCamera {
    
    if (!_btnChangeCamera) {
        
        UIImage *image = [UIImage imageNamed:@"camera_rotate.png"];
        
        if ([SenseTimeUtil isIphoneX]) {
            _btnChangeCamera = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - image.size.width, 25, image.size.width, image.size.height)];
        } else {
            _btnChangeCamera = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - image.size.width, 7, image.size.width, image.size.height)];
        }
        [_btnChangeCamera setImage:image forState:UIControlStateNormal];
        [_btnChangeCamera addTarget:self action:@selector(onBtnChangeCamera) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnChangeCamera;
}

- (UIButton *)btnSetting {
    
    if (!_btnSetting) {
        
        UIImage *image = [UIImage imageNamed:@"btn_setting_gray.png"];
        
        if ([SenseTimeUtil isIphoneX]) {
            _btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, image.size.width, image.size.height)];
        } else {
            _btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(15, 7, image.size.width, image.size.height)];
        }
        
        [_btnSetting setImage:image forState:UIControlStateNormal];
        [_btnSetting addTarget:self action:@selector(onBtnSetting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSetting;
}

- (UIButton *)btnCompare {
    
    if (!_btnCompare) {
        
        _btnCompare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCompare.frame = CGRectMake(SCREEN_WIDTH - 80, self.senseBeautifyView.frame.origin.y - 35, 70, 35);
        [_btnCompare setTitle:@"对比" forState:UIControlStateNormal];
        [_btnCompare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnCompare.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _btnCompare.layer.cornerRadius = 35 / 2.0;
        
        [_btnCompare addTarget:self action:@selector(onBtnCompareTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_btnCompare addTarget:self action:@selector(onBtnCompareTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_btnCompare addTarget:self action:@selector(onBtnCompareTouchUpInside:) forControlEvents:UIControlEventTouchDragExit];
        
    }
    return _btnCompare;
}

- (UIView *)gradientView {
    
    if (!_gradientView) {
        _gradientView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 35, SCREEN_HEIGHT - 80, 70, 70)];
        _gradientView.alpha = 0.6;
        _gradientView.layer.cornerRadius = 35;
        _gradientView.layer.shadowColor = UIColorFromRGB(0x222256).CGColor;
        _gradientView.layer.shadowOpacity = 0.15;
        _gradientView.layer.shadowOffset = CGSizeZero;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _gradientView.bounds;
        gradientLayer.cornerRadius = 35;
        gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0xc460e1).CGColor, (__bridge id)UIColorFromRGB(0x7fd8ee).CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.shadowColor = UIColorFromRGB(0x472b68).CGColor;
        gradientLayer.shadowOpacity = 0.1;
        gradientLayer.shadowOffset = CGSizeZero;
        [_gradientView.layer addSublayer:gradientLayer];
        
    }
    return _gradientView;
}

#pragma mark - setup subviews
- (void)setupSubviews {
    [self.view addSubview:self.btnChangeCamera];
    [self.view addSubview:self.specialEffectsBtn];
    [self.view addSubview:self.beautyBtn];
    [self.view addSubview:self.gradientView];
    [self.view addSubview:self.snapBtn];
    [self.view addSubview:self.btnCompare];
    [self.view addSubview:self.btnSetting];
}

#pragma mark - btn click events
- (void)onBtnChangeCamera {
    [self.senseEffectsView resetCommonObjectViewPosition];
    
    if (self.stCamera.devicePosition == AVCaptureDevicePositionFront) {
        self.stCamera.devicePosition = AVCaptureDevicePositionBack;
    } else {
        self.stCamera.devicePosition = AVCaptureDevicePositionFront;
    }
    [self.agoraKit switchCamera];
}

- (void)onBtnSetting {
    if (self.senseSettingView.isHidden) {
        [self setViewsHidden:YES];
        self.senseSettingView.hidden = NO;
    } else {
        [self setButtonsHidden:NO];
        self.senseSettingView.hidden = YES;
    }
}

- (void)clickBottomViewButton:(STViewButton *)senderView {
    
    switch (senderView.tag) {
            
        case STViewTagSpecialEffectsBtn:
            if (self.senseEffectsView.hidden) {
                self.specialEffectsBtn.hidden = YES;
                self.beautyBtn.hidden = YES;
                self.senseEffectsView.hidden = NO;
            } else {
                self.specialEffectsBtn.hidden = NO;
                self.beautyBtn.hidden = NO;
                self.senseEffectsView.hidden = YES;
            }
            break;
            
        case STViewTagBeautyBtn:
            if (self.senseBeautifyView.isHidden) {
                self.specialEffectsBtn.hidden = YES;
                self.beautyBtn.hidden = YES;
                self.senseBeautifyView.hidden = NO;
            } else {
                self.specialEffectsBtn.hidden = NO;
                self.beautyBtn.hidden = NO;
                self.senseBeautifyView.hidden = YES;
            }
            break;
    }
}

- (void)onBtnCompareTouchDown:(UIButton *)sender {
    [sender setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
    self.senseTimeManager.isComparing = YES;
    self.snapBtn.userInteractionEnabled = NO;
}

- (void)onBtnCompareTouchUpInside:(UIButton *)sender {
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.senseTimeManager.isComparing = NO;
    self.snapBtn.userInteractionEnabled = YES;
}

#pragma mark - Agora Engine
/**
 * load Agora Engine && Join Channel
 */
- (void)loadAgoraKit {
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:<#Your Agora App Id#> delegate:nil];
    self.agoraKit.delegate = self;
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setVideoEncoderConfiguration:[[AgoraVideoEncoderConfiguration alloc]initWithSize:AgoraVideoDimension640x360
                                                                                          frameRate:AgoraVideoFrameRateFps15
                                                                                            bitrate:AgoraVideoBitrateStandard
                                                                                    orientationMode:AgoraVideoOutputOrientationModeAdaptative]];
    
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    [self.agoraKit enableVideo];
    [self.agoraKit setVideoSource:self];
    
    [self.agoraKit enableWebSdkInteroperability:YES];
    
    [self setupLocalView];
    [self.agoraKit startPreview];
    
    self.count = 0;
    
    [self.agoraKit joinChannelByToken:nil channelId:self.channelName info:nil uid:0 joinSuccess:nil];
}

- (void)setupLocalView {
    //    GLRenderView *renderView = [[GLRenderView alloc] initWithFrame:self.view.frame];
    
    if (self.localCanvas == nil) {
        self.localCanvas = [[AgoraRtcVideoCanvas alloc] init];
    }
    self.localCanvas.view =  [[UIView alloc] initWithFrame:self.view.frame];;
    self.localCanvas.renderMode = AgoraVideoRenderModeHidden;
    // set render view
    [self.agoraKit setupLocalVideo:self.localCanvas];
    self.localRenderView = self.renderView;
}

#pragma mark - Agora Video Source Protocol
- (BOOL)shouldInitialize {
    return YES;
}

- (void)shouldStart {
    [self.stCamera startRunning];
}

- (void)shouldStop {
    [self.stCamera stopRunning];
}

- (void)shouldDispose {
    
}

- (AgoraVideoBufferType)bufferType {
    return AgoraVideoBufferTypePixelBuffer;
}

#pragma mark - Agora Engine Delegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString*)channel withUid:(NSUInteger)uid elapsed:(NSInteger) elapsed {
    NSLog(@"Join Channel Success");
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.count == 0) {
        self.count ++;
        UIView *renderView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view insertSubview:renderView atIndex:0];
        if (self.remoteCanvas == nil) {
            self.remoteCanvas = [[AgoraRtcVideoCanvas alloc] init];
        }
        self.remoteCanvas.uid = uid;
        self.remoteCanvas.view = renderView;
        self.remoteCanvas.renderMode = AgoraVideoRenderModeHidden;
        [self.agoraKit setupRemoteVideo:self.remoteCanvas];
        
        self.remoteRenderView = renderView;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect newFrame = CGRectMake(self.view.frame.size.width * 0.7 - 10, 20, self.view.frame.size.width * 0.3, self.view.frame.size.width * 0.3 * 16.0 / 9.0);
            self.localRenderView.frame = newFrame;
        }];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    if (self.count > 0) {
        self.count --;
        self.remoteCanvas.view = nil;
        [self.remoteRenderView removeFromSuperview];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect newFrame = self.view.frame;
            self.localRenderView.frame = newFrame;
        }];
    }
}

#pragma mark - STViewButtonDelegate
- (void)btnLongPressEnd {
    if (![SenseTimeUtil checkMediaStatus:AVMediaTypeVideo]) {
        return;
    }
    [self setButtonsHidden:NO];
    [self.senseRecordView stopRecorder];
}
- (void)btnLongPressBegin {
    if (![SenseTimeUtil checkMediaStatus:AVMediaTypeVideo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有相机权限无法录制视频" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    [self setViewsHidden:YES];
    [self setButtonsHidden:YES];
    [self.senseRecordView startRecorder:self.stCamera.videoCompressingSettings];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

#pragma mark - STCameraDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.isAppActive) {
        return;
    }
    if (self.pauseOutput) {
        return;
    }
    
    //获取每一帧图像信息
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    
    double dAttributeStart = CFAbsoluteTimeGetCurrent();
    
    GLuint textureResult = 0;
    CVPixelBufferRef pixelBufferRefResult = pixelBuffer;
    
    SenseTimeModel model;
    model.devicePosition = self.stCamera.devicePosition;
    model.isVideoMirrored = self.stCamera.videoConnection.isVideoMirrored;
    model.pixelBuffer = pixelBuffer;
    model.textureResult = &textureResult;
    model.sampleBuffer = sampleBuffer;
    pixelBufferRefResult = [self.senseTimeManager captureOutputWithSenseTimeModel:model];
    
    // for snap button
    [self.senseRecordView captureOutputSampleBuffer:sampleBuffer originalCVPixelBufferRef:pixelBuffer resultCVPixelBufferRef:pixelBufferRefResult];
    if (_needSnap) {
        _needSnap = NO;
        [SenseTimeUtil snapWithView:self.renderView texture:textureResult width:self.senseTimeManager.imageWidth height:self.senseTimeManager.imageHeight];
    }
    
    [self.renderView renderTexture:textureResult];

    // push video frame to agora
    AgoraVideoRotation agoraRotation = [self agoraRotation];
    [self.consumer consumePixelBuffer:pixelBufferRefResult withTimestamp:CMSampleBufferGetPresentationTimeStamp(sampleBuffer) rotation:agoraRotation];
    
    [self updatAttributeInfo:dAttributeStart];
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

-(AgoraVideoRotation)agoraRotation {
    
    AgoraVideoRotation rotation = AgoraVideoRotationNone;
    
    st_rotate_type rotate_type = [self.senseTimeManager getSTMobileRotate];
    switch (rotate_type) {
        case ST_CLOCKWISE_ROTATE_0:
            rotation = AgoraVideoRotationNone;
            break;
        case ST_CLOCKWISE_ROTATE_90:
            rotation = AgoraVideoRotation90;
            break;
        case ST_CLOCKWISE_ROTATE_180:
            rotation = AgoraVideoRotation180;
            break;
        case ST_CLOCKWISE_ROTATE_270:
            rotation = AgoraVideoRotation270;
            break;
        default:
            break;
    }
    
    return rotation;
}

-(void)updatAttributeInfo:(double)dStart {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.senseAttributeView.hidden) {
            [self.senseAttributeView showDescription:dStart];
        }
        self.senseTimeManager.bAttribute = !self.senseAttributeView.hidden;
    });
}

#pragma mark - SenseSettingDelegate
- (void)changeResolution640x480 {
    self.pauseOutput = YES;
    
    // 640x480
    if (![self.stCamera.sessionPreset isEqualToString:AVCaptureSessionPreset640x480]) {
        [self.senseEffectsView resetCommonObjectViewPosition];
        [self.stCamera setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    [self changePreviewSize];
    
    self.pauseOutput = NO;
}

- (void)changeResolution1280x720 {
    self.pauseOutput = YES;
    
    if (![self.stCamera.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        [self.senseEffectsView resetCommonObjectViewPosition];
        [self.stCamera setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    
    [self changePreviewSize];
    self.pauseOutput = NO;
}

- (void)changeAttribute:(BOOL)bShow {
    self.senseAttributeView.hidden = !bShow;
}

#pragma mark -- Private Function
- (void)changePreviewSize {
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSDictionary<NSString *, id> *videoSettings = self.stCamera.dataOutput.videoSettings;
    CGFloat fWidth = [[videoSettings objectForKey:@"Width"] floatValue];
    CGFloat fHeight = [[videoSettings objectForKey:@"Height"] floatValue];
    
    rect = [SenseTimeUtil getZoomedRectWithRect:rect scaleToFit:NO videoSettingSize:CGSizeMake(fWidth, fHeight)];
    [self.renderView setFrame:rect];
}
-(void)setViewsHidden:(BOOL)bHidden {
    self.senseSettingView.hidden = bHidden;
    self.senseEffectsView.hidden = bHidden;
    self.senseBeautifyView.hidden = bHidden;
}
-(void)setButtonsHidden:(BOOL)bHidden {
    self.specialEffectsBtn.hidden = bHidden;
    self.beautyBtn.hidden = bHidden;
    self.btnSetting.hidden = bHidden;
    self.btnChangeCamera.hidden = bHidden;
    self.btnCompare.hidden = bHidden;
}

#pragma mark - SenseTouchViewDelegate
- (void)onTouchISOValueChange:(float) value {
    [self.stCamera setISOValue:value];
}
- (void)onTouchExposurePointChange:(CGPoint) point {
    // hidden view
    [self setViewsHidden:YES];
    // show btn
    [self setButtonsHidden:NO];
    
    [self.stCamera setExposurePoint:point inPreviewFrame:self.renderView.frame];
}

#pragma mark - SenseRecordDelegate
- (void)onOvertimeRecording {
    [self setButtonsHidden:NO];
}

#pragma mark - SenseEffectsViewDelegate
- (void)onDevicePositionChange:(AVCaptureDevicePosition)devicePosition {

    if (self.stCamera.devicePosition != devicePosition) {
        self.stCamera.devicePosition = devicePosition;
        [self.agoraKit switchCamera];
    }
}

#pragma mark - SenseTimeDelegate
- (void)onDetectFaceExposureChange {
    [self.stCamera setExposurePoint:self.renderView.center inPreviewFrame:self.renderView.frame];
    [self.stCamera setISOValue:140];
}
@end
