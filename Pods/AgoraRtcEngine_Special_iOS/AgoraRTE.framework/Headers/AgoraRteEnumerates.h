//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AgoraRtetreamStateChangedReason) 
{
      /**
   * 1: The stream is published to network.
   */
  AgoraRtetreamStateChangedReasonPublished = 1,
  /**
   * 2: The stream is unpublished.
   */
  AgoraRtetreamStateChangedReasonUnpublished,
  /**
   * 3: The stream is subscribed and we have received data from the stream.
   */
  AgoraRtetreamStateChangedReasonSubscribed,
  // TODO (yejun): Need to confirm with team that the stream will get unsubscribed if remote host pause the stream
  /**
   * 4: The stream is unsubscribed.
   */
  AgoraRtetreamStateChangedReasonUnsubscribed,

};


typedef NS_ENUM(NSInteger, AgoraRteCameraSource) 
{
  /**
   * The camera source is the rear camera.
   */
  AgoraRteCameraSourceBack,
  /**
   * The camera source is the front camera.
   */
  AgoraRteCameraSourceFront,

};
typedef NS_ENUM(NSInteger,AgoraRteCameraState)
{
  /**
   * The camera is started.
   */
    AgoraRteCameraStateStarted,
  /**
   * The camera is stopped.
   */
    AgoraRteCameraStateStopped,

};

typedef NS_ENUM(NSInteger,AgoraRteLayoutType)
{
      /**
   * Apply layout setting for image defined in LayoutConfig.
   */
  AgoraRteLayoutTypeImage,
  /**
   * Apply layout setting for track which will apply the LayoutConfig.
   */
  AgoraRteLayoutTypeTrack,

};


typedef NS_ENUM(NSInteger,AgoraRteConnectionState)
{
  /**
   * The connection is disconnected from the server.
   */
  AgoraRteConnectionStateDisconnected,
  /**
   * The connection is disconnecting to the server.
   */
  AgoraRteConnectionStateDisconnecting,
  /**
   * The connection is connecting to the server.
   */
  AgoraRteConnectionStateConnecting,
  /**
   * The connection is connected to the server and has joined a scene.
   * You can now publish or subscribe data through the stream now.
   */
  AgoraRteConnectionStateConnected,
  /**
   * The connection keeps rejoining the scene after being disconnected,probably
   * because of network issues.
   */
  AgoraRteConnectionStateReconnecting,
  /**
   * The connection failed to connect to the server or join the scene
   */
  AgoraRteConnectionStateFailed    

};


typedef NS_ENUM(NSInteger,AgoraRteStreamMediaState)

{
     /**
   * For local stream, no data is sent to the stream
   * For remote stream, not data is received from the stream
   */
  AgoraRteStreamMediaStateIdle,
  /**
   * For local stream, there is data sent to the stream
   * For remote stream, there is data received from the stream
   */
  AgoraRteStreamMediaStateStreaming,

};

typedef NS_ENUM(NSInteger,AgoraRteSourceType)

{
  /**
   * No source type is assigned, default value
   */
  AgoraRteSourceTypeNone,
  /**
   * The track for audio from microphone
   */
  AgoraRteSourceTypeAudioMicrophone,
  /**
   * The track is for audio from customized data
   */
  AgoraRteSourceTypeAudioCustom,
  /**
   * // TODO (yejun): Consider to hiden this type
   * The track is for audio from RTC track , this type helps to
   * operator RTC audio track through RTE interface
   */
  AgoraRteSourceTypeAudioWrapper,
  /**
   * The track is for video from camera
   */
  AgoraRteSourceTypeVideoCamera,
  /**
   * The track is for video from customized data
   */
  AgoraRteSourceTypeVideoCustom,
  /**
   * The track is for mixing video from several video tracks
   */
  AgoraRteSourceTypeVideoMix,
  /**
   * The track is for video from screen
   */
  AgoraRteSourceTypeVideoScreen,
  /**
   * // TODO (yejun): Consider to hiden this type
   * The track is for video from RTC track , this type helps to
   * operator RTC audio track through RTE interface
   */
  AgoraRteSourceTypeVideoWrapper,
  
};



typedef NS_ENUM(NSInteger,AgoraRtePublishState)

