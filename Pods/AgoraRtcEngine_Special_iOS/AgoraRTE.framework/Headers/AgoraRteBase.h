//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraEnumerates.h>
#import "AgoraRteEnumerates.h"


extern NSString *const  _Nonnull kMediaPlayerRealTimeStreamAnalyzeDuration;
extern NSString *const  _Nonnull kMediaPlayerDisableAudio;
extern NSString *const  _Nonnull kMediaPlayerDisableVideo;


__attribute__((visibility("default"))) @interface AgoraRteInputSeiData:NSObject

/** SEI type */
@property (nonatomic, assign)NSInteger type;
/** the frame timestamp which be attached */
@property (nonatomic, assign)NSTimeInterval timestamp;
/** the frame index which be attached */
@property (nonatomic, assign)NSInteger frameIndex;
/** size of really data */
@property (nonatomic, assign)NSInteger dataSize;
/** SEI really data */
@property (nonatomic, strong)NSData * _Nullable privateData;

@end


/** The AgoraMediaStreamInfo class, reporting the whole detailed information of
 the media stream.
 */
__attribute__((visibility("default"))) @interface AgoraRteMediaStreamInfo : NSObject
/** The index of the media stream. */
@property(nonatomic, assign) NSInteger streamIndex;
/** The type of the media stream. See AgoraMediaStreamType for details. */
@property(nonatomic, assign) AgoraRteStreamType streamType;
/** The codec of the media stream. */
@property(nonatomic, copy) NSString *_Nonnull codecName;
/** The language of the media stream. */
@property(nonatomic, copy) NSString *_Nullable language;
/** For video stream, gets the frame rate (fps). */
@property(nonatomic, assign) NSInteger videoFrameRate;
/** For video stream, gets the bitrate (bps). */
@property(nonatomic, assign) NSInteger videoBitRate;
/** For video stream, gets the width (pixel) of the video. */
@property(nonatomic, assign) NSInteger videoWidth;
/** For video stream, gets the height (pixel) of the video. */
@property(nonatomic, assign) NSInteger videoHeight;
/** For the audio stream, gets the sample rate (Hz). */
@property(nonatomic, assign) NSInteger audioSampleRate;
/** For the audio stream, gets the channel number. */
@property(nonatomic, assign) NSInteger audioChannels;
/** The total duration (s) of the media stream. */
@property(nonatomic, assign) NSInteger duration;
/** The rotation of the video stream. */
@property(nonatomic, assign) NSInteger rotation;

@end


__attribute__((visibility("default"))) @interface AgoraRteVideoDeviceInfo:NSObject
@property (nonatomic,copy)NSString * _Nullable deviceName;
@property (nonatomic,copy)NSString * _Nullable deviceId;
@end




__attribute__((visibility("default")))
@interface AgoraRteSceneInfo : NSObject

@property (nonatomic, assign) AgoraRteSceneType  sceneType;
@property (nonatomic, copy) NSString * _Nullable scenceId;
@property (nonatomic, assign) AgoraRteConnectionState state;

@end



__attribute__((visibility("default")))
@interface AgoraRteCanvasConfig : NSObject

@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString * _Nullable imageFilePath;

@end;


__attribute__((visibility("default")))
@interface AgoraLayoutConfig : NSObject

@property (nonatomic, assign) AgoraRteLayoutType  layoutType;
@property (nonatomic, copy) NSString * _Nullable id;
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger zOrder;
@property (nonatomic, assign) NSInteger alpha;
@property (nonatomic, assign) BOOL mirror;
@property (nonatomic, copy) NSString *_Nullable imagePath;

@end


__attribute__((visibility("default")))
@interface AgoraRteLayoutConfigs : NSObject

@property (nonatomic, strong) AgoraRteCanvasConfig * _Nullable canvasConfig;
@property (nonatomic, strong) NSArray<AgoraLayoutConfig *> * _Nullable layouts;

@end


__attribute__((visibility("default")))
@interface AgoraRteUserInfo : NSObject

