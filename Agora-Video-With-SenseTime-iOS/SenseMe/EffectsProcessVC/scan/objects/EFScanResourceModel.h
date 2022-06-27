//
//  EFScanResourceModel.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFScanResourceModel : NSObject <YYModel, NSCoding, NSSecureCoding, NSCopying>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