{
  /**
   * The track is been publishing to stream
   */
  AgoraRtePublishStatePublishing,
  /**
   * The track is published to stream
   */
  AgoraRtePublishStatePublished,
  /**
   * The track is been unpublishing to stream
   */
  AgoraRtePublishStateUnpublishing,
  /**
   * The track is unpublished to stream
   */
  AgoraRtePublishStateUnpublished,
  /**
   * SDK failed to publish the track
   */
  AgoraRtePublishStateFailed,

};

typedef NS_ENUM(NSInteger,AgoraRteSubscribeState)

{
  /**
   * SDK is subscribing the remote track
   */
  AgoraRteSubscribeStateSubscribing,
  /**
   * The remote track is subscribed
   */
  AgoraRteSubscribeStateSubscribed,
  /**
   * // TODO (yejun): Confirm with team about this comment
   * Remote track is stopped
   */
  AgoraRteSubscribeStateNoSubscribe,
  /**
   * SDK failed to subscribe the remote track
   */
  AgoraRteSubscribeStateFailed,

};
typedef NS_ENUM(NSInteger,AgoraRteSceneType)

{
  /**
   * Adhoc scene type.
   * This scene type is using RTC connection as user manager stream. In future,
   * we could use different ways to sync user informations.
   */
  AgoraRteAdhoc,

};

typedef NS_ENUM(NSInteger,AgoraRteStreamType)

{
  /**
   * Invalid stream type.
   */
  AgoraRteStreamTypeInvalid,
  /**
   * RTC stream type
   */
  AgoraRteStreamTypeRtcStream,
  /**
   * CDN stream type.
   */
  AgoraRteStreamTypeCdnStream,

};




typedef NS_ENUM(NSInteger,AgoraRteVideoStreamType)

{
  /**
   * 0: The high-quality video stream, which has a higher resolution and bitrate.
   */
  AgoraRteVideoStreamTypeHIGH = 0,
  /**
   * 1: The low-quality video stream, which has a lower resolution and bitrate.
   */
  AgoraRteVideoStreamTypeLOW = 1,

};



typedef NS_ENUM(NSInteger,AgoraRteMediaType)

{
  /**
   * 0: The high-quality video stream, which has a higher resolution and bitrate.
   */
  AgoraRteMediaTypeAudio = 0,
  /**
   * 1: The low-quality video stream, which has a lower resolution and bitrate.
   */
  AgoraRteMediaTypeVideo = 1,

};



typedef NS_ENUM(NSInteger,AgoraRteInstanceState)

{
  /**
   * SDK is trying to create the instance
   */
  AgoraRteInstanceStateCreating,
  /**
   * SDK have created the instance
   */
  AgoraRteInstanceStateCreated,
  /**
   * SDK have published data from the instance to network
   */
  AgoraRteInstanceStateOnline,
  /**
   * SDK have unpublished data from the instance
   */
  AgoraRteInstanceStateOffline,
  /**
   * SDK have destroyed the instance
   */
  AgoraRteInstanceStateDestroyed,

};

