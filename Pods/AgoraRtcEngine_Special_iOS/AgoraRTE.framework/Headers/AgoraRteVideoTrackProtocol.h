//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraEnumerates.h>
#import <AgoraRtcKit/AgoraObjects.h>
#import "AgoraRteEnumerates.h"
#import "AgoraRteBase.h"
#import "AgoraRteMediaPlayerProtocol.h"

#if defined(_WIN32)
#define RTE_WIN 1
#elif TARGET_OS_MAC
#define RTE_APPLE 1
//+---------------------------------------------------------------------+
//|                            TARGET_OS_MAC                            |
//| +---+ +-----------------------------------------------+ +---------+ |
//| |   | |               TARGET_OS_IPHONE                | |         | |
//| |   | | +---------------+ +----+ +-------+ +--------+ | |         | |
//| |   | | |      IOS      | |    | |       | |        | | |         | |
//| |OSX| | |+-------------+| | TV | | WATCH | | BRIDGE | | |DRIVERKIT| |
//| |   | | || MACCATALYST || |    | |       | |        | | |         | |
//| |   | | |+-------------+| |    | |       | |        | | |         | |
//| |   | | +---------------+ +----+ +-------+ +--------+ | |         | |
//| +---+ +-----------------------------------------------+ +---------+ |
//+---------------------------------------------------------------------+
#if TARGET_OS_OSX
#define RTE_MAC 1
#elif TARGET_OS_IPHONE
#define RTE_IPHONE 1
#endif
#elif defined(__ANDROID__) or defined(ANDROID)
#define RTE_ANDROID 1
#elif defined(__linux__)
#define RTE_LINUX 1
#endif

#if RTE_WIN || RTE_MAC || RTE_LINUX
#define RTE_DESKTOP 1
#endif



@protocol AgoraRteVideoTrackProtocol;

@protocol AgoraRteVideoTrackDelegate <NSObject>
@optional
- (void)AgoraRteVideoTrack:(id<AgoraRteVideoTrackProtocol> _Nonnull)videoTrack receivedStreamId:(NSString *_Nonnull)streamId videoFrame:(AgoraOutputVideoFrame *_Nonnull)videoFrame;

@end

@protocol AgoraRteVideoTrackProtocol<NSObject>


/**
 * Sets the video canvas for local preview.
 *
 * @param canvas Video canvas settings.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setPreviewCanvas:(AgoraRtcVideoCanvas *_Nonnull)canvas;

/**
 * Get the video source Type
 *
 * @return SourceType The video source type
 */
- (AgoraRteSourceType)sourceType;

/**
 * Gets the stream ID where the track is published to.
 *
 * @return const std::string& The stream ID, empty if the track isn't published yet.
 */
- (NSString *_Nullable)attachedStreamId;

/**
 * Enable extension.
 *
 * @param providerName name for provider, e.g. agora.io.
 * @param extensionName name for extension, e.g. agora.beauty.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)enableExtensionWithProviderName:(NSString *_Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName;

/**
 * Set extension specific property.
 *
 * @param providerName name for provider, e.g. agora.io.
 * @param extensionName name for extension, e.g. agora.beauty.
 * @param key key for the property. if want to enabled filter, use a special
 * key kExtensionPropertyEnabledKey.
 * @param jsonValue property value.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setExtensionPropertyWithProviderName:(NSString *_Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName key:(NSString *_Nonnull)key jsonValue:(NSString *_Nonnull)jsonValue;

/**
 * Get extension specific property.
 *
 * @param providerName name for provider, e.g. agora.io.
 * @param extensionName name for extension, e.g. agora.beauty.
 * @param key key for the property.
 * @param jsonValue property value.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)getExtensionPropertyWithProviderName:(NSString *_Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName key:(NSString *_Nonnull)key jsonValue:(NSString *_Nonnull)jsonValue;



- (void)setVideoTrackDelegate:(id<AgoraRteVideoTrackDelegate> _Nullable)delegate;



- (void)setVideoTrackDelegate:(id<AgoraRteVideoTrackDelegate> _Nullable)delegate withDelegateQueue:(dispatch_queue_t _Nullable)delegateQueue;

@end


@protocol AgoraRteCameraVideoTrackProtocol <AgoraRteVideoTrackProtocol>

#if RTE_IPHONE

/**
 * Sets the camera source of the camera track
 *
 * @param source Camera source.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraSource:(AgoraRteCameraSource )source;

/**
 * Switches the camera source.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)switchCamera;

/**
 * Sets the camera zoom value
 *
 * @param zoomValue Camera zoom value
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraZoom:(NSInteger)zoomValue;

/**
 * Sets the coordinates of camera focus area.
 * @param x X axis value.
 * @param y Y axis value.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraFocus:(CGFloat)x y:(CGFloat)y;

/**
 * Whether to enable the camera to automatically focus on a human face.
 *
 * @param enable
 * true: Enables the camera to automatically focus on a human face.
 * false: Disables the camera to automatically focus on a human face.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraAutoFaceFocus:(BOOL)enable;

/**
 * Whether to enable the camera to detect human face.
 *
 * @param enable
 * true: Enables the camera to detect on a human face.
 * false: Disables the camera to detect on a human face.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraFaceDetection:(BOOL)enable;

#elif RTE_DESKTOP

/**
 * Sets the video orientation of the capture device.
 *
 * @param orientation orientation of the device 0(by default), 90, 180, 270
 */
