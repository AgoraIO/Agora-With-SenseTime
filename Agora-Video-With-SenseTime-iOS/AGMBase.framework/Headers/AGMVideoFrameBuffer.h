/*
 *  Copyright 2017 The AgoraAGM project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <AVFoundation/AVFoundation.h>

#import "AGMMacros.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AGMI420Buffer;

// AGMVideoFrameBuffer is an ObjectiveC version of AgoraAGM::VideoFrameBuffer.
AGM_OBJC_EXPORT
@protocol AGMVideoFrameBuffer <NSObject>

@property(nonatomic, readonly) int width;
@property(nonatomic, readonly) int height;

- (id<AGMI420Buffer>)toI420;

@end

NS_ASSUME_NONNULL_END
