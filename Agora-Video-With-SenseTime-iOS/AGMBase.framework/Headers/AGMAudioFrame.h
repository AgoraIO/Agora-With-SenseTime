//
//  AGMAudioFrame.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGMAudioFrame : NSObject
// data buffer
@property (nonatomic, assign) void *data;
// buffer byte size
@property (nonatomic, assign) NSInteger bufferSize;
@property (nonatomic, assign) NSInteger samplesPerChannel;
// samplesPerSec
@property (nonatomic, assign) NSInteger sampleRate;
// number of channels (data are interleaved if stereo)
@property (nonatomic, assign) NSInteger channels;
@property (nonatomic, assign) UInt64 timestamp;

@end

NS_ASSUME_NONNULL_END