- (int)setDeviceOrientation:(AgoraVideoOrientation)orientation;

/**
 * Selects the camera by device ID.
 *
 * @param device_id The unique device id from system
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setCameraDevice:(NSString *_Nonnull)deviceId;
#endif

/**
 * Start camera capture.
 *
 * @return
 * 0: Success.
 * < 0: Failure.
 */
-(int)startCapture;

/**
 * Stops capturing with the selected camera.
 *
 */
- (int)stopCapture;

@end


@protocol AgoraRteScreenVideoTrackProtocol <AgoraRteVideoTrackProtocol>


#if RTE_MAC

/**
 * (macOS) Starts capturing the screen by displayId.
 *
 * @param displayId Display ID of the screen.
 * @param regionRect Relative location of the region to the screen.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)startCaptureScreenWithDisplayId:(VIEW_CLASS * _Nonnull)displayId rectangle:(CGRect)rect;

/**
 * (macOS) Starts capturing a window by window ID.
 *
 * @param windowId ID of the window.
 * @param regionRect Relative location of the region to the screen.
 * @return int
 */
- (int)startCaptureWindowWithId:(VIEW_CLASS * _Nonnull)id rectangle:(CGRect)rect;

#elif RTE_IPHONE

/**
 * (iOS) Starts capturing the screen,
 *
 * @return
 * 0: Success.
 * < 0: Failure.
 */
- (int)startCaptureScreen;

#endif

#if RTE_MAC

/**
 * Sets the content hint for screen sharing.
 * A content hint suggests the type of the content being shared, so that the SDK applies different
 * optimization algorithms to different types of content.
 *
 * @param contentHint The content hint for screen capture.
 * @return
 * 0: Success.
 * < 0: Failure.
 */
- (int)setContentHint:(AgoraVideoContentHint)contentHint;

/**
 * Updates the screen capture region.
 *
 * @param regionRect The reference to the relative location of the region to the screen or window. See \ref agora::rtc::Rectangle "Rectangle".
 * If the specified region overruns the screen or window, the screen capturer captures only the region within it.
 * If you set width or height as 0, the SDK shares the whole screen or window.
 *
 * @return
 * 0: Success.
 * < 0: Failure.
 */
- (int)updateScreenCaptureRegionWithRect:(CGRect)rect;
#endif

/**
 * Stops screen capture.
 *
 * @return
 * 0: Success.
 * < 0: Failure.
 */
- (int)stopCapture;

@end


@protocol  AgoraRteMixedVideoTrackProtocol <AgoraRteVideoTrackProtocol>

/**
 * Sets the layout for the mixed video track.
 * @param layoutConfigs layoutConfigs Configurations for the layout.
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (int)setLayoutWithConfig:(AgoraRteLayoutConfigs *_Nonnull)config;

/**
 * Gets the layout for the mixed video track.
 *
 * @param layoutConfigs Configurations for the layout
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (AgoraRteLayoutConfigs *_Nullable)layoutConfigs;

/**
 * Adds a video track to the mixed video track.
 *
 * @param track IAgoraRteVideoTrack
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (int)addTrack:(id<AgoraRteVideoTrackProtocol> _Nonnull)track;

/**
 * Removes a video track from the mixed video track.
 *
 * @param track IAgoraRteVideoTrack
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (int)removeTrack:(id<AgoraRteVideoTrackProtocol> _Nonnull)track;

/**
 * Adds a media player to the mixed video track. Note that only audio frame from the
 * media player will be added into mixed track.
 *
 * @param mediaPlayer IAgoraRteMediaPlayer.
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (int)addMediaPlayer:(id<AgoraRteMediaPlayerProtocol> _Nonnull)player;

/**
 * Removes a media player from the mixed video track.
 *
 * @param mediaPlayer IAgoraRteMediaPlayer.
 * @return
 * 0: Success.
 * < 0: Failure
 */
- (int)removeMediaPlayer:(id<AgoraRteMediaPlayerProtocol> _Nonnull)player;


@end



@protocol AgoraRteCustomVideoTrackProtocol <AgoraRteVideoTrackProtocol>

- (int)pushVideoFrame:(AgoraVideoFrame *_Nullable)frame;

@end