/** AgoraRteMediaPlayerSpeed, reporting the playback speed. */
typedef NS_ENUM(NSInteger, AgoraRteMediaPlayerSpeed) {
    /** `100`: The original playback speed.
     */
    AgoraRteMediaPlayerSpeedDefault = 100,
    /** `75`: The playback speed is 0.75 times the original speed.
     */
    AgoraRteMediaPlayerSpeed75Percent = 75,
    /** `50`: The playback speed is 0.50 times the original speed.
     */
    AgoraRteMediaPlayerSpeed50Percent = 50,
    /** `125`: The playback speed is 1.25 times the original speed.
     */
    AgoraRteMediaPlayerSpeed125Percent = 125,
    /** `150`: The playback speed is 1.50 times the original speed.
     */
    AgoraRteMediaPlayerSpeed150Percent = 150,
    /** `200`: The playback speed is 2.00 times the original speed.
     */
    AgoraRteMediaPlayerSpeed200Percent = 200,

};
/** AgoraRteMediaPlayerState, reporting the playback state. */
typedef NS_ENUM(NSInteger, AgoraRteMediaPlayerState) {
  /** `0`: Default state. */
  AgoraRteMediaPlayerStateIdle = 0,
  /** `1`: Opening the media resource. */
  AgoraRteMediaPlayerStateOpening = 1,
  /** `2`: Opens the media resource successfully. */
  AgoraRteMediaPlayerStateOpenCompleted = 2,
  /** `3`: Playing the media resource. */
  AgoraRteMediaPlayerStatePlaying = 3,
  /** `4`: Pauses the playback. */
  AgoraRteMediaPlayerStatePaused = 4,
  /** `5`: The playback is completed. */
  AgoraRteMediaPlayerStatePlayBackCompleted = 5,
  /** `6`: The loop playback is completed. */
  AgoraRteMediaPlayerStatePlayBackAllLoopsCompleted = 6,
  /** `7`: Stops the playback.
   *
   * `AgoraRteMediaPlayerStateStopped(7)` and `AgoraRteMediaPlayerStateIdle(0)` represent the same state.
   *
   */
  AgoraRteMediaPlayerStateStopped = 7,
  /** `8`: Player pausing (internal).  */
  AgoraRteMediaPlayerStatePausingInternal = 50,
  /** `9`: Player stopping (internal).  */
  AgoraRteMediaPlayerStateStoppingInternal = 51,
  /** `10`: Player seeking state (internal). */
  AgoraRteMediaPlayerStateSeekingInternal = 52,
  /** `11`: Player getting state (internal). */
  AgoraRteMediaPlayerStateGettingInternal = 53,
  /** `12`: None state for state machine (internal).  */
  AgoraRteMediaPlayerStateNoneInternal = 54,
  /** `13`: Do nothing state for state machine (internal).  */
  AgoraRteMediaPlayerStateDoNothingInternal = 55,

  /** `100`: Fails to play the media resource. */
  AgoraRteMediaPlayerStateFailed = 100,
};
/** AgoraRteMediaPlayerError, reporting the player's error code. */
typedef NS_ENUM(NSInteger, AgoraRteMediaPlayerError) {
  /** `0`: No error. */
  AgoraRteMediaPlayerErrorNone = 0,
  /** `-1`: Invalid arguments. */
  AgoraRteMediaPlayerErrorInvalidArguments = -1,
  /** `-2`: Internal error. */
  AgoraRteMediaPlayerErrorInternal = -2,
  /** `-3`: No resource. */
  AgoraRteMediaPlayerErrorNoSource = -3,
  /** `-4`: Invalid media resource. */
  AgoraRteMediaPlayerErrorInvalidMediaSource = -4,
  /** `-5`: The type of the media stream is unknown. */
  AgoraRteMediaPlayerErrorUnknowStreamType = -5,
  /** `-6`: The object is not initialized. */
  AgoraRteMediaPlayerErrorObjNotInitialized = -6,
  /** `-7`: The codec is not supported. */
  AgoraRteMediaPlayerErrorCodecNotSupported = -7,
  /** `-8`: Invalid renderer. */
  AgoraRteMediaPlayerErrorVideoRenderFailed = -8,
  /** `-9`: Error occurs in the internal state of the player. */
  AgoraRteMediaPlayerErrorInvalidState = -9,
  /** `-10`: The URL of the media resource can not be found. */
  AgoraRteMediaPlayerErrorUrlNotFound = -10,
  /** `-11`: Invalid connection between the player and Agora's Server. */
  AgoraRteMediaPlayerErrorInvalidConnectState = -11,
  /** `-12`: The playback buffer is insufficient. */
  AgoraRteMediaPlayerErrorSrcBufferUnderflow = -12,
};
/** AgoraRteMediaPlayerEvent, reporting the result of the seek operation to the new
 playback position.
 */
