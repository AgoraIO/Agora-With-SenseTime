//
//  ViewController.m
//  BeautifyExample
//
//  Created by LSQ on 2020/8/3.
//  Copyright © 2020 Agora. All rights reserved.
//


#import "ViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "EffectsGLPreview.h"
#import "KeyCenter.h"
#import "EFMotionManager.h"
#import "CapturerManager.h"

//#import "SenseMeFilter.h"

@interface ViewController () <AgoraRtcEngineDelegate>
{
    CVOpenGLESTextureCacheRef _cvTextureCache;
    
    @public
    GLuint _outTexture;
    CVPixelBufferRef _outputPixelBuffer;
    CVOpenGLESTextureRef _outputCVTexture;
    BOOL _isFirstLaunch;
}
@property (nonatomic, strong) CapturerManager *capturerManager;
@property (nonatomic, strong) EffectsGLPreview *effecgGLPreview;

///贴纸id
@property (nonatomic, assign) int stickerId;

@property (nonatomic, strong) AgoraRtcEngineKit *rtcEngineKit;
@property (nonatomic, strong) IBOutlet UIView *localView;

@property (weak, nonatomic) IBOutlet UIView *remoteView;

@property (nonatomic, strong) IBOutlet UIButton *switchBtn;
@property (nonatomic, strong) IBOutlet UIButton *remoteMirrorBtn;
@property (nonatomic, strong) IBOutlet UILabel *beautyStatus;
@property (nonatomic, strong) IBOutlet UIView *missingAuthpackLabel;
@property (nonatomic, strong) AgoraRtcVideoCanvas *videoCanvas;
@property (nonatomic, assign) AgoraVideoMirrorMode localVideoMirrored;
@property (nonatomic, assign) AgoraVideoMirrorMode remoteVideoMirrored;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.remoteView.hidden = YES;
    // 初始化 rte engine
    self.rtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter AppId] delegate:self];
    
    [self.rtcEngineKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.rtcEngineKit setClientRole:AgoraClientRoleBroadcaster];
    [self.rtcEngineKit enableVideo];
    AgoraVideoEncoderConfiguration* config = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(720, 1280) frameRate:15 bitrate:0 orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    [self.rtcEngineKit setVideoEncoderConfiguration:config];

    [self.localView layoutIfNeeded];
    self.effecgGLPreview = [[EffectsGLPreview alloc] initWithFrame: self.localView.frame context:nil];
    [self.localView addSubview:self.effecgGLPreview];
    
    self.capturerManager = [[CapturerManager alloc] init];

    [self.capturerManager startCapture];
    
    [self.capturerManager setEffecgGLPreview:self.effecgGLPreview];
    // set custom capturer as video source
    [self.rtcEngineKit setVideoSource:self.capturerManager];
    
    [self.rtcEngineKit joinChannelByToken:nil channelId:self.channelName info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        
    }];
}

/// release
- (void)dealloc {

    [self.capturerManager stopCapture];
    [self.rtcEngineKit leaveChannel:nil];
    [self.rtcEngineKit stopPreview];
    [self.rtcEngineKit setVideoSource:nil];
    [AgoraRtcEngineKit destroy];
}


- (IBAction)switchCamera:(UIButton *)button
{
    [self.capturerManager switchCamera];
}

- (IBAction)toggleRemoteMirror:(UIButton *)button
{
    self.remoteVideoMirrored = self.remoteVideoMirrored == AgoraVideoMirrorModeEnabled ? AgoraVideoMirrorModeDisabled : AgoraVideoMirrorModeEnabled;
    AgoraVideoEncoderConfiguration* config = [[AgoraVideoEncoderConfiguration alloc] initWithSize:CGSizeMake(720, 1280) frameRate:30 bitrate:0 orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    config.mirrorMode = self.remoteVideoMirrored;
    [self.rtcEngineKit setVideoEncoderConfiguration:config];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    if (self.remoteView.hidden) {
        self.remoteView.hidden = NO;
    }
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
    
    videoCanvas.view = self.remoteView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    // Bind remote video stream to view
    [self.rtcEngineKit setupRemoteVideo:videoCanvas];
    
}


@end
