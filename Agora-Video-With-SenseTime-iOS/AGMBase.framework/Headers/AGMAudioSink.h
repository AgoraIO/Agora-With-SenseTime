//
//  AGMAudioSink.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGMAudioFrame.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AGMAudioSink <NSObject>

- (void)onAudioFrame:(AGMAudioFrame *)frame;

@end

NS_ASSUME_NONNULL_END
