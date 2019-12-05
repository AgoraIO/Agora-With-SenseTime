//
//  AGMEncodedImage.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AGMMacros.h"
#import "AGMVideoFrame.h"

NS_ASSUME_NONNULL_BEGIN


/** Represents an encoded frame. */
@interface AGMEncodedImage : NSObject

@property (nonatomic, strong) NSData *buffer;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int64_t timeStamp;
@property (nonatomic, assign) BOOL isKey;


@end

NS_ASSUME_NONNULL_END