typedef NS_ENUM(NSInteger, AgoraRteMediaPlayerEvent) {
  /** `0`: Begins to seek to the new playback position. */
  AgoraRteMediaPlayerEventSeekBegin = 0,
  /** `1`: Seeks to the new playback position. */
  AgoraRteMediaPlayerEventSeekComplete = 1,
  /** `2`: Error occurs when seeking to the new playback position. */
  AgoraRteMediaPlayerEventSeekError = 2,
  /** `5`: The audio track used by the player has been chanaged. */
  AgoraRteMediaPlayerEventAudioTrackChanged = 5,
  /** `6`: The currently buffered data is not enough to support playback. */
  AgoraRteMediaPlayerEventBufferLow = 6,
  /** `7`: The currently buffered data is just enough to support playback. */
  AgoraRteMediaPlayerEventBufferRecover = 7,
  /** `8`: The video or audio is interrupted. */
  AgoraRteMediaPlayerEventFreezeStart = 8,
  /** `9`: Interrupt at the end of the video or audio. */
  AgoraRteMediaPlayerEventFreezeStop = 9,

};

/**
 * AgoraRteMediaPlayerMetaDataType, reporting the type of the media metadata.
 */
typedef NS_ENUM(NSUInteger, AgoraRteMediaPlayerMetaDataType) {
  /** `0`: The type is unknown. */
  AgoraRteMediaPlayerMetaDataTypeUnknown = 0,
  /** `1`: The type is SEI. */
  AgoraRteMediaPlayerMetaDataTypeSEI = 1,
};

/** AgoraRteMediaPixelFormat, reporting the pixel format of the video stream. */
typedef NS_ENUM(NSInteger, AgoraRteMediaPixelFormat) {
  /** `0`: The format is known.
   */
  AgoraRteMediaPixelFormatUnknown = 0,
  /** `1`: The format is I420.
   */
  AgoraRteMediaPixelFormatI420 = 1,
  /** `2`: The format is BGRA.
   */
  AgoraRteMediaPixelFormatBGRA = 2,
  /** `3`: The format is Planar YUV422.
   */
  AgoraRteMediaPixelFormatI422 = 3,
  /** `8`: The format is NV12.
   */
  AgoraRteMediaPixelFormatNV12 = 8,
};
/** AgoraRteMediaStreamType, reporting the type of the media stream. */
typedef NS_ENUM(NSInteger, AgoraRteMediaStreamType) {
  /** `0`: The type is unknown. */
  AgoraRteMediaStreamTypeUnknow = 0,
  /** `1`: The video stream.  */
  AgoraRteMediaStreamTypeVideo = 1,
  /** `2`: The audio stream. */
  AgoraRteMediaStreamTypeAudio = 2,
  /** `3`: The subtitle stream. */
  AgoraRteMediaStreamTypeSubtitle = 3,
};
/** AgoraRteMediaPlayerRenderMode, reporting the render mode of the player. */
typedef NS_ENUM(NSUInteger, AgoraRteMediaPlayerRenderMode) {
    /** `1`: Uniformly scale the video until it fills the visible boundaries
     (cropped). One dimension of the video may have clipped contents.
     */
    AgoraRteMediaPlayerRenderModeHidden = 1,

    /** `2`: Uniformly scale the video until one of its dimension fits the
     boundary (zoomed to fit). Areas that are not filled due to disparity in
     the aspect ratio are filled with black.
     */
    AgoraRteMediaPlayerRenderModeFit = 2,
};


typedef NS_ENUM(NSInteger, AgoraRteLogLevel) {
    
    AgoraRteLogLevelNone = 0,
    
    AgoraRteLogLevelInfo = 1,
    
    AgoraRteLogLevelWarn = 2,
    
    AgoraRteLogLevelError = 4,
    
    AgoraRteLogLevelFatal = 8,
};

/** Media device type */
typedef NS_ENUM(NSInteger, AgoraRteMediaDeviceType) {
    /** Unknown device*/
    AgoraRteMediaDeviceTypeAudioUnknown = -1,
    /** Microphone device */
    AgoraRteMediaDeviceTypeAudioRecording = 0,
    /** Audio playback device */
    AgoraRteMediaDeviceTypeAudioPlayout = 1,
    /** Video render device*/
    AgoraRteMediaDeviceTypeVideoRender = 2,
    /** Video capture device*/
    AgoraRteMediaDeviceTypeVideoCapture = 3,
};


/** Media orientation type */
typedef NS_ENUM(NSInteger, AgoraVideoOrientation) {
    /** Unknown device*/
    AgoraVideoOrientation0 = 0,
    /** Microphone device */
    AgoraVideoOrientation90 = 90,
    /** Audio playback device */
    AgoraVideoOrientation180 = 180,
    /** Video render device*/
    AgoraVideoOrientation270 = 270,

};

