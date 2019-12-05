//
//  AGMVideoSink.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/7.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGMVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AGMVideoSink <NSObject>

- (void)onFrame:(AGMVideoFrame *)videoFrame;

@optional
// Should be called by the source when it discards the frame due to rate limiting.
- (void)onDiscardedFrame;

@end

NS_ASSUME_NONNULL_END
