//
//  AGMVideoRenderer.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/7.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <AGMBase/AGMVideoSource.h>
#import <AGMBase/AGMVideoSink.h>
#import "AGMRendererConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGMVideoRenderer : AGMVideoSource <AGMVideoSink>
// Video preview, iOS:UIView, Mac:NSView
@property (nonatomic, strong, nonnull) AGMView *preView;

- (instancetype)initWithConfig:(AGMRendererConfig *)config;

// Configure the renderer's parameters to share the glContext with the outside world.
- (instancetype)initWithConfig:(AGMRendererConfig *)config glContext:(nullable EAGLContext *)glContext;

- (BOOL)start;

- (void)stop;

- (void)dispose;


@end

NS_ASSUME_NONNULL_END
