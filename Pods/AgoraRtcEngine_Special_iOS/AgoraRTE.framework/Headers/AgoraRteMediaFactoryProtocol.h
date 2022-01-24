//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import "AgoraRteVideoTrackProtocol.h"
#import "AgoraRteAudioTrackProtocol.h"
#import "AgoraRteStreamingSourceProtocol.h"

@protocol AgoraRteMediaFactoryProtocol <NSObject>

/**
 * Create a camera video track, the track will use camera as video source.
 * Check \ref agora::rte::IAgoraRteCameraVideoTrack for more details
 *
 * @return The created camera video track.
 */
- (id<AgoraRteCameraVideoTrackProtocol> _Nullable)createCameraVideoTrack;

 /**
  * Create a screen video track, the track will use screen as video source.
  * Check \ref agora::rte::IAgoraRteScreenVideoTrack for more details
  *
  * @return The created screen video track.
  */
- (id<AgoraRteScreenVideoTrackProtocol> _Nullable)createScreenVideoTrack;

/**
 * Create a mixed video track, the track will mix video sources from other tracks into
 * single video source.
 * Check \ref agora::rte::IAgoraRteMixedVideoTrack for more details
 *
 * @return The created mixed video track.
 */
- (id<AgoraRteMixedVideoTrackProtocol> _Nullable)createMixedVideoTrack;

/**
 * Create a custom video track, the track will use customized data as video source.
 * Check \ref agora::rte::IAgoraRteCustomVideoTrack for more details
 *
 * @return The created custom video track.
 */
- (id<AgoraRteCustomVideoTrackProtocol> _Nullable)createCustomVideoTrack;

/**
 * Create a microphone audio track, the track will use microphone as audio source.
 * Check \ref agora::rte::IAgoraRteMicrophoneAudioTrack for more details
 *
 * @return The created microphone audio track.
 */
- (id<AgoraRteMicrophoneAudioTrackProtocol> _Nullable)createMicrophoneAudioTrack;

/**
 * Create a custom audio track, the track will use customized data as audio source.
 * Check \ref agora::rte::IAgoraRteCustomAudioTrack for more details
 *
 * @return The created custom audio track.
 */
- (id<AgoraRteCustomAudioTrackProtocol> _Nullable)createCustomAudioTrack;

/**
 * Create a media player.
 * Check \ref agora::rte::IAgoraRteMediaPlayer for more details
 *
 * @return The created media player.
 */
- (id<AgoraRteMediaPlayerProtocol > _Nullable)createMediaPlayer;

/**
 * Create a streaming source.
 * Check \ref agora::rte::IAgoraRteStreamingSource for more details
 *
 * @return The created streaming source.
 */
- (id<AgoraRteStreamingSourceProtocol> _Nullable)createStreamingSource;


@end
