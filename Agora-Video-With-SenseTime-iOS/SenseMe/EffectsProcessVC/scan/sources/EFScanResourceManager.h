//
//  EFScanResourceManager.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFScanResourceModel.h"
#import "EFScanViewControllerScanResultObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    EFScanResourceDownloadStatusSuccessed,
    EFScanResourceDownloadStatusFailed,
} EFScanResourceDownloadStatus;

@class EFScanResourceManager;

@protocol EFScanResourceManagerDelegate <NSObject>

@optional
-(void)scanResourceManager:(EFScanResourceManager *)manager downloadStatusChanged:(EFScanResourceDownloadStatus)stauts;

@end

__attribute__((objc_subclassing_restricted))
@interface EFScanResourceManager : NSObject

@property (nonatomic, readonly, strong) NSMutableArray <EFScanResourceModel * > *cacheList;
@property (nonatomic, weak) id<EFScanResourceManagerDelegate> delegate;

+(instancetype)sharedManager;

-(void)efProcessingScanResultObject:(EFScanViewControllerScanResultObject *)scanResultObject;

-(instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
