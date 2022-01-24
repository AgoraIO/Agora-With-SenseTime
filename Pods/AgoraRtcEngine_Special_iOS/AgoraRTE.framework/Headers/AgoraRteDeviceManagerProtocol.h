//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgoraRteBase.h"

@class AgoraRteDeviceInfo;

@protocol AgoraRteAudioDeviceCollectionProtocol <NSObject>

/**
 * Gets the total number of the playback and recording devices.
 *
 * Call \ref IAgoraRteAudioDeviceManager::EnumeratePlaybackDevices
 * "EnumeratePlaybackDevices" first, and then call this method to return the
 * number of the audio playback devices.
 *
 * @return
 * - The number of the audio devices, if the method call succeeds.
 */
- (NSInteger)count;

/**
 * @description:
 * @param
 * @return device information
 */
- (AgoraRteDeviceInfo * _Nullable)deviceAtIndex:(NSInteger)index;

/**
 * Specifies a device with the device ID.
 * @param deviceId The device ID.
 */
- (void)setDeviceWithId:(NSString * _Nullable)deviceId;

/**
 * Sets the volume of the app.
 *
 * @param volume The volume of the app. The value range is [0, 255].
 *
 */
- (void)setApplicationVolume:(NSInteger)volume;

/**
 * Gets the volume of the app.
 *
 * @param volume The volume of the app. The value range is [0, 255]
 *
 */
- (NSInteger)applicationVolume;

/** Mute or unmute the application playback volume.
 *
 * @param mute Determines whether to mute current application:
 * - true: Mute the app.
 * - false: Unmute the app.
*/
 - (void)muteApplication:(BOOL)mute;


/**
 * Gets the mute state of the app.
 *
 * @param mute A reference to the mute state of the app:
 * - true: The app is muted.
 * - false: The app is not muted.
 *
*/
 - (BOOL)isApplicationMuted;


@end


@protocol AgoraRteAudioDeviceManagerProtocol <NSObject>

/**
 * Enumerates the audio playback devices.
 *
 * This method returns an IAgoraRteAudioDeviceCollection object that includes
 * all the audio playback devices in the system. With the
 * IAgoraRteAudioDeviceCollection object, the app can enumerate the audio
 * playback devices. The app must call the \ref
 * IAgoraRteAudioDeviceCollection::Release
 * "IAgoraRteAudioDeviceCollection::Release" method to release the returned
 * object after using it.
 *
 * @return
 * - A pointer to the IAgoraRteAudioDeviceCollection object that includes all
 * the audio playback devices in the system, if the method call succeeds.
 * - The empty pointer NULL, if the method call fails.
 */
- (NSArray <AgoraRteDeviceInfo *>* _Nullable)enumeratePlaybackDevices;

/**
 * Enumerates the audio recording devices.
 *
 * This method returns an IAgoraRteAudioDeviceCollection object that includes
 * all the audio recording devices in the system. With the
 * IAgoraRteAudioDeviceCollection object, the app can enumerate the audio
 * recording devices. The app needs to call the \ref
 * IAgoraRteAudioDeviceCollection::release
 * "IAgoraRteAudioDeviceCollection::release" method to release the returned
 * object after using it.
 *
 * @return
 * - A pointer to the IAgoraRteAudioDeviceCollection object that includes all
 * the audio recording devices in the system, if the method call succeeds.
 * - The empty pointer NULL, if the method call fails.
 */
- (NSArray <AgoraRteDeviceInfo *> * _Nullable)enumerateRecordingDevices;

/**
 * Specifies an audio playback device with the device ID.
 *
 * @param deviceId ID of the audio playback device. It can be retrieved by the
 * \ref EnumeratePlaybackDevices "EnumeratePlaybackDevices" method. Plugging
 * or unplugging the audio device does not change the device ID.
 */
- (void)setPlaybackDeviceWithId:(NSString * _Nullable)deviceId;

/**
 * Gets the ID of the audio playback device.
 * @return  device.
*/
- (NSString * _Nullable)playDevice;

/**
 * Sets the volume of the audio playback device.
 * @param volume The volume of the audio playing device. The value range is
 * [0, 255].
*/
- (void)setPlaybackDeviceVolume:(NSInteger)volume;

/**
 * Gets the volume of the audio playback device.
 * @return volume The volume of the audio playback device. The value range is
 * [0, 255].
*/
- (NSInteger)playbackDeviceVolume;


