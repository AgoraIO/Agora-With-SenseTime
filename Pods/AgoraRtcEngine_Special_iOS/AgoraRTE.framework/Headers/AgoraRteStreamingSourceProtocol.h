//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AgoraRtePlayListProtocol.h"
#import "AgoraRteVideoTrackProtocol.h"
#import "AgoraRteAudioTrackProtocol.h"
#import "AgoraRteEnumerates.h"
#import "AgoraRteBase.h"
@protocol AgoraRteStreamingSourceProtocol;

/**
 * The RTE streaming source status structure.
 */
@protocol AgoraRteStreamingSourceDelegate <NSObject>

/**
 * @brief Reports the playback state change.
 *     When the state of the playback changes,
 *     the SDK triggers this callback to report the new playback state
 *     and the reason or error for the change.
 * @param current_file_info : current file information
 * @param state The new playback state after change. See {@link STREAMING_SRC_STATE}.
 * @param ec The player's error code. See {@link STREAMINGSRC_ERR}.
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource stateDidChange:(AgoraRteFileInfo *_Nullable)currentFileInfo state:(AgoraRteStreamingSrcStatus)status errorCode:(NSInteger)errorCode;

/**
 * @brief Triggered when file is opened
 * @param err_code The error code, eumulate with agora::rte::ERROR_CODE_TYPE
 * @return None
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource openDone:(AgoraRteFileInfo *_Nullable)currentFileInfo errorCode:(NSInteger)errorCode;

/**
 * @brief Triggered when seeking is done
 * @param err_code The error code, eumulate with agora::rte::ERROR_CODE_TYPE
 * @return None
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource seekDone:(AgoraRteFileInfo *_Nullable)currentFileInfo errorCode:(NSInteger)errorCode;

/**
 * @brief Triggered when one file playing is end
 * @param current_file_info : current file information
 * @param progress_ms the progress position
 * @param repeat_count means repeated count of playing
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource eofOnce:(AgoraRteFileInfo *_Nullable)currentFileInfo progressMs:(NSInteger)progressMS repeatCount:(NSInteger)repeatCount;

/**
 * @brief Occurs when all media files playback is completed.
 * @param err_code The error code, eumulate with agora::rte::ERROR_CODE_TYPE
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource allMediaDidComplete:(NSInteger)errorCode;


/**
 * @brief Reports current playback progress.
 *        The callback triggered once every one second during the playing status
 * @param current_file_info : current file information
 * @param position_ms Current playback progress (millisecond).
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol> _Nonnull) rteStreamingSource progressDidChange:(AgoraRteFileInfo *_Nullable)currentFileInfo positionMS:(NSInteger)positionMs;

/**
 * @brief Occurs when the metadata is received.
 *       The callback occurs when the player receives the media metadata
 *        and reports the detailed information of the media metadata.
 * @param data The detailed data of the media metadata.
 * @param length The data length (bytes).
 */
-(void)agoraRteStreamingSource:(id<AgoraRteStreamingSourceProtocol>_Nonnull) rteStreamingSource receivedMetaData:(AgoraRteFileInfo * _Nullable)currentFileInfo  data:(NSData *_Nonnull)data length:(NSInteger)length;


@end


@protocol AgoraRteStreamingSourceProtocol <NSObject>

/**
 * @brief Create the play list
 * @param none
 * @return video track
*/
- (id<AgoraRtePlayListProtocol> _Nullable)createPlayList;

/**
 * @brief Retrieve the RTE video track
 * @param none
 * @return video track
 */
- (id<AgoraRteVideoTrackProtocol>_Nullable)rteVideoTrack;

/**
 * @brief Retrieve the RTE audio track
 * @param none
 * @return audio track
 */
- (id<AgoraRteAudioTrackProtocol>_Nullable)rteAudioTrack;

/**
 * @brief Opens a media streaming source
 * @param url The path of the media file. Both the local path and online path are supported.
 *            for local file is absolute path;
 *            for online file is URL which support HTTP and HTTPS protocol
 * @param startPos : The starting position (ms) for pushing
 * @param auto_play : Whether to automatically play the media streaming source after opening.
 * @return
 * - 0: Success.
 * - < 0: Failure
 */
 - (int)openUrl:(NSString *_Nonnull)url startPos:(NSInteger)pos autoPlay:(BOOL)autoPlay;

