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

#import "KeyCenter.h"

#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

#import <AGMCapturer/AGMCapturer.h>
#import "AGMSenceTimeFilter.h"

typedef NS_ENUM(NSInteger, STViewTag) {
    
    STViewTagSpecialEffectsBtn = 10000,
    STViewTagBeautyBtn,
};

@interface ViewController () <STViewButtonDelegate, SenseSettingDelegate, SenseTouchViewDelegate, SenseRecordDelegate, SenseEffectsViewDelegate, SenseTimeDelegate, AgoraRtcEngineDelegate, AgoraVideoSourceProtocol, AGMVideoSink> {

}

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

#pragma Capturer
@property (nonatomic, strong) AGMCameraCapturer *cameraCapturer;
@property (nonatomic, strong) AGMSenceTimeFilter *senceTimeFilter;
@property (nonatomic, strong) AGMCapturerVideoConfig *videoConfig;

@property (nonatomic, strong) UIView *preview;

#pragma Agora
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
        [weakSelf initCapturer];
        [weakSelf initSenseModule];
        [weakSelf setupSubviews];
        [weakSelf loadAgoraKit];
    }];
    self.senseTimeManager.senseTimeDelegate = self;
}

- (void)initCapturer
{
#pragma mark Capturer
{
    self.videoConfig = [AGMCapturerVideoConfig defaultConfig];
    self.videoConfig.videoSize = CGSizeMake(480, 640);
    self.videoConfig.sessionPreset = AGMCaptureSessionPreset480x640;
    self.videoConfig.fps = 15;
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGFloat fWidth = self.videoConfig.videoSize.width;
    CGFloat fHeight = self.videoConfig.videoSize.height;
    rect = [SenseTimeUtil getZoomedRectWithRect:rect scaleToFit:NO videoSettingSize:CGSizeMake(fWidth, fHeight)];
    self.cameraCapturer = [[AGMCameraCapturer alloc] initWithConfig:self.videoConfig];
    
#pragma mark Filter
    self.senceTimeFilter = [[AGMSenceTimeFilter alloc] init];
    self.senceTimeFilter.senseTimeManager = self.senseTimeManager;
    
    __weak typeof(self) weakSelf = self;
    self.senceTimeFilter.didCompletion = ^(CVPixelBufferRef  _Nonnull originalPixelBuffer, CVPixelBufferRef  _Nonnull resultPixelBuffer, CMTime timeStamp) {
        
//        // for snap button
//        [weakSelf.senseRecordView captureOutputOriginalCVPixelBufferRef:originalPixelBuffer resultCVPixelBufferRef:resultPixelBuffer timeStamp:timeStamp];
        if (weakSelf.needSnap) {
            weakSelf.needSnap = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                CGSize previewSize = weakSelf.preview.frame.size;
                [SenseTimeUtil snapWithView:weakSelf.preview width:previewSize.width height:previewSize.height];
            });
        }
        // write to file
        [weakSelf.senseRecordView captureOutputPixelBufferRef:resultPixelBuffer timeStamp:timeStamp];

        // push video frame to agora
        AgoraVideoRotation agoraRotation = [weakSelf agoraRotation];
        [weakSelf.consumer consumePixelBuffer:resultPixelBuffer withTimestamp:timeStamp rotation:AgoraVideoRotationNone];

        double dAttributeStart = CFAbsoluteTimeGetCurrent();

        [weakSelf updatAttributeInfo:dAttributeStart];
        
    };
    
#pragma mark Renderer
    self.preview = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.preview];
    
#pragma mark VideoFrameAdapter
    AGMVideoAdapterFilter *videoAdapterFilter = [[AGMVideoAdapterFilter alloc] init];
    #define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)
    CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(90) );
    videoAdapterFilter.affineTransform = rotation;
    videoAdapterFilter.ignoreAspectRatio = YES;
    videoAdapterFilter.isMirror = YES;
#pragma mark Connect
    [self.cameraCapturer addVideoSink:videoAdapterFilter];
    [videoAdapterFilter addVideoSink:self.senceTimeFilter];
#pragma mark
    self.senceTimeFilter.devicePosition = self.cameraCapturer.captureDevicePosition;
    self.senceTimeFilter.isVideoMirrored = YES;
}
}

