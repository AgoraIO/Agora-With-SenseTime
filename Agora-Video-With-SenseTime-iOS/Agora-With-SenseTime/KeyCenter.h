//
//  KeyCenter.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/26.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyCenter : NSObject

-(NSString*)agoraAppId;
-(NSString*)agoraAppToken;

-(NSString*)senseAppId;
-(NSString*)senseAppKey;

@end

NS_ASSUME_NONNULL_END