@property (nonatomic, assign) NSString * _Nullable userId;
@property (nonatomic, copy) NSString * _Nullable userName;

@end

__attribute__((visibility("default")))
@interface AgoraRteStreamInfo : NSObject

@property (nonatomic, copy) NSString * _Nullable streamId;
@property (nonatomic, copy) NSString * _Nullable userId;
@property (nonatomic, assign) NSInteger reversedId;

@end


@interface AgoraRteStreamOptions : NSObject
@property(nonatomic, copy)NSString * _Nullable token;
@property (nonatomic, assign) AgoraRteStreamType type;
- (void)assign:(AgoraRteStreamOptions * _Nonnull )options;
@end


__attribute__((visibility("default")))
@interface AgoraRteRtcStreamOptions :AgoraRteStreamOptions
- (void)assign:(AgoraRteStreamOptions * _Nonnull )options;

@end


__attribute__((visibility("default")))
@interface AgoraRteDirectCdnStreamOptions : AgoraRteStreamOptions
@property (nonatomic, copy) NSString *_Nullable url;
- (void)assign:(AgoraRteStreamOptions * _Nonnull )option;

@end



__attribute__((visibility("default")))
@interface AgoraRteVideoSubscribeOptions : NSObject
@property (nonatomic, assign)AgoraRteVideoStreamType videoStreamType;
@end


__attribute__((visibility("default")))
@interface AgoraRteSdkProfile : NSObject
@property (nonatomic, copy)NSString * _Nullable appid;
@property (nonatomic, assign)BOOL enableRteCompatibleMode;
@end


__attribute__((visibility("default")))
@interface AgoraRteLocalAudioObserverOptions : NSObject
@property (nonatomic, assign) BOOL afterRecord;
@property (nonatomic, assign) BOOL beforePlayBack;
@property (nonatomic, assign) BOOL afterMix;
@property (nonatomic, assign) NSInteger numberOfChannels;
@property (nonatomic, assign) NSInteger sampleRateHz;
@end

__attribute__((visibility("default")))
@interface AgoraRteRemoteAudioObserverOptions : NSObject
@property (nonatomic, assign) BOOL afterPlaybackBeforeMix;
@property (nonatomic, assign) NSInteger numberOfChannels;
@property (nonatomic, assign) NSInteger sampleRateHz;
@end


__attribute__((visibility("default")))
@interface AgoraRteAudioObserverOptions : NSObject
@property (nonatomic, strong) AgoraRteLocalAudioObserverOptions * _Nullable localOptions;
@property (nonatomic, strong) AgoraRteRemoteAudioObserverOptions * _Nullable remoteOptions;
@end



__attribute__((visibility("default")))
@interface AgoraRteAudioSceneConfig : NSObject
@property (nonatomic, assign) AgoraRteSceneType sceneType;
@property (nonatomic, assign) BOOL enableAudioRecordOrPlayout;
@end

__attribute__((visibility("default")))
@interface AgoraRteAudioEncoderConfiguration : NSObject
@property (nonatomic, assign) AgoraAudioProfile profile;
@end


__attribute__((visibility("default")))
@interface AgoraRteJoinOptions : NSObject
@property (nonatomic, assign)BOOL isUserVisibleToRemote;
@end


__attribute__((visibility("default")))
@interface AgoraRteSceneConfg : NSObject
@property (nonatomic, assign) AgoraRteSceneType sceneType;
@end




#if (!(TARGET_OS_IPHONE) && (TARGET_OS_MAC))

/** AgoraRtcDeviceInfo array.
 */
__attribute__((visibility("default"))) @interface AgoraRteDeviceInfo : NSObject
@property (assign, nonatomic) NSInteger  index;

/** AgoraMediaDeviceType
 */
@property(assign, nonatomic) AgoraRteMediaDeviceType type;

/** Device ID.
 */
@property(copy, nonatomic) NSString *_Nullable deviceId;

/** Device name.
 */
