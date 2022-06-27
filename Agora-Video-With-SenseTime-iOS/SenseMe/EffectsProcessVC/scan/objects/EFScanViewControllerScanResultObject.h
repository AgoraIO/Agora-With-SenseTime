//
//  EFScanViewControllerScanResultObject.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/2/25.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFScanViewControllerScanResultObject : NSObject <YYModel>

@property (nonatomic, assign) BOOL successed;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *icon;

@end

NS_ASSUME_NONNULL_END
