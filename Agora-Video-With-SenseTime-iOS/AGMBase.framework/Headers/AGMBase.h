//
//  AGMBase.h
//  AGMBase
//
//  Created by LSQ on 2019/11/22.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for AGMBase.
FOUNDATION_EXPORT double AGMBaseVersionNumber;

//! Project version string for AGMBase.
FOUNDATION_EXPORT const unsigned char AGMBaseVersionString[];

#define AGMBaseModuleVersion @"1.0.0"

// In this header, you should import all the public headers of your framework using statements like #import <AGMBase/PublicHeader.h>
#import <AGMBase/AGMAudioSink.h>
#import <AGMBase/AGMAudioFrame.h>
#import <AGMBase/AGMAudioSource.h>
#import <AGMBase/AGMVideoSink.h>
#import <AGMBase/AGMVideoFrame.h>
#import <AGMBase/AGMVideoSource.h>
#import <AGMBase/AGMLogging.h>
#import <AGMBase/AGMEncodedAudio.h>
#import <AGMBase/AGMEncodedImage.h>
#import <AGMBase/AGMCVPixelBuffer.h>
#import <AGMBase/AGMVideoFrameBuffer.h>
#if TARGET_OS_IPHONE
#import <AGMBase/UIDevice+AGMDevice.h>
#endif
#import <AGMBase/AGMDispatcher+Private.h>
#import <AGMBase/AGMMacros.h>
#import <AGMBase/AGMConfig.h>