@property(copy, nonatomic) NSString *_Nullable deviceName;
@end
#endif

__attribute__((visibility("default"))) @interface AgoraRtePlayerStatus : NSObject
@property (assign, nonatomic) NSInteger currentFileId;
@property (assign, nonatomic) NSInteger currentFileDuration;
@property (assign, nonatomic) NSInteger currentFileIndex;
@property (assign, nonatomic) NSInteger currentFileBeginTime;
@property (assign, nonatomic) AgoraMediaPlayerState state;
@property (assign, nonatomic) NSInteger progressPosition;
/** AgoraMediaDeviceType
 */

/** Device ID.
 */
@property(copy, nonatomic) NSString *_Nullable currentFileUrl;

/** Device name.
 */
@property(copy, nonatomic) NSString *_Nullable deviceName;
@end



__attribute__((visibility("default")))
@interface AgoraRteSceneStats : NSObject

/**
   * The total number of bytes transmitted, represented by an aggregate value.
   * The sum of all streams.
   */
@property(assign, nonatomic) NSInteger txBytes;
/**
 * The total number of bytes received, represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxBytes;
/**
 * The total number of audio bytes sent (bytes), represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger txAudioBytes;
/**
 * The total number of video bytes sent (bytes), represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger txVideoBytes;
/**
 * The total number of audio bytes received (bytes), represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxAudioBytes;
/**
 * The total number of video bytes received (bytes), represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxVideoBytes;
/**
 * The transmission bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger txKBitRate;
/**
 * The receiving bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxKBitRate;
/**
 * The audio transmission bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger txAudioKBitRate;
/**
 * Audio receiving bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxAudioKBitRate;
/**
 * The video transmission bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger txVideoKBitRate;
/**
 * The video receive bitrate (Kbps), represented by an instantaneous value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSInteger rxVideoKBitRate;
/**
 * The call duration (s), represented by an aggregate value.
 * The sum of all streams.
 */
@property(assign, nonatomic) NSUInteger duration;
/**
 * The system CPU usage (%).
 * Only the value of major stream.
 */
@property(assign, nonatomic) double cpuTotalUsage;
/**
 * The app CPU usage (%).
 * Only the value of major stream.
 */
@property(assign, nonatomic) double cpuAppUsage;
/**
 * The memory usage ratio of the app (%).
 * Only the value of major stream.
 */
@property(assign, nonatomic) double memoryAppUsageRatio;
/**
 * The memory usage ratio of the system (%).
 * Only the value of major stream.
 */
@property(assign, nonatomic) double memoryTotalUsageRatio;
/**
 * The memory usage of the app (KB).
 * Only the value of major stream.
 */
@property(assign, nonatomic) NSUInteger memoryAppUsageInKbytes;

@end

__attribute__((visibility("default")))
@interface AgoraRteLocalAudioStats : NSObject

/**
 * The number of audio channels.
 */
@property(assign, nonatomic) NSInteger numChannels;
/**
 * The sample rate (Hz).
 */
@property(assign, nonatomic) NSInteger sentSampleRate;
/**
 * The average sending bitrate (Kbps).
 */
@property(assign, nonatomic) NSInteger sentBitrate;
/**
 * The internal payload type
 */
@property(assign, nonatomic) NSInteger internalCodec;

@end

__attribute__((visibility("default")))
@interface AgoraRteLocalVideoStats : NSObject

/**
 * The encoder output frame rate (fps) of the local video.
 */
@property(assign, nonatomic) NSInteger encoderOutputFrameRate;
/**
 * The render output frame rate (fps) of the local video.
 */
@property(assign, nonatomic) NSInteger rendererOutputFrameRate;
/**
 * The width of the encoding frame (px).
 */
@property(assign, nonatomic) NSInteger encodedFrameWidth;
/**
 * The height of the encoding frame (px).
 */
@property(assign, nonatomic) NSInteger encodedFrameHeight;
/**
 * The value of the sent frames, represented by an aggregate value.
 */
