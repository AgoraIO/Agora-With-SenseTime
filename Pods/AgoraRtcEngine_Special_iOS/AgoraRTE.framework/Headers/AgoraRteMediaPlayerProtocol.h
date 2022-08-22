//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//


#import "AgoraRteEnumerates.h"
#import "AgoraRtePlayListProtocol.h"
#import <AgoraRtcKit/AgoraEnumerates.h>
#import "AgoraRteBase.h"
#include <AVFoundation/AVFoundation.h>
@class AgoraRteMediaPlayer;
@class AgoraRteScene;
@class AgoraRtePlayList;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
typedef UIView View;
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
typedef NSView View;
#endif

@protocol AgoraRteMediaPlayerProtocol;
@protocol AgoraRteMediaPlayerDelegate <NSObject>
@optional

/** Reports the playback state change.

 @param playerKit AgoraMediaPlayer

 @param state The new playback state after change. See AgoraMediaPlayerState.

 @param error The player's error code. See AgoraMediaPlayerError.

 @param fileInfo The played file information.
 */
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
       stateDidChangeTo:(AgoraMediaPlayerState)state
                   error:(AgoraMediaPlayerError)error
                rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/** Reports current playback progress.

 The callback occurs once every one second during the playback and reports
 current playback progress.

 @param playerKit AgoraMediaPlayer

 @param position Current playback progress (s).
 
 @param fileInfo The played file information.

 */
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
       positionDidChangedTo:(NSInteger)position
        rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/** Reports the result of the seek operation.

 @param playerKit AgoraMediaPlayer

 @param event The result of the seek operation. See AgoraMediaPlayerEvent.

 @param fileInfo The played file information.
 */
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
              eventDidOccur:(AgoraMediaPlayerEvent)event
          rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/** Reports the reception of the media metadata.

 The callback occurs when the player receives the media metadata and reports
 the detailed information of the media metadata.

 @param playerKit AgoraMediaPlayer

 @param type The type of the media metadata. See AgoraMediaPlayerMetaDataType.

 @param data The detailed data of the media metadata.

 @param length The length (byte) of the data.

 @param fileInfo The played file information.

 */
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
            metaDataType:(AgoraMediaPlayerMetaDataType) type
               receivedData:(NSString *_Nullable)data
                  length:(NSInteger)length
              rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/** Occurs when each time the player receives a video frame.

After registering the video frame observer, the callback occurs when each
time the player receives a video frame, reporting the detailed
information of the video frame.

@param playerKit AgoraMediaPlayer

@param pixelBuffer The detailed information of the video frame.

@param fileInfo The played file information.
*/
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
    receivedVideoFrame:(CVPixelBufferRef _Nullable)pixelBuffer
              rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/** Occurs when each time the player receives an audio frame.

After registering the audio frame observer, the callback occurs when each
time the player receives an audio frame, reporting the detailed
information of the audio frame.

@param playerKit AgoraMediaPlayer

@param audioFrame The detailed information of the audio frame.

@param fileInfo The played file information.
*/
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
    receivedAudioFrame:(CMSampleBufferRef _Nullable)audioFrame
        rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

/**
Reports the playback duration that the buffered data can support.

In the process of playing online media resources, the mediaplayer kit triggers
this callback every one second to report the playback duration that the currently
buffered data can support.

- When the playback duration supported by the buffered data is less than the threshold (0 by default),
the mediaplayer kit returns `AgoraMediaPlayerEventBufferLow(6)`.
- When the playback duration supported by the buffered data is greater than the threshold (0 by default),
the mediaplayer kit returns `AgoraMediaPlayerEventBufferRecover(7)`.

@param playerKit AgoraMediaPlayer

@param playCachedBuffer The playback duration (ms) that the buffered data can support.

@param fileInfo The played file information.

*/
- (void)agoraRteMediaPlayer:(id<AgoraRteMediaPlayerProtocol>_Nonnull)playerKit
          updatedPlayBuffer:(NSInteger)updatedPlayBuffer
              rteFileInfo:(AgoraRteFileInfo * _Nullable)fileInfo;

@end

@protocol AgoraRteMediaPlayerProtocol <NSObject>

/**
 * @brief Creates a play list.
 * @param none
 * @return the new IAgoraRtePlayList object
 */
- (id<AgoraRtePlayListProtocol> _Nullable)createPlayList;

