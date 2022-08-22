//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraRteEnumerates.h"
#import "AgoraRteBase.h"
#import <AgoraRtcKit/AgoraEnumerates.h>
#import "AgoraRteMediaFactoryProtocol.h"
#import "AgoraRteVideoTrackProtocol.h"
#import "AgoraRteAudioTrackProtocol.h"
#import "AgoraRteMediaPlayerProtocol.h"
@protocol AgoraRteSceneProtocol;
@protocol AgoraRteSceneDelegate <NSObject>
@optional

/**
 * Occurs when the connection state changes.
 *
 * @param oldState The old connection state.
 * @param newState The new connection state.
 * @param reason The reason of the connection state change.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene connectionStateDidChangeFromOldState:(AgoraConnectionState )oldState toNewState:(AgoraConnectionState )state withReason:(AgoraConnectionChangedReason )reason;

/**
 * Occurs when remote users join.
 * @param rteScene
 * @param userInfos Joined remote users.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene remoteUserDidJoinWithUserInfos:(NSArray<AgoraRteStreamInfo *>  *_Nullable)userInfos;

/**
 * Occurs when remote users join.
 * @param rteScene
 * @param userInfos Joined remote users.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene remoteUserDidLeftWithUserInfos:(NSArray<AgoraRteStreamInfo *> *_Nullable)userInfos;

/**
 * Occurs when remote streams are removed.
 * @param rteScene
 * @param streams Removed remote streams.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene remoteStreamesDidAddWithStreamInfos:(NSArray<AgoraRteStreamInfo *> *_Nullable)streamInfos;

/**
 * Occurs when remote streams are removed.
 * @param rteScene
 * @param streams Removed remote streams.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene remoteStreamDidRemoveWithStreamInfos:(NSArray<AgoraRteStreamInfo *>  *_Nullable)streamInfos;

/**
 * Occurs when the media state of the local stream changes.
 * @param rteScene
 * @param streams Information of the local stream.
 * @param mediaType Media type of the local stream.
 * @param oldState Old state of the local stream.
 * @param newState New state of the local stream.
 * @param reason The reason of the state change.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene localStreamStateDidChange:(AgoraRteStreamInfo *_Nullable)streams mediaType:(AgoraRteMediaType )mediaType steamMediaFromOldState:(AgoraRteStreamState )oldState toNewState:(AgoraRteStreamState)newState withReason:(AgoraRteStreamStateChangedReason )reason;

/**
 * Occurs when the media state of the local stream changes.
 * @param rteScene
 * @param streams Information of the local stream.
 * @param mediaType Media type of the local stream.
 * @param oldState Old state of the local stream.
 * @param newState New state of the local stream.
 * @param reason The reason of the state change.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene remoteStreamStateDidChange:(AgoraRteStreamInfo *_Nullable)streams mediaType:(AgoraRteMediaType )mediaType steamMediaFromOldState:(AgoraRteStreamState )oldState toNewState:(AgoraRteStreamState)newState withReason:(AgoraRteStreamStateChangedReason )reason;

/**
 * Reports the volume information of users.
 *
 * @param speakers The volume information of users.
 * @param totalVolume Total volume after audio mixing. The value ranges between 0 (lowest volume) and 255 (highest volume).
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene audioVolumeDidIndicateTo:(NSArray *_Nullable)speakers totalVolume:(NSInteger )totalVolume;

/**
 * Occurs when the token will expire in 30 seconds for the user.
 *
 * //TODO (yejun): expose APIto renew scene token
 * @param rteScene
 * @param sceneId
 * @param token The token that will expire in 30 seconds.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene sceneTokenWillExpire:(NSString *_Nullable)sceneId token:(NSString *_Nullable)token;

/**
 * Occurs when the token has expired for a user.
 *
 * //TODO (yejun): expose APIto renew scene token
 *@param rteScene
 * @param stream_id The ID of the scene.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene sceneTokenDidExpire:(NSString *_Nullable)sceneId;

/**
 * Occurs when the token of a stream expires in 30 seconds.
 * If the token you specified when calling 'CreateOrUpdateRTCStream' expires,
 * the user will drop offline. This callback is triggered 30 seconds before the token expires, to
 * remind you to renew the token by calling 'CreateOrUpdateRTCStream' again with new token.
 * //TODO (yejun): Need to tell how to generate new token, ETA for new token facility
 * Upon receiving this callback, generate a new token at your app server
 * @param rteScene
 * @param streamId
 * @param token
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene streamTokenWillExpire:(NSString *_Nullable)streamId token:(NSString *_Nullable)token;

/**
 * Occurs when the token has expired for a stream.
 *
 * Upon receiving this callback, you must generate a new token on your server and call
 * "CreateOrUpdateRTCStream" to pass the new token to the SDK.
 * @param rteScene
 * @param streamId The ID of the scene.
 */
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene streamTokenDidExpire:(NSString *_Nullable)streamId;

- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
cdnStateDidChange:(NSString *_Nullable)streamId
     targetCdnUrl:(NSString *_Nullable)targetCdnUrl
            state:(AgoraRteCdnByPassStreamPublishState)state
        errorCode:(AgoraRteCdnByPassStreamPublishError)errorCode;

- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene cdnPublished:(NSString *_Nullable)targetCdnUrl errorCode:(AgoraRteCdnByPassStreamPublishError)errorCode;

- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene cdnUnpublished:(NSString *_Nullable)streamId targetCdnUrl:(NSString *_Nullable)targetCdnUrl;

- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene transcodingDidUpdate:(NSString *_Nullable)streamId;

// SceneStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene sceneStats:(AgoraRteSceneStats* _Nullable )stats;

// LocalStreamStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
  localStreamDidStats:(NSString *_Nullable)streamId
                stats:(AgoraRteLocalStreamStats* _Nullable )stats;

// RemoteStreamStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
 remoteStreamDidStats:(NSString *_Nullable)streamId
                stats:(AgoraRteRemoteStreamStats* _Nullable )stats;

// localStreamAudioStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
localStreamAudioStats:(NSString *_Nullable)streamId
                stats:(AgoraRteLocalAudioStats* _Nullable )stats;

// localStreamVideoStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
localStreamVideoStats:(NSString *_Nullable)streamId
                stats:(AgoraRteLocalVideoStats* _Nullable )stats;

// remoteStreamAudioStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
remoteStreamAudioStats:(NSString *_Nullable)streamId
                stats:(AgoraRteRemoteAudioStats* _Nullable )stats;

// remoteStreamVideoStats
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
remoteStreamVideoStats:(NSString *_Nullable)streamId
                stats:(AgoraRteRemoteVideoStats* _Nullable )stats;

//localStreamEvent
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
     LocalStreamEvent:(NSString *_Nullable)streamId
                event:(AgoraRteLocalStreamEventType)eventType;

//remoteStreamEvent
- (void)agoraRteScene:(id<AgoraRteSceneProtocol> _Nonnull)rteScene
    remoteStreamEvent:(NSString *_Nullable)streamId
                event:(AgoraRteRemoteStreamEventType)eventType;


@end;



@protocol  AgoraRteSceneProtocol <NSObject>

/**
 * Joins an scene.
 *
 * @param user_id User ID to join a scene.
 * @param token The access token to join a scene.
 * @param option Options to join a scene.
 */
- (int)joinSceneWithUserId:(NSString *_Nonnull)userId token:(NSString *_Nullable)token joinOptions:(AgoraRteJoinOptions *_Nullable)options;

/**
 * Leaves an scene.
 */
- (void)leave;

/**
 * Get scene info.
*/
- (AgoraRteSceneInfo *_Nullable)sceneInfo;

/**
 * Gets information of the remote user.
 */
- (NSArray <AgoraRteUserInfo*>*_Nullable)remoteUsers;

/**
 * Gets the information of local streams.
 *
 */
- (NSArray <AgoraRteStreamInfo *>*_Nullable)localStreams;

/**
 * Gets the information of remote streams.
 *
 */