/** The content hint for screen sharing. */
typedef NS_ENUM(NSUInteger, AgoraVideoContentHint) {
    /** 0: (Default) No content hint. */
    AgoraVideoContentHintNone = 0,
    /** 1: Motion-intensive content. Choose this option if you prefer smoothness or when you are sharing a video clip, movie, or video game. */
    AgoraVideoContentHintMotion = 1,
    /** 2: Motionless content. Choose this option if you prefer sharpness or when you are sharing a picture, PowerPoint slide, or text. */
    AgoraVideoContentHintDetails = 2,
};


/** The content hint for screen sharing. */
typedef NS_ENUM(NSUInteger, AgoraRteStreamState) {
    /** 0: (Default) No content hint. */
    AgoraRteStreamStateIdle = 0,
    /** 1: Motion-intensive content. Choose this option if you prefer smoothness or when you are sharing a video clip, movie, or video game. */
    AgoraRteStreamStateStreaming = 1,

};



/** The content hint for screen sharing. */
typedef NS_ENUM(NSUInteger, AgoraRteStreamStateChangedReason) {
    /** 1: (Default) No content hint. */
    AgoraRteStreamStateChangedReasonPublished = 1,
    /**
     * 2: The stream is unpublished.
     */
    AgoraRteStreamStateChangedReasonUnpublished = 2,
    /**
     * 3: The stream is subscribed and we have received data from the stream.
     */
    AgoraRteStreamStateChangedReasonSubscribed = 3,

    /**
     * 4: The stream is unsubscribed.
     */

    AgoraRteStreamStateChangedReasonUnsubscribed = 4,

};

/**
 * States of the CDN(rtmp) bypass streaming.
 */
typedef NS_ENUM(NSUInteger, AgoraRteCdnByPassStreamPublishState) {
    /**
     * 0: The RTMP streaming has not started or has ended.
     *
     * This state is also reported after you remove
     * an RTMP address from the CDN by calling `removePublishStreamUrl`.
     */
    AgoraRteCdnByPassStreamPublishStateIdle = 0,
    /**
     * 1: The SDK is connecting to the streaming server and the RTMP server.
     *
     * This state is reported after you call `addPublishStreamUrl`.
     */
    AgoraRteCdnByPassStreamPublishStateConnecting = 1,
    /**
     * 2: The RTMP streaming publishes. The SDK successfully publishes the RTMP
     * streaming and returns this state.
     */
    AgoraRteCdnByPassStreamPublishStateRunning = 2,
    /**
     * 3: The RTMP streaming is recovering. When exceptions occur to the CDN, or
     * the streaming is interrupted, the SDK tries to resume RTMP streaming and
     * reports this state.
     *
     * - If the SDK successfully resumes the streaming,
     * `RTMP_STREAM_PUBLISH_STATE_RUNNING(2)` is reported.
     * - If the streaming does not resume within 60 seconds or server errors
     * occur, `RTMP_STREAM_PUBLISH_STATE_FAILURE(4)` is reported. You can also
     * reconnect to the server by calling `removePublishStreamUrl` and
     * `addPublishStreamUrl`.
     */
    AgoraRteCdnByPassStreamPublishStateRecovering = 3,
    /**
     * 4: The RTMP streaming fails. See the `errCode` parameter for the detailed
     * error information. You can also call `addPublishStreamUrl` to publish the
     * RTMP streaming again.
     */
    AgoraRteCdnByPassStreamPublishStatefailure = 4,
};

/**
 * Error codes of the CDN(RTMP) bypass streaming.
 */