@property(assign, nonatomic) NSInteger encodedFrameCount;

@end

__attribute__((visibility("default")))
@interface AgoraRteLocalStreamStats : NSObject

@property(strong, nonatomic) AgoraRteLocalAudioStats *_Nullable audioStats;
@property(strong, nonatomic) AgoraRteLocalVideoStats *_Nullable videoStats;

@end

__attribute__((visibility("default")))
@interface AgoraRteRemoteAudioStats : NSObject

/**
 * The quality of the remote audio: #QUALITY_TYPE.
 */
@property(assign, nonatomic) NSInteger quality;
/**
 * The network delay (ms) from the sender to the receiver.
 */
@property(assign, nonatomic) NSInteger networkTransportDelay;
/**
 * The network delay (ms) from the receiver to the jitter buffer.
 */
@property(assign, nonatomic) NSInteger jitterBufferDelay;
/**
 * The audio frame loss rate in the reported interval.
 */
@property(assign, nonatomic) NSInteger audioLossRate;
/**
 * The number of channels.
 */
@property(assign, nonatomic) NSInteger numChannels;
/**
 * The sample rate (Hz) of the remote audio stream in the reported interval.
 */
@property(assign, nonatomic) NSInteger receivedSampleRate;
/**
 * The average bitrate (Kbps) of the remote audio stream in the reported
 * interval.
 */
@property(assign, nonatomic) NSInteger receivedBitrate;
/**
 * The total freeze time (ms) of the remote audio stream after the remote
 * user joins the channel.
 *
 * In a session, audio freeze occurs when the audio frame loss rate reaches 4%.
 */
@property(assign, nonatomic) NSInteger totalFrozenTime;
/**
 * The total audio freeze time as a percentage (%) of the total time when the
 * audio is available.
 */
@property(assign, nonatomic) NSInteger frozenRate;
/**
 * The quality of the remote audio stream as determined by the Agora
 * real-time audio MOS (Mean Opinion Score) measurement method in the
 * reported interval. The return value ranges from 0 to 500. Dividing the
 * return value by 100 gets the MOS score, which ranges from 0 to 5. The
 * higher the score, the better the audio quality.
 *
 * | MOS score       | Perception of audio quality                                                                                                                                 |
 * |-----------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
 * | Greater than 4  | Excellent. The audio sounds clear and smooth.                                                                                                               |
 * | From 3.5 to 4   | Good. The audio has some perceptible impairment, but still sounds clear.                                                                                    |
 * | From 3 to 3.5   | Fair. The audio freezes occasionally and requires attentive listening.                                                                                      |
 * | From 2.5 to 3   | Poor. The audio sounds choppy and requires considerable effort to understand.                                                                               |
 * | From 2 to 2.5   | Bad. The audio has occasional noise. Consecutive audio dropouts occur, resulting in some information loss. The users can communicate only with difficulty.  |
 * | Less than 2     | Very bad. The audio has persistent noise. Consecutive audio dropouts are frequent, resulting in severe information loss. Communication is nearly impossible. |
 */
@property(assign, nonatomic) NSInteger mosValue;

@end

__attribute__((visibility("default")))
@interface AgoraRteRemoteVideoStats : NSObject

/**
 * @deprecated Time delay (ms).
 *
 * In scenarios where audio and video is synchronized, you can use the
 * value of `networkTransportDelay` and `jitterBufferDelay` in `RemoteAudioStats`
 * to know the delay statistics of the remote video.
 */
@property(assign, nonatomic) NSInteger delay;
/**
 * The width (pixels) of the video stream.
 */
@property(assign, nonatomic) NSInteger width;
/**
 * The height (pixels) of the video stream.
 */
@property(assign, nonatomic) NSInteger height;
/**
 * Bitrate (Kbps) received since the last count.
 */
@property(assign, nonatomic) NSInteger receivedBitrate;
/**
 * The decoder output frame rate (fps) of the remote video.
 */