- (NSArray <AgoraRteStreamInfo *>*_Nullable)remoteStreams;

/**
 * Gets the information of remote streams by user ID.
 * @param user_id User ID.
 */
- (NSArray <AgoraRteUserInfo*>*_Nullable)remoteStreamsByUserId:(NSString *_Nonnull)userId;

/**
 * Create a Or Update RTC Stream object.
 * If the stream doesn't exist, a new stream will be created, otherwise, the stream will
 * be updated by the new option (e.g. rtc token will be updated).
 *
 * @param local_stream_id Target stream id
 * @param option Options to apply
 *
 */
- (int)createOrUpdateRTCStream:(NSString *_Nonnull)localStreamId rtcStreamOptions:(AgoraRteRtcStreamOptions *_Nonnull)options;

/**
 * Create a Or Update CDN Stream object.
 * If the stream doesn't exist, a new stream will be created, otherwise, the stream will
 * be updated by the new option (e.g. CDN url will be updated).
 *
 * @param local_stream_id Target stream id
 * @param option Options to apply
 */
- (int)createOrUpdateDirectCDNStream:(NSString *_Nonnull)localStreamId directCdnStreamOptions:(AgoraRteDirectCdnStreamOptions *_Nonnull)options;

/**
 * Destroys a local stream by ID.
 *
 * @param local_stream_id ID of the local stream to be destroyed
 */
- (void)destroyStream:(NSString *_Nonnull)localStreamId;

/**
 * Configures the audio encoder for the local stream.
 * Note that all audio tracks published to the stream will apply the new configuration.
 *
 * @param local_stream_id ID of the local stream.
 * @param config Audio encoder configurations.
 *
 */
- (void)setAudioEncoderConfiguration:(NSString *_Nonnull)localStreamId audioEncoderConfiguration:(AgoraRteAudioEncoderConfiguration *_Nonnull)config;

/**
 * Configures the video encoder for the local stream.
 * Note that all video tracks published to the stream will apply the new configuration.
 *
 * @param local_stream_id ID of the local stream.
 * @param config Video encoder configurations.
 */
- (void)setVideoEncoderConfiguration:(NSString *_Nonnull)localStreamId videoEncoderConfiguration:(AgoraVideoEncoderConfiguration *_Nonnull)config;

/**
 * Publishes a local audio track to a local stream by ID.
 * Note that remote peers could only see one audio track even several local audio tracks
 * are published to the stream. This is because all local audio tracks will be mixed
 * automatically in internal before sending the audio data to remote peers.
 *
 * @param local_stream_id ID of the local stream.
 * @param track The local audio track.
 * - 0: Success.
 * - < 0: Failure.
 */
- (void)publishLocalAudioTrack:(NSString *_Nonnull)localStreamId rteAudioTrack:(id<AgoraRteAudioTrackProtocol> _Nonnull)track;

/**
 * Publishes a local video track to a local stream by ID.
 * Note that one stream could only contains one video track, so several streams are
 * required to publish several video tracks, or one stream with mixing all video tracks
 * together.
 *
 * @param local_stream_id ID of the local stream.
 * @param track The local video track.
 *
 */
- (void)publishLocalVideoTrack:(NSString *_Nonnull)localStreamId rteVideoTrack:(id<AgoraRteVideoTrackProtocol> _Nonnull)track;

/**
 * Unpublishes a local audio track.
 *
 * @param track The local audio track.
 *
 */
- (void)unpublishLocalAudioTrack:(id<AgoraRteAudioTrackProtocol> _Nonnull)track;

/**
 * Unpublishes a local video track.
 * Note that even the track is unpublished, but for camera track or screen track, the track
 * could be still captering data from camera or screen, so the preview function isn't impact
 * after unpublishing. To stop the camera or screen track, user need to call StopCapture().
 *
 * @param track The local video track.
 *
 */
- (void)unpublishLocalVideoTrack:(id<AgoraRteVideoTrackProtocol> _Nonnull)track;

/**
 * Publishes a media player to a local stream by ID. The played audio and video will be
 * sent to the stream.
 *
 * @param local_stream_id ID of the local stream.
 * @param player The media player.
 *
 */