typedef NS_ENUM(NSInteger, AgoraRteCdnByPassStreamPublishError) {
    /**
     * -1: The RTMP streaming fails.
     */
    AgoraRteCdnByPassStreamPublishErrorFailed = -1,
    /**
     * 0: The RTMP streaming publishes successfully.
     */
    AgoraRteCdnByPassStreamPublishErrorErrorOK = 0,
    /**
     * 1: Invalid argument. If, for example, you did not call `setLiveTranscoding`
     * to configure the LiveTranscoding parameters before calling
     * `addPublishStreamUrl`, the SDK reports this error. Check whether you set
     * the parameters in `LiveTranscoding` properly.
     */
    AgoraRteCdnByPassStreamPublishErrorInvalidArgument = 1,
    /**
     * 2: The RTMP streaming is encrypted and cannot be published.
     */
    AgoraRteCdnByPassStreamPublishErrorEncryptedStreamNotAllowed = 2,
    /**
     * 3: A timeout occurs with the RTMP streaming. Call `addPublishStreamUrl`
     * to publish the streaming again.
     */
    AgoraRteCdnByPassStreamPublishErrorConnentionTimeout = 3,
    /**
     * 4: An error occurs in the streaming server. Call `addPublishStreamUrl` to
     * publish the stream again.
     */
    AgoraRteCdnByPassStreamPublishErrorInternalServerError = 4,
    /**
     * 5: An error occurs in the RTMP server.
     */
    AgoraRteCdnByPassStreamPublishErrorRtmpServerError = 5,
    /**
     * 6: The RTMP streaming publishes too frequently.
     */
    AgoraRteCdnByPassStreamPublishErrorTooOften = 6,
    /**
     * 7: The host publishes more than 10 URLs. Delete the unnecessary URLs before
     * adding new ones.
     */
    AgoraRteCdnByPassStreamPublishErrorReachLimit = 7,
    /**
     * 8: The host manipulates other hosts' URLs. Check your app logic.
     */
    AgoraRteCdnByPassStreamPublishErrorNotAuthrized = 8,
    /**
     * 9: The Agora server fails to find the RTMP streaming.
     */
    AgoraRteCdnByPassStreamPublishErrorStreamNotFound = 9,
    /**
     * 10: The format of the RTMP streaming URL is not supported. Check whether
     * the URL format is correct.
     */
    AgoraRteCdnByPassStreamPublishErrorFormatNotSupported = 10,
    /**
     * 11: CDN related errors. Remove the original URL address and add a new one
     * by calling `removePublishStreamUrl` and `addPublishStreamUrl`.
     */
    AgoraRteCdnByPassStreamPublishErrorCdnError = 11,
    /**
     * 12: Resources are occupied and cannot be reused.
     */
    AgoraRteCdnByPassStreamPublishErrorAlreadyInUse = 12,
};

typedef NS_ENUM(NSInteger, AgoraRteStreamingSrcStatus) {
    /**
     * 0. streaming source still closed, can do nothing
     */
    AgoraRteStreamingSrcStatusClosed   = 0,
    /**
     * 1. after call open() method and start parsing streaming source
     */
    AgoraRteStreamingSrcStatusOpening  = 1,
    /**
     * 2. streaming source is ready waiting for play
     */
    AgoraRteStreamingSrcStatusIdle    = 2,
    /**
     * 3. after call play() method, playing & pushing the AV data
     */
    AgoraRteStreamingSrcStatusPlaying = 3,
    /**
     * 4. after call seek() method, start seeking poisition
     */
    AgoraRteStreamingSrcStatusSeeking = 4,
    /**
     * 5. The position is located at end, can NOT playing
     */
    AgoraRteStreamingSrcStatusEof   = 5,
    /**
     * 6. The error status and can do nothing except close
     */
    AgoraRteStreamingSrcStatusError   = 6,
};


typedef NS_ENUM(NSInteger, AgoraRteLocalStreamEventType) {
    /**
     * The first video frame published
     */
    AgoraRteLocalStreamEventTypeFirstVideoFramePublished,
    /**
     * The first audio frame published
     */
    AgoraRteLocalStreamEventTypeFirstAudioFramePublished,
    /**
     * The first video frame rendered
     */
    AgoraRteLocalStreamEventTypeFirstVideoFrameRendered,
};

typedef NS_ENUM(NSInteger, AgoraRteRemoteStreamEventType) {
    /**
     * The first video frame received
     */
    AgoraRteRemoteStreamEventTypeFirstVideoFrameReceived,
    /**
     * The first audio frame received
     */
    AgoraRteRemoteStreamEventTypeFirstAudioFrameReceived,
    /**
     * The first video frame rendered
     */
    AgoraRteRemoteStreamEventTypeFirstVideoFrameRendered,
};















