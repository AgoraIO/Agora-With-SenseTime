//
//  AGMEncodedAudio.h
//  AgoraRtmpStreamingKit
//
//  Created by LSQ on 2019/11/21.
//  Copyright © 2019 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGMEncodedAudio : NSObject

@property (nonatomic, assign) char *data;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) BOOL isHasAdts;

@end

NS_ASSUME_NONNULL_END