@property(assign, nonatomic) NSInteger decoderOutputFrameRate;
/**
 * The render output frame rate (fps) of the remote video.
 */
@property(assign, nonatomic) NSInteger rendererOutputFrameRate;
/**
 * The video frame loss rate (%) of the remote video stream in the reported interval.
 */
@property(assign, nonatomic) NSInteger frameLossRate;
/**
 * Packet loss rate (%) of the remote video stream after using the anti-packet-loss method.
 */
@property(assign, nonatomic) NSInteger packetLossRate;
/**
 * The type of the remote video stream: #VIDEO_STREAM_TYPE.
 */
// TODO: VIDEO_STREAM_TYPE
@property(assign, nonatomic) NSInteger rxStreamType;
/**
 * The total freeze time (ms) of the remote video stream after the remote user joins the channel.
 * In a video session where the frame rate is set to no less than 5 fps, video freeze occurs when
 * the time interval between two adjacent renderable video frames is more than 500 ms.
 */
@property(assign, nonatomic) NSInteger totalFrozenTime;
/**
 * The total video freeze time as a percentage (%) of the total time when the video is available.
 */
@property(assign, nonatomic) NSInteger frozenRate;
/**
 * The offset (ms) between audio and video stream. A positive value indicates the audio leads the
 * video, and a negative value indicates the audio lags the video.
 */
@property(assign, nonatomic) NSInteger avSyncTimeMs;

@end

__attribute__((visibility("default")))
@interface AgoraRteRemoteStreamStats : NSObject

@property(strong, nonatomic) AgoraRteRemoteAudioStats * _Nullable audioStats;
@property(strong, nonatomic) AgoraRteRemoteVideoStats * _Nullable videoStats;

@end

__attribute__((visibility("default")))
@interface AgoraRteAudioVolumeInfo : NSObject

/**
 * User ID of the speaker.
 */
@property(copy, nonatomic) NSString * _Nullable userId;
/**
 * The volume of the speaker that ranges from 0 to 255.
 */
@property(assign, nonatomic) NSUInteger volume;  // [0,255]

@end

__attribute__((visibility("default")))
@interface AgoraRtePlayerStreamInfo : NSObject
/** The index of the media stream. */
@property(assign, nonatomic) NSUInteger streamIndex;

/** The type of the media stream. See {@link MEDIA_STREAM_TYPE}. */
@property(assign, nonatomic) AgoraRteMediaStreamType streamType;

/** The frame rate (fps) if the stream is video. */
@property(assign, nonatomic) NSUInteger videoFrameRate;

/** The video bitrate (bps) if the stream is video. */
@property(assign, nonatomic) NSUInteger videoBitRate;

/** The video width (pixel) if the stream is video. */
@property(assign, nonatomic) NSUInteger videoWidth;

/** The video height (pixel) if the stream is video. */
@property(assign, nonatomic) NSUInteger videoHeight;

/** The rotation angle if the steam is video. */
@property(assign, nonatomic) NSUInteger videoRotation;

/** The sample rate if the stream is audio. */
@property(assign, nonatomic) NSUInteger audioSampleRate;

/** The number of audio channels if the stream is audio. */
@property(assign, nonatomic) NSUInteger audioChannels;

/** The number of bits per sample if the stream is audio. */
@property(assign, nonatomic) NSUInteger audioBitsPerSample;

/** The total duration (second) of the media stream. */
@property(assign, nonatomic) NSUInteger duration;

@end

__attribute__((visibility("default")))
@interface AgoraRteStreamingSourceStatus : NSObject

@property (nonatomic, assign) NSInteger currentFileId;
@property (nonatomic, assign) NSInteger currentFileDuration;
@property (nonatomic, assign) NSInteger currentFileIndex;
@property (nonatomic, assign) NSInteger currentFileBeginTime;
@property (nonatomic, assign) NSInteger progressPosition;
@property (nonatomic, assign) AgoraRteStreamingSrcStatus sourceState;

@end