- (void)publishMediaPlayer:(NSString *_Nonnull)localStreamId mediaPlayer:(id<AgoraRteMediaPlayerProtocol> _Nonnull) rteMediaPlayer;

/**
 * Unpublishes a media player.
 *
 * @param player The media player.
 *
 */
- (void)unpublishMediaPlayer:(id<AgoraRteMediaPlayerProtocol> _Nonnull)rteMediaPlayer;

/**
 * Subscribes the remote audio data from remote stream
 *
 * @param remoteStreamId The remote stream ID.
 *
 */
- (void)subscribeRemoteAudio:(NSString *_Nonnull)remoteStreamId;

/**
 * Unsubscribes the remote audio data from remote stream
 *
 * @param remoteStreamId The remote stream ID.
 *
 */
- (void)unsubscribeRemoteAudio:(NSString *_Nonnull)remoteStreamId;

/**
 * Subscribes the remote video data from remote stream
 *
 * @param remoteStreamId The remote stream ID.
 * @param options Subscription options.
 *
 */
- (void)subscribeRemoteVideo:(NSString *_Nonnull)remoteStreamId videoSubscribeOptions:(AgoraRteVideoSubscribeOptions *_Nonnull)options;

/**
 * Unsubscribes the remote video data from remote stream
 *
 * @param remoteStreamId The remote stream ID.
 *
 */
- (void)unSubscribeRemoteVideo:(NSString *_Nonnull)remoteStreamId videoSubscribeOptions:(AgoraRteVideoSubscribeOptions *_Nonnull)options;

/**
 * Set video canvas for the remote stream. Video frame from the remote stream will
 * be applied to the canvas.
 * Note that SDK will try to hold related resource internal (e.g window resource from system),
 * and the resource referenced by canvas will be released when scene is destroyed or user set the
 * canvas with empty resource.
 *
 * @param remoteStreamId The remote stream ID
 * @param canvas The input Canvas.
 *
 */
- (void)setRemoteVideoCanvas:(NSString *_Nonnull)remoteStreamId videoCanvas:(AgoraRtcVideoCanvas *_Nonnull)canvas;

/**
 * Adjust the playback volume for remote user
 *
 * @param remoteStreamId The remote stream id
 * @param volume The playback volume, range is [0,100]
 * @return
 * - 0: Success
 * - < 0: Failure
 */
- (int)adjustUserPlaybackSignalVolumeWithRemoteStreamId:(NSString *_Nonnull)remoteStreamId volume:(NSInteger)volume;

/**
 * Get the playback volume for remote user
 *
 * @param remoteStreamId The remote stream id
 * @return volume The playback volume, range is [0,100]
 * - 0: Success
 * - < 0: Failure
 */
- (int)userPlaybackSignalVolumeWithRemoteStreamId:(NSString *_Nonnull)remoteStreamId;

/**
 * Set extension specific property.
 * @param remoteStreamId name for remoteId, e.g. agora.io.
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
- (int)setExtensionPropertyWithRemoteStreamId:(NSString *_Nonnull)remoteStreamId providerName:(NSString *_Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName key:(NSString *_Nonnull)key jsonValue:(NSString *_Nonnull)jsonValue;

/**
 * Get extension specific property.
 * @param remoteStreamId name for remoteId, e.g. agora.io.
 * @param providerName name for provider, e.g. agora.io.
 * @param extensionName name for extension, e.g. agora.beauty.
 * @param key key for the property.
 * @param jsonValue property value.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)getExtensionPropertyWithRemoteStreamId:(NSString *_Nonnull)remoteStreamId providerName:(NSString *_Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName key:(NSString *_Nonnull)key jsonValue:(NSString *_Nonnull)jsonValue;


- (void)setSceneDelegate:(id<AgoraRteSceneDelegate> _Nullable) delegate;


- (void)setSceneDelegate:(id<AgoraRteSceneDelegate> _Nullable) delegate withDelegateQueue:(dispatch_queue_t _Nullable)delegateQueue;


@end;
