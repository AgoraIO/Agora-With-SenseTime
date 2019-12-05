//
//  AGMAudioCapturer.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <AGMBase/AGMAudioSource.h>
#import "AGMCapturerAudioConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMAudioCapturer : AGMAudioSource

- (instancetype)initWithConfig:(AGMCapturerAudioConfig *)config;
- (BOOL)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