/**
 * @brief Open a play list
 * @param play_list : The play list which will be played
 * @param start_pos : The start position(ms) of the first file in the playlist
 * @param auto_play : Whether to automatically play the media streaming source after opening.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
 - (int)openPlayList:(id<AgoraRtePlayListProtocol> _Nonnull)playList startPos:(NSInteger)pos autoPlay:(BOOL)isAutoPlay;

/**
 * @brief Closes the media streaming source. It will close a single file or a play list
 * @return
 * - 0: Success.
 * - < 0: Failure
 */
 - (int)close;

/**
 * @brief Returns whether the video stream is valid.
 * @return: true: valid;  false: invalid
 */
-  (BOOL)isVideoValid;

/**
 * @brief Retrieve whether audio stream is valid
 * @return: true: valid;  false: invalid
 */
- (BOOL)isAudioValid;

/**
 * @brief Gets the duration of the streaming source.
 * @param [out] duration A reference to the duration (ms) of the media file.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (NSInteger)duration;

/**
 * @brief Gets the number of media streams in the streaming source.
 * @param [out] count The number of the media streams in the media source.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (NSInteger)streamCount;

/**
 * @brief Gets the detailed information of a media stream.
 * @param index The index of the media stream.
 * @param [out] out_info The detailed information of the media stream. See \ref
 * media::base::PlayerStreamInfo "PlayerStreamInfo" for details.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (AgoraRtePlayerStreamInfo * _Nullable)streamInfoByIndex:(NSInteger)index;

/**
 * @brief Sets the number of loops for playback.
 * @param loop_count The number of times of looping the media file.
 * - 1: Play the media file once.
 * - 2: Play the media file twice.
 * - <= 0: Play the media file in a loop indefinitely, until {@link stop} is called.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (int)setLoopCount:(NSInteger)loopCount;

/**
 * @brief Plays and pushes the streaming source.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (int)play;

/**
 * @brief Pauses playing the streaming source and keeps the playback position.
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (int)pause;

/**
 * @brief Stops playing the streaming source and sets the playback position to 0.
 * @return
 * - 0: Success.
 * - < 0: Failure.See {@link STREAMINGSRC_ERR}.
 */
 - (int)stop;

/**
 * @brief Sets the playback position of current file
 *        After seek done, it will return to previous status
 * @param newPos The new playback position (ms).
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (int)seekToNewPos:(NSInteger)newPos;

/**
 * @brief Seeks the previous file in the play list.
 * @param pos The position to be seeked in the file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
 - (int)seekToPrev:(NSInteger)pos;

/**
 * @brief Seeks the next file in the playlist.
 * @param pos The position to be seeked in the file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
 - (int)seekToNext:(NSInteger)pos;

/**
 * @brief Seeks a file by ID.
 * @param file_id The file id that should be seeked
 * @param pos The position to be seeked in the file.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
 - (int)seekToFile:(NSInteger)fileId startPos:(NSInteger)startPos;

/**
 * @brief Get current streaming source status
 * @param [out] out_source_status The streaming source status for output
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
 - (AgoraRteStreamingSourceStatus *_Nullable)streamingSourceStatus;

/**
 * @brief Gets the current playback position of the media file.
 * @param [out] pos A reference to the current playback position (ms).
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (NSInteger)currentPosition;

/**
 * @breif Gets the status of current streaming source.
 * @return The current state machine
 */
-(AgoraRteStreamingSrcStatus)currentState;

/**
 * @brief Appends the SEI data, which can be attached to video packet
 * @param type  SEI type
 * @param timestamp the video frame timestamp which attached to
 * @param frame_index the video frame timestamp which attached to
 *
 * @return
 * - 0: Success.
 * - < 0: Failure. See {@link STREAMINGSRC_ERR}.
 */
 - (int)appendSeiData:(AgoraRteInputSeiData *_Nonnull)inSeiData;

- (void)setStreamingSourceDelegate:(id<AgoraRteStreamingSourceDelegate> _Nullable )delegate;


- (void)setStreamingSourceDelegate:(id<AgoraRteStreamingSourceDelegate> _Nullable )delegate withDelegateQueue:(dispatch_queue_t _Nullable)delegateQueue;


 @end
