//
//  ViewController.m
//  BeautifyExample
//
//  Created by LSQ on 2020/8/3.
//  Copyright © 2020 Agora. All rights reserved.
//


#import "ViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import "KeyCenter.h"
#import "EFMotionManager.h"
#import "VideoProcessingManager.h"

@interface ViewController () <AgoraRtcEngineDelegate, AgoraVideoFrameDelegate>

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

@property (nonatomic, strong) VideoProcessingManager *videoProcessing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkLicense];
}

//使用license进行本地鉴权
- (void)checkLicense {
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:@"SENSEME" ofType:@"lic"];
    BOOL isSuccess = [EffectsProcess authorizeWithLicensePath:licensePath];
    if (isSuccess) {
        [self setup];
    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"license 验证失败" message:@"请检查license文件" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)setup {
    // Do any additional setup after loading the view.
    self.remoteView.hidden = YES;
    // 初始化 rte engine
    AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
    config.appId = [KeyCenter AppId];
    config.channelProfile = AgoraChannelProfileLiveBroadcasting;
    self.rtcEngineKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
    
    [self.rtcEngineKit setVideoFrameDelegate:self];
    [self.rtcEngineKit setClientRole:AgoraClientRoleBroadcaster];
    AgoraCameraCapturerConfiguration *captuer = [[AgoraCameraCapturerConfiguration alloc] init];
    captuer.cameraDirection = AgoraCameraDirectionFront;
    [self.rtcEngineKit setCameraCapturerConfiguration:captuer];
    
    [self.rtcEngineKit enableVideo];
    [self.rtcEngineKit enableAudio];
    
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] init];
//    configuration.dimensions = CGSizeMake(360, 640);
//    configuration.dimensions = CGSizeMake(720, 1280);

    [self.rtcEngineKit setVideoEncoderConfiguration: configuration];
    AgoraRtcChannelMediaOptions *option = [[AgoraRtcChannelMediaOptions alloc] init];
    option.clientRoleType = [AgoraRtcIntOptional of: AgoraClientRoleBroadcaster];
    option.publishMicrophoneTrack = [AgoraRtcBoolOptional of:YES];
    option.publishCameraTrack = [AgoraRtcBoolOptional of:YES];
    [self.rtcEngineKit joinChannelByToken:nil channelId:self.channelName uid:0 mediaOptions:option joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) { }];
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
    
    videoCanvas.view = self.localView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    // Bind remote video stream to view
    [self.rtcEngineKit setupLocalVideo:videoCanvas];
    [self.rtcEngineKit startPreview];
    
    self.videoProcessing = [VideoProcessingManager new];
}

/// release
- (void)dealloc {

    [self.rtcEngineKit leaveChannel:nil];
    [self.rtcEngineKit stopPreview];
    [AgoraRtcEngineKit destroy];
}


- (IBAction)switchCamera:(UIButton *)button
{
    [self.rtcEngineKit switchCamera];
}

- (IBAction)toggleRemoteMirror:(UIButton *)button
{
    self.remoteVideoMirrored = self.remoteVideoMirrored == AgoraVideoMirrorModeEnabled ? AgoraVideoMirrorModeDisabled : AgoraVideoMirrorModeEnabled;
    [self.rtcEngineKit setLocalRenderMode:AgoraVideoRenderModeHidden mirror:self.remoteVideoMirrored];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"join uid === %lu", uid);
}

- (BOOL)onCaptureVideoFrame:(AgoraOutputVideoFrame *)videoFrame {
    CVPixelBufferRef pixelBuffer = [self.videoProcessing videoProcessHandler:videoFrame.pixelBuffer];
    videoFrame.pixelBuffer = pixelBuffer;
    return YES;
}

- (AgoraVideoFormat)getVideoPixelFormatPreference{
    return AgoraVideoFormatBGRA;
}
- (AgoraVideoFrameProcessMode)getVideoFrameProcessMode{
    return AgoraVideoFrameProcessModeReadWrite;
}

- (BOOL)getMirrorApplied{
    return YES;
}

- (BOOL)getRotationApplied{
    return NO;
}

@end