-(void)initSenseModule {
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

-(void)leaveRTC {
    [self.agoraKit stopPreview];
    [self.agoraKit leaveChannel:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.senseTimeManager = nil;
    
    [self.cameraCapturer stop];
    
    [self.senseTimeManager releaseResources];
    
    [self leaveRTC];
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
    
    if (self.cameraCapturer.captureDevicePosition == AVCaptureDevicePositionFront) {
        self.cameraCapturer.captureDevicePosition = AVCaptureDevicePositionBack;
    } else {
        self.cameraCapturer.captureDevicePosition = AVCaptureDevicePositionFront;
    }
    self.senceTimeFilter.devicePosition = self.cameraCapturer.captureDevicePosition;
    [self.agoraKit switchCamera];
}

- (void)onBtnSetting {
    if (self.senseSettingView.isHidden) {
        [self setViewsHidden:YES];
        self.senseSettingView.hidden = NO;
        self.beautyBtn.hidden = YES;
        self.specialEffectsBtn.hidden = YES;
    } else {
        [self setButtonsHidden:NO];
        self.senseSettingView.hidden = YES;
        self.beautyBtn.hidden = NO;
        self.specialEffectsBtn.hidden = NO;
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
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter agoraAppId] delegate: self];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    self.agoraKit.delegate = self;
    [self.agoraKit setVideoEncoderConfiguration:[[AgoraVideoEncoderConfiguration alloc] initWithSize:AgoraVideoDimension640x360
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
    
    [self.agoraKit joinChannelByToken:[KeyCenter agoraAppToken] channelId:self.channelName info:nil uid:0 joinSuccess:nil];
    
}

- (void)setupLocalView {
    if (self.localCanvas == nil) {
        self.localCanvas = [[AgoraRtcVideoCanvas alloc] init];
    }
    self.localCanvas.view = self.preview;
    self.localCanvas.renderMode = AgoraVideoRenderModeHidden;
//     set render view
    [self.agoraKit setupLocalVideo:self.localCanvas];
    [self.agoraKit setLocalVideoMirrorMode:AgoraVideoMirrorModeDisabled];
    self.localRenderView = self.preview;
}

#pragma mark - Agora Video Source Protocol
- (BOOL)shouldInitialize {
    return YES;
}

- (void)shouldStart {
    [self.cameraCapturer start];
}

- (void)shouldStop {
    [self.cameraCapturer stop];
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
    
    [self.senseRecordView startRecorder:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    if (self.cameraCapturer.sessionPreset != AGMCaptureSessionPreset480x640) {
        [self.senseEffectsView resetCommonObjectViewPosition];
        [self.cameraCapturer setSessionPreset:AGMCaptureSessionPreset480x640];
    }
    self.pauseOutput = NO;
}

- (void)changeResolution1280x720 {
    self.pauseOutput = YES;

    if (self.cameraCapturer.sessionPreset != AGMCaptureSessionPreset720x1280) {
        [self.senseEffectsView resetCommonObjectViewPosition];
        [self.cameraCapturer setSessionPreset:AGMCaptureSessionPreset720x1280];
    }
    
    self.pauseOutput = NO;
}

- (void)changeAttribute:(BOOL)bShow {
    self.senseAttributeView.hidden = !bShow;
}

#pragma mark -- Private Function

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
    [self.cameraCapturer setISOValue:value];
}
- (void)onTouchExposurePointChange:(CGPoint) point {
    // hidden view
    [self setViewsHidden:YES];
    // show btn
    [self setButtonsHidden:NO];
    
    [self.cameraCapturer setExposurePoint:point inPreviewFrame:self.preview.frame];
}

#pragma mark - SenseRecordDelegate
- (void)onOvertimeRecording {
    [self setButtonsHidden:NO];
}

#pragma mark - SenseEffectsViewDelegate
- (void)onDevicePositionChange:(AVCaptureDevicePosition)devicePosition {

    [self.cameraCapturer switchCamera];
    [self.agoraKit switchCamera];
}

#pragma mark - SenseTimeDelegate
- (void)onDetectFaceExposureChange {
    [self.cameraCapturer setExposurePoint:self.preview.center inPreviewFrame:self.preview.frame];
    [self.cameraCapturer setISOValue:140];
}
@end
