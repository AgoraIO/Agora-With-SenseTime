//
//  EFStatusManager.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFSenseArMaterialDataModels.h"
#import "EFMaterialDownloadStatusManager.h"
#import "EFStatusManagerDelegate.h"
#import "EFStatusModels.h"

/// 一级路径mask
static NSUInteger _k1_mask = 0xffff000000;
/// 二级路径mask
static NSUInteger _k2_mask = 0xff0000;
/// 三级路径mask
static NSUInteger _k3_mask = 0xffff;
// 一级+二级路径mask
static NSUInteger _k12_mask = 0xffffff0000;

@interface EFStatusManager : NSObject <NSSecureCoding, NSCoding>

@property (nonatomic, readonly, strong) NSArray *efSpecialTypes;
@property (nonatomic, readonly, strong) NSArray *efSpecial3DNames;

@property (nonatomic, readonly, strong) NSArray *efStickers;

@property (nonatomic, readwrite, weak) id<EFStatusManagerDelegate> efDelegate;

typedef enum : NSUInteger {
    EFStatusManagerSingletonMode1,
    EFStatusManagerSingletonMode2,
    EFStatusManagerSingletonMode3,
} EFStatusManagerSingletonMode;

/// EFStatusManager的构造方法
/// @param mode 1、2、3 - 预览版/图片版/视频版应使用不同的mode （mode1默认开启缓存 其他默认关闭）
+(instancetype)sharedInstanceWith:(EFStatusManagerSingletonMode)mode;

/// 用作测试
/// @param model 测试用
- (void)test:(id<EFDataSourcing>)model;

/// 选中/点击了model（默认互斥）
/// @param model 目标model
- (void)efModelSelected:(id<EFDataSourcing>)model;

/// 选中/点击了material model（默认互斥）
/// @param model 目标model
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
- (void)efModelSelected:(id<EFDataSourcing>)model onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure;

/// 选中/点击了material model（手动互斥）
/// @param model 目标model
/// @param needMutex 是否需要互斥
/// @param processingCallBack 下载进度block
/// @param completeSuccess 下载成功block
/// @param completeFailure 下载失败block
- (void)efModelSelected:(id<EFDataSourcing>)model needMutex:(BOOL)needMutex onProgress:(void (^)(id<EFDataSourcing> material , float fProgress , int64_t iSize))processingCallBack onSuccess:(void (^)(id<EFDataSourcing> material))completeSuccess onFailure:(void (^)(id<EFDataSourcing> material , int iErrorCode , NSString *strMessage))completeFailure;

/// 选中/点击了model（手动互斥）
/// @param model 目标model
/// @param needMutex 是否需要互斥
- (void)efModelSelected:(id<EFDataSourcing>)model needMutex:(BOOL)needMutex;

/// 判断目标model是否已经被选中
/// @param model 目标model
- (BOOL)efModelHasSelected:(id<EFDataSourcing>)model;

/// 获取model对应的强度
/// @param model 目标model
- (CGFloat)efStrengthOfModel:(id<EFDataSourcing>)model;

/// model强度发生改变
/// @param model 目标model
/// @param newValue 变化后的强度
- (BOOL)efModel:(id<EFDataSourcing>)model strengthChanged:(CGFloat)newValue;

/// 为当前manger开/关缓存 mode1默认开启 其他默认关闭
/// @param isOpenCache 设置的状态
- (BOOL)efSwitchCache:(BOOL)isOpenCache;

/// 清零
/// @param model 可以传入二级model也可以传入二级model中任意一个具体效果model
- (void)efClear:(id<EFDataSourcing>)model;

/// 重置
/// @param model 可以传入二级model也可以传入二级model中任意一个具体效果model
- (void)efReset:(id<EFDataSourcing>)model;

#pragma mark - 素材下载状态相关api
/// 获取当前model的下载状态
/// @param model target model
-(EFMaterialDownloadStatus)efDownloadStatus:(id<EFDataSourcing>)model;

/// 触发所有存储的效果 （比如启动时加载已经保存的效果/首次启动加载默认效果）
-(void)efTriggerAllStorage;

/// 从over lap更新current storage 在将要展示当前参数状态之前 手动调用一次该方法以更新
-(void)efGetOverLapAndUpdateCurrentStorage;

/// 从cache storage还原current storage（移除所有的临时保存状态）
-(void)efRestoreCurrentStorageFromCache;

#pragma mark - system
-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end
