//
//  EFAVPlayer.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/29.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFAVPlayer.h"

@interface EFAVPlayer ()<AVPlayerItemOutputPullDelegate>
@property (nonatomic, readwrite, assign) BOOL playing;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic) dispatch_queue_t videoOutputQueue;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) id notificationToken;
@property (nonatomic) id timeObserve;
@end

@implementation EFAVPlayer

- (instancetype)initWithURL:(NSURL *)url{
    if (!url) return nil;
    self = [super init];
    self.videoURL = url;
    [self setupPlayer:url];
    return self;
}

#pragma mark - public
- (void)play{
    _playing = YES;
    [_avPlayer replaceCurrentItemWithPlayerItem:_playerItem];
    [_avPlayer.currentItem seekToTime:kCMTimeZero];
    [_avPlayer play];
}

- (void)stop{
    _playing = NO;
    [_avPlayer pause];
}

#pragma mark - private

- (void)setupPlayer:(NSURL *)url{
    //player
    self.avPlayer = [[AVPlayer alloc] init];
    NSDictionary *pixelBufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixelBufferAttributes];
    self.videoOutputQueue = dispatch_queue_create("com.sensetime.videoOutputQueue", NULL);
    [self.videoOutput setDelegate:self queue:_videoOutputQueue];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [item addOutput:_videoOutput];
    self.playerItem = item;
    
    //timer
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink.paused = YES;
    
    //get the first frame
    [_avPlayer replaceCurrentItemWithPlayerItem:item];
    _avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [_videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:0.04];
    
    __weak __typeof(self) weakSelf = self;
    _notificationToken = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:item queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [[weakSelf.avPlayer currentItem] seekToTime:kCMTimeZero];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didPlayToEnd)]) {
            [weakSelf.delegate didPlayToEnd];
        }
    }];
    
    [self getVideoRotate];
}

- (void)getVideoRotate{
    AVAsset *asset = [AVAsset assetWithURL:self.videoURL];
    NSArray<AVAssetTrack *> *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    CGSize videoSize = videoTracks[0].naturalSize;
    int _width = videoSize.width;
    int _height = videoSize.height;
    
    
    CGFloat width = _width, height = _height;
    CGAffineTransform transform = videoTracks[0].preferredTransform;
    CGFloat videoAngleInDegree = atan2(transform.b, transform.a) * 180 / M_PI;
    if (videoAngleInDegree == 0.0) {
        _rotateType = ST_CLOCKWISE_ROTATE_0;
        _tranform = CGAffineTransformIdentity;
    } else if (videoAngleInDegree == 90.0) {
        _rotateType = ST_CLOCKWISE_ROTATE_90;
        _tranform = CGAffineTransformMakeRotation(M_PI / 2);
        width = _height;
        height = _width;
    } else if (videoAngleInDegree == -90.0) {
        _rotateType = ST_CLOCKWISE_ROTATE_270;
        _tranform = CGAffineTransformMakeRotation(-M_PI / 2);
        width = _height;
        height = _width;
    } else {
        _rotateType = ST_CLOCKWISE_ROTATE_180;
        _tranform = CGAffineTransformMakeRotation(M_PI);
    }

    _videoSize = CGSizeMake(width, height);
}

- (void)displayLinkCallback:(CADisplayLink *)sender{
    CMTime outputItemTime = kCMTimeInvalid;
    CFTimeInterval nextVSync = sender.timestamp + sender.duration;
    outputItemTime = [_videoOutput itemTimeForHostTime:nextVSync];
    if ([self.videoOutput hasNewPixelBufferForItemTime:outputItemTime]) {
        CVPixelBufferRef videoPixelbuffer = [_videoOutput copyPixelBufferForItemTime:outputItemTime itemTimeForDisplay:NULL];
        [self.delegate didOutputPixelbuffer:videoPixelbuffer
                                     CMTime:outputItemTime];
    }
}

#pragma mark - AVPlayerItemOutputPullDelegate
- (void)outputMediaDataWillChange:(AVPlayerItemOutput *)sender {
    self.displayLink.paused = NO;
}

@end
