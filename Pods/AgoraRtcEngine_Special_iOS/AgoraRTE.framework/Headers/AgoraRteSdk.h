/*
 * @Author: your name
 * @Date: 2021-08-10 17:44:29
 * @LastEditTime: 2021-08-10 20:41:18
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /vars/Users/zhanxiaochao/Desktop/rte_project/media_sdk_script/rte_sdk/interface/objc/rte/AgoraRteSdk.h
 */
//
//  Agora Real-time Engagement
//
//  Copyright (c) 2021 Agora.io. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AgoraRteBase.h"
#import "AgoraRteMediaFactoryProtocol.h"
#import "AgoraRteDeviceManagerProtocol.h"
#import "AgoraRteSceneProtocol.h"

__attribute__((visibility("default")))
@interface AgoraRteSdk : NSObject

+ (instancetype _Nonnull)sharedEngineWithProfile:(AgoraRteSdkProfile *_Nonnull)profile;
+ (void)destroy;
- (id<AgoraRteSceneProtocol>_Nullable)createRteSceneWithSceneId:(NSString *_Nonnull)sceneId sceneConfig:(AgoraRteSceneConfg *_Nonnull)config;
- (id<AgoraRteMediaFactoryProtocol> _Nullable)rteMediaFactory;
- (int)enableExtensionOnRemoteStreamWithProviderName:(NSString * _Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName;
- (int)disableExtensionOnRemoteStreamWithProviderName:(NSString * _Nonnull)providerName extensionName:(NSString *_Nonnull)extensionName;

#if (!(TARGET_OS_IPHONE) && (TARGET_OS_MAC))
- (id<AgoraRteAudioDeviceManagerProtocol>_Nullable)rteAudioDeviceManager;
- (id<AgoraRteVideoDeviceManagerProtocol> _Nullable)rteVideoDeviceManager;
#endif






@end
