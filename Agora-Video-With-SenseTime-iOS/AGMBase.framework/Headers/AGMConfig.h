//
//  AGMConfig.h
//  AGMBase
//
//  Created by LSQ on 2019/11/24.
//  Copyright © 2019 Agora. All rights reserved.
//

#ifndef AGMConfig_h
#define AGMConfig_h

typedef NS_ENUM(NSInteger, AGMRENDER_MODE_TYPE) {
    /**
     1: Uniformly scale the video until one of its dimension fits the boundary
     (zoomed to fit). Areas that are not filled due to the disparity in the aspect
     ratio will be filled with black.
     */
    AGMRENDER_MODE_FIT = 0,
    /**
     2: Uniformly scale the video until it fills the visible boundaries (cropped).
     One dimension of the video may have clipped contents.
     */
    AGMRENDER_MODE_HIDDEN = 1,
};

/** Video mirror mode. */
typedef NS_ENUM(NSInteger, AGMVIDEO_MIRROR_MODE_TYPE) {
  /** 0: Default mirror mode determined by the SDK. */
  AGMVIDEO_MIRROR_MODE_AUTO = 0,  // determined by SDK
  /** 1: Enabled mirror mode */
  AGMVIDEO_MIRROR_MODE_ENABLED = 1,  // enabled mirror
  /** 2: Disabled mirror mode */
  AGMVIDEO_MIRROR_MODE_DISABLED = 2,  // disable mirror
};


#endif /* AGMConfig_h */
