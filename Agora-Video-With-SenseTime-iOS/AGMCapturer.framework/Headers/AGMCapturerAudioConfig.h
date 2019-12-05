//
//  AGMCapturerAudioConfig.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/12.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGMCapturerAudioConfig : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 + (instancetype)defaultConfig
 {
     AGMCapturerAudioConfig *config = [[AGMCapturerAudioConfig alloc] init];
     config.bitrate = 128*1000;
     config.channels = 2;
     config.samplerate = 44100;
     return config;
 }
 */
+ (instancetype)defaultConfig;

@property (nonatomic, assign) NSInteger samplerate;
@property (nonatomic, assign) NSInteger channels;
@property (nonatomic, assign) NSInteger bitrate;

@end

NS_ASSUME_NONNULL_END
