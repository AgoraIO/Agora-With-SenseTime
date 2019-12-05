/*
 *  Copyright 2015 The AgoraAGM project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

#import "AGMMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AGMVideoRotation) {
  AGMVideoRotation_0 = 0,
  AGMVideoRotation_90 = 90,
  AGMVideoRotation_180 = 180,
  AGMVideoRotation_270 = 270,
};

@protocol AGMVideoFrameBuffer;

// AGMVideoFrame is an ObjectiveC version of AgoraAGM::VideoFrame.
AGM_OBJC_EXPORT
@interface AGMVideoFrame : NSObject

/** Width without rotation applied. */
@property(nonatomic, readonly) int width;

/** Height without rotation applied. */
@property(nonatomic, readonly) int height;
@property(nonatomic, readonly) AGMVideoRotation rotation;

/** Timestamp in nanoseconds. */
@property(nonatomic, readonly) int64_t timeStampNs;

/** Timestamp. */
@property(nonatomic, readonly) CMTime timeStamp;

@property (nonatomic, readonly) id<AGMVideoFrameBuffer> buffer;
@property(nonatomic, assign) BOOL usingFrontCamera;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;


/** Initialize an AGMVideoFrame from a frame buffer, rotation, and timestamp.
 */
- (instancetype)initWithBuffer:(id<AGMVideoFrameBuffer>)frameBuffer
                      rotation:(AGMVideoRotation)rotation
                   timeStamp:(CMTime)timeStamp;


/** Return a frame that is guaranteed to be I420, i.e. it is possible to access
 *  the YUV data on it.
 */
- (AGMVideoFrame *)newI420VideoFrame;

@end

NS_ASSUME_NONNULL_END
