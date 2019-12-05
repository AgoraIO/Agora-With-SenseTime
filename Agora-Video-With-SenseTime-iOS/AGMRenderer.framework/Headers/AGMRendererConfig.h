//
//  AGMRendererConfig.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/7.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AGMBase/AGMConfig.h>

NS_ASSUME_NONNULL_BEGIN


@interface AGMRendererConfig : NSObject

// Video render mode.
@property (nonatomic, assign) AGMRENDER_MODE_TYPE renderMode;
// Video mirror mode.
@property (nonatomic, assign) AGMVIDEO_MIRROR_MODE_TYPE mirrorMode;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 + (instancetype)defaultConfig
 {
     AGMRendererConfig *config = [[AGMRendererConfig alloc] init];
     config.mirrorMode = AGMVIDEO_MIRROR_MODE_AUTO;
     config.renderMode = AGMRENDER_MODE_HIDDEN;
     return config;
 }
 */
+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
