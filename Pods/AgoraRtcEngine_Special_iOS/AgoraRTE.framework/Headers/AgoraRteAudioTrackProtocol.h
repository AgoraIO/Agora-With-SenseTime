//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraEnumerates.h>
#import <AgoraRtcKit/AgoraObjects.h>
#import "AgoraRteEnumerates.h"
@protocol AgoraRteAudioTrackProtocol <NSObject>

/**
 * Enable local playback.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)enableLocalPlayback;

/**
 *  Get the audio source type object
 *
 * @return SourceType The audio source type.
 */
- (AgoraRteSourceType)sourceType;

/**
 * Adjusts the publish volume of the local audio track..
 *
 * @param volume The volume for publishing. The value ranges between 0 and 100 (default).
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)adjustPublishVolume:(NSInteger)volume;

/**
 * Adjusts the playback volume.
 * @param volume The playback volume. The value ranges between 0 and 100 (default).
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)adjustPlayoutVolume:(NSInteger)volume;

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


@end

@protocol AgoraRteMicrophoneAudioTrackProtocol <AgoraRteAudioTrackProtocol>

/**
 * Starts audio recording.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
*/
- (int)startRecording;

/**
 * Stops audio recording.
 *
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)stopRecording;

/**
 * Enables in-ear monitoring.
 *
 * @param enabled Determines whether to enable in-ear monitoring.
 * - YES: Enable.
 * - NO: (Default) Disable.
 * @param includeAudioFilters The type of the ear monitoring: #EAR_MONITORING_FILTER_TYPE
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)enableEarMonitor:(BOOL)enable audioFilters:(NSInteger)includeAudioFilter;

/**
 * Set audio reverb preset.
 *
 * @param reverb_preset The audio reverb preset to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setAudioReverbPreset:(AgoraAudioReverbPreset)reverbPreset;

/**
 * Set voice changer preset.
 *
 * @param voice_changer_preset The voice changer preset to be set.
 * @return
 * - 0: Success.
 * - < 0: Failure.
 */
- (int)setVoiceChangerPreset:(AgoraVoiceConversionPreset)voiceChangerPreset;


@end

@protocol AgoraRteCustomAudioTrackProtocol <AgoraRteAudioTrackProtocol>

- (int)pushAudioFrame:(AgoraAudioFrame *_Nonnull )audioFrame;

@end



