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

#import "SenseMeFilter.h"

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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    captuer.cameraPixelFormat = kCVPixelFormatType_32BGRA;
    captuer.cameraDirection = AgoraCameraDirectionFront;
    [self.rtcEngineKit setCameraCapturerConfiguration:captuer];
    
    [self.rtcEngineKit enableVideo];
    [self.rtcEngineKit startPreview];
    
    AgoraVideoEncoderConfiguration *configuration = [[AgoraVideoEncoderConfiguration alloc] init];
//    configuration.dimensions = CGSizeMake(360, 640);
//    configuration.dimensions = CGSizeMake(720, 1280);

    [self.rtcEngineKit setVideoEncoderConfiguration: configuration];
    AgoraRtcChannelMediaOptions *option = [[AgoraRtcChannelMediaOptions alloc] init];
    option.clientRoleType = [AgoraRtcIntOptional of: AgoraClientRoleBroadcaster];
    option.publishAudioTrack = [AgoraRtcBoolOptional of:YES];
    option.publishCameraTrack = [AgoraRtcBoolOptional of:YES];
    [self.rtcEngineKit joinChannelByToken:nil channelId:self.channelName uid:0 mediaOptions:option joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) { }];
    
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
    
    videoCanvas.view = self.localView;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    // Bind remote video stream to view
    [self.rtcEngineKit setupLocalVideo:videoCanvas];
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
    [self.rtcEngineKit setRemoteRenderMode:0 mode:(AgoraVideoRenderModeHidden) mirror:self.remoteVideoMirrored];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {

//    if (self.remoteView.hidden) {
//        self.remoteView.hidden = NO;
//    }
    
//    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
//    videoCanvas.uid = uid;
//    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
//
//    videoCanvas.view = self.localView;
//    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
//    // Bind remote video stream to view
//    [self.rtcEngineKit setupLocalVideo:videoCanvas];
    
}

-(void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    NSLog(@" errorCode == %ld", (long)errorCode);
}


- (BOOL)onCaptureVideoFrame:(AgoraOutputVideoFrame *)srcFrame dstFrame:(AgoraOutputVideoFrame * _Nullable __autoreleasing *)dstFrame{
    CVPixelBufferRef pixelBuffer = [[SenseMeFilter shareManager] processFrame:srcFrame.pixelBuffer];
    srcFrame.pixelBuffer = pixelBuffer;
    *dstFrame = srcFrame;
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

- (NSInteger)getRotationApplied{
    return 0;
}


@end