/**
 * Opens a media file.
 *
 * @param url The URL of the file to be opened.
 *            For local file, it's a asbolute path
 *            For cloud file, it's a http or https URL (we support HTTP and HTTPS protocol)
 * @param start_pos The start position (ms) of the file to be opened, the rang is 0 ~ file_duration
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)openUrl:(NSString *_Nonnull)url startPos:(NSInteger)startPos;

/**
 * Opens a play list.
 *
 * @param play_list : The play list to open.
 * @param start_pos : The start position (ms) of the file to be opened, the rang is 0 ~ file_duration
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)openPlayList:(id<AgoraRtePlayListProtocol> _Nonnull )playList startPos:(NSInteger)startPos;

/**
 * Play the media file.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)play;

/**
 * Pauses playing the media file.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)pause;

/**
 * Resumes playing the paused media file.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)resume;

/**
 * Stops playing the media file.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)stop;

/**
 * Seeks the playing media file to a position in current file
 *
 * @param pos The position (ms) to seek in the current file
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)seek:(NSInteger)pos;

/**
 * Seeks the previous file in the play list.
 *
 * @param pos The position (ms) to seek in the previous file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)seekToPrev:(NSInteger)pos;

/**
 * Seeks the next file in the play list.
 *
 * @param pos The position (ms) to seek in the next file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)seekToNext:(NSInteger)pos;

/**
 * Seeks a file by ID.
 *
 * @param file_id The ID of the file to seek.
 * @param pos The position (ms) to seek in the file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)seekToFile:(NSInteger)fileId pos:(NSInteger)pos;

/**
 * Changes playback speed.
 *
 * @param speed The speed to be changed to.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)changePlaybackSpeed:(AgoraRteMediaPlayerSpeed)speed;

/**
 * Adjusts playout volume.
 *
 * @param volume The volume to be adjusted to. valure range in [0, 100]
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)adjustPlayoutVolume:(NSInteger)volume;

/**
 * Whether to mute or unmute the local playing,
 * This function will NOT effect publishing
 *
 * @param true: Mutes the local playing
          false: Unmutes the local playing
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)mute:(BOOL)isMuted;

/**
 * Selects audio track by index.
 *
 * @param index The index of the audio track.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)selectAudioTrack:(NSInteger)index;

/**
 * Sets the loop count to play.
 *
 * @param loop_count The loop count to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setLoopCount:(NSInteger)loopCount;

/**
 * Mutes the audio.
 * @param audio_mute : mute or unmute audio
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)muteAudio:(BOOL)isMuted;

/**
 * Gets whehter audio is muted
 * @param None
 * @return true or false
 */
- (BOOL)isAudioMuted;

/**
 * Mutes the video.
 * @param video_mute : mute or unmute video
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)muteVideo:(BOOL)isMuted;

/**
 * Gets whether video is muted.
 * @param None
 * @return true or false
 */
- (BOOL)isVideoMuted;

/**
 * Set view.
 *
 * @param view The view pointer to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setView:(View * _Nonnull)view;

/**
 * Set render mode.
 *
 * @param mode The render mode to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setRenderMode:(AgoraMediaPlayerRenderMode)mode;

/**
 * Set player option with an integer value.
 *
 * @param key The key of the option to be set.
 * @param value The value of the option to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setPlayerOption:(NSString *_Nonnull)key value:(NSInteger)value;

/**
 * Set player option with a string value.
 *
 * @param key The key of the option to be set.
 * @param value The value of the option to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setPlayerOptionString:(NSString *_Nonnull)key value:(NSString *_Nonnull)value;

/**
 * Get current playing status of Media Player .
 *
 * @param [out] out_playing_status The playing status for output
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (AgoraRtePlayerStatus * _Nonnull)playerStatus;

/**
 * Gets player state.
 *
 * @return
 * Current player state.
 */
- (AgoraMediaPlayerState )playerState;

/**
 * Get duration.
 *
 * @param [out] duration The to be set duration.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (NSInteger)duration;

/**
 * Get play position.
 *
 * @param [out] pos The to be set play position.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (NSInteger)playPosition;

/**
 * Get play volume.
 *
 * @param [out] volume The to be set play volume.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (NSInteger)playoutVolume;

/**
 * Gets the number of streams.
 *
 * @param [out] count : the number of streams in the media file
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (NSInteger)streamCount;

/**
 * Get stream info.
 *
 * @param index The index of the stream info.
 * @param [out] info : output the stream information
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (AgoraRteMediaStreamInfo *_Nullable)streamInfoByIndex:(NSInteger)index;

/**
 * Gets whether the local playing of media player is muted.
 *
 * @return
 * Whether muted.
 */
- (BOOL)isMuted;

/**
 * Gets the version of the media player.
 *
 * @return Current player version string
 */
- (NSString *_Nullable)playerVersion;

/**
 * Set stream ID.
 *
 * @param stream_id The stream ID to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setStreamId:(NSString * _Nullable)streamId;

/**
 * Get stream ID.
 *
 * @param [out] stream_id The stream ID to be gotten.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (NSString *_Nullable)streamId;


//default main thread callback
- (void)setAgoraRtePlayerDelegate:(id<AgoraRteMediaPlayerDelegate> _Nonnull)delegate;

  //can target queue
- (void)setAgoraRtePlayerDelegate:(id<AgoraRteMediaPlayerDelegate> _Nonnull)delegate  withDelegateQueue:(dispatch_queue_t _Nullable)delegateQueue;
@end
