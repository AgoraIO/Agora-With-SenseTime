//
//  AGMVideoSource.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/18.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGMVideoSink.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMVideoSource : NSObject

/** Returns an array of the current targets.
 */
- (NSArray*)allSinks;
- (void)addVideoSink:(id<AGMVideoSink>)sink;
- (void)removeVideoSink:(id<AGMVideoSink>)sink;

@end

NS_ASSUME_NONNULL_END
