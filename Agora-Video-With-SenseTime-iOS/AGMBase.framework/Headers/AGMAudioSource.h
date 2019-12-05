//
//  AGMAudioSource.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGMAudioSink.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMAudioSource : NSObject

/** Returns an array of the current targets.
 */
- (NSArray*)allSinks;
- (void)addAudioSink:(id<AGMAudioSink>)sink;
- (void)removeAudioSink:(id<AGMAudioSink>)sink;

@end

NS_ASSUME_NONNULL_END
