//
//  EFAVPlayer.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/29.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "st_mobile_common.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EFAVPlayerDelegate <NSObject>

- (void)didOutputPixelbuffer:(CVPixelBufferRef)pixelBuffer CMTime:(CMTime)time;
- (void)didPlayToEnd;

@end

@interface EFAVPlayer : NSObject

@property (nonatomic, weak) id<EFAVPlayerDelegate> delegate;
@property (nonatomic) CGAffineTransform tranform;
@property (nonatomic, assign) st_rotate_type rotateType;

@property (nonatomic, readonly, assign) BOOL playing;

/// video size according Vertically
@property (nonatomic, assign) CGSize videoSize;

- (instancetype)initWithURL:(NSURL *)url;

- (void)play;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
