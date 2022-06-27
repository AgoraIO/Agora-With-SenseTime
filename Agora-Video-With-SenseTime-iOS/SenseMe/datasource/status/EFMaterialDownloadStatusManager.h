//
//  EFMaterialDownloadStatusManager.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFDataSourcing.h"

typedef enum : NSUInteger {
    EFMaterialDownloadStatusNotDownload = 0,
    EFMaterialDownloadStatusDownloading,
    EFMaterialDownloadStatusDownloaded,
} EFMaterialDownloadStatus;

@interface EFMaterialDownloadStatusManager : NSObject <NSSecureCoding, NSCoding>

/// 构造方法
+(instancetype)sharedInstance;

/// 获取当前model的下载状态
/// @param model target model
-(EFMaterialDownloadStatus)efDownloadStatus:(id<EFDataSourcing>)model;

/// 开始下载
/// @param model 选中的model
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
-(void)efStartDownload:(id<EFDataSourcing>)model onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure;

-(void)efStartDownloadTryOn:(id<EFDataSourcing>)model onProgress:(void (^)(SenseArMaterial *material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(SenseArMaterial *material))completeSuccess onFailure:(void (^)(SenseArMaterial *material , int iErrorCode , NSString *strMessage))completeFailure;

/// 由数据源model置换出已下载素材model （如果没有下载成功则返回原model）
/// @param orginModel 数据源model
-(EFDataSourceMaterialModel *)efDisplacesWith:(EFDataSourceMaterialModel *)orginModel;

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end