/**
 * Specifies an audio recording device with the device ID.
 *
 * @param deviceId ID of the audio recording device. It can be retrieved by
*/
- (void)setRecordDeviceWithId:(NSString * _Nullable)deviceId;

/**
 * Gets the audio recording device by the device ID.
 *
 * @return deviceId ID of the audio recording device.
*/
- (NSString * _Nullable)recordingDevice;

/**
 * Sets the volume of the recording device.
 * @param volume The volume of the recording device. The value range is [0,
 * 255].
 * @return
 *
*/
- (void)setRecordingDeviceVolume:(NSInteger)volume;

/**
 * Gets the volume of the recording device.
 *
 * @return volume The volume of the microphone, ranging from 0 to 255.
 *
*/
- (NSInteger)recordingDeviceVolume;

/**
 * Mutes or unmutes the audio playback device.
 *
 * @param mute Determines whether to mute the audio playback device.
 * - true: Mute the device.
 * - false: Unmute the device.
 *
*/
- (void)mutePlaybacDevice:(BOOL)mute;

/**
 * Gets the mute state of the playback device.
 *
 * @return  mute A pointer to the mute state of the playback device.
 * - true: The playback device is muted.
 * - false: The playback device is unmuted.
 *
*/
- (BOOL)isPlaybackDeviceMuted;

/**
 * Mutes or unmutes the audio recording device.
 *
 * @param mute Determines whether to mute the recording device.
 * - true: Mute the microphone.
 * - false: Unmute the microphone.
*/
- (void)muteRecordingDevice:(BOOL)mute;

/**
 * Gets the mute state of the audio recording device.
 *
 * @return mute A pointer to the mute state of the recording device.
 * - true: The microphone is muted.
 * - false: The microphone is unmuted.
*/
- (BOOL)isRecordingDeviceMuted;

/**
 * Starts the audio playback device test.
 *
 * This method tests if the playback device works properly. In the test, the
 * SDK plays an audio file specified by the user. If the user hears the audio,
 * the playback device works properly.
 *
 * @param testAudioFilePath The file path of the audio file for the test,
 * which is an absolute path in UTF8:
 * - Supported file format: wav, mp3, m4a, and aac.
 * - Supported file sampling rate: 8000, 16000, 32000, 44100, and 48000.
 *
*/
- (void)startPlaybackDeviceTestWithAudioFilePath:(NSString * _Nullable)testAudioFilePath;

/**
 * Stops the audio playback device test.
 *
*/
- (void)stopPlaybackDeviceTest;

/**
 * Starts the recording device test.
 *
 * This method tests whether the recording device works properly. Once the
 * test starts, the SDK uses the \ref
 * IAudioDeviceManagerObserver::onAudioVolumeIndication
 * "onAudioVolumeIndication" callback to notify the app on the volume
 * information.
 *
 * @param indicationInterval The time interval (ms) between which the SDK
 * triggers the `onAudioVolumeIndication` callback.
 *
*/
- (void)startRecordingDeviceTestWithIndicationInterval:(NSInteger)indicationInterval;

/**
 * Stops the recording device test.
 *
*/
- (void)stopRecordingDeviceTest;

/**
 * Starts the audio device loopback test.
 *
 * This method tests whether the local audio devices are working properly.
 * After calling this method, the microphone captures the local audio and
 * plays it through the speaker, and the \ref
 * IAudioDeviceManagerObserver::onAudioVolumeIndication
 * "onAudioVolumeIndication" callback returns the local audio volume
 * information at the set interval.
 *
 * @note This method tests the local audio devices and does not report the
 * network conditions.
 * @param indicationInterval The time interval (ms) at which the \ref
 * IAudioDeviceManagerObserver::onAudioVolumeIndication
 * "onAudioVolumeIndication" callback returns.
 * @return
 * - 0: Success.
 * - < 0: Failure.
*/
- (void)startDeviceLoopbackTestWithIndicationInterval:(NSInteger)indicationInterval;

/**
 * Stops the audio device loopback test.
 *
 * @note Ensure that you call this method to stop the loopback test after
 * calling the \ref IAgoraRteAudioDeviceManager::StartAudioDeviceLoopbackTest
 * "StartAudioDeviceLoopbackTest" method.
 * @return
 * - 0: Success.
 * - < 0: Failure.
*/
- (void)stopDeviceLoopbackTest;

@end


@protocol AgoraRteVideoDeviceManagerProtocol <NSObject>

- (NSArray <AgoraRteVideoDeviceInfo *>* _Nullable)enumerateVideoDevices;

@end

