//
//  EFRemoteDataSourceHelper.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFRemoteDataSourceHelper.h"
#import "NSDictionary+jsonFile.h"
#import "EFSenseArMaterialDataModels.h"
#import "EFAuthorizeAdapter.h"

// !!!: 获取素材使用的user id
static NSString * const efSenseArMaterialServiceUserID = @"testUserID";

@implementation EFRemoteDataSourceHelper

/// 获取所有的material 分组以及对应的素材列表
/// @param completeSuccess 成功回调
/// @param completeFailure 失败回调
+(void) efFetchAllRemoteGroupsWithMaterialsOnSuccess:(void (^)(NSArray <SenseArMaterialGroup *>* arrMaterialGroups))completeSuccess onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure {
    dispatch_group_t efDatasourceGroup = dispatch_group_create();
    [self _efFetchAllRemoteGroupsOnSuccess:^(NSArray<SenseArMaterialGroup *> *arrMaterialGroups) {
//        DLog(@"group获取完毕 开始请求数据");
        for (SenseArMaterialGroup * group in arrMaterialGroups) {
//            DLog(@"开始请求%@", group.strGroupName);
            dispatch_group_enter(efDatasourceGroup);
            [self _efFetchMaterialsWithUserID:efSenseArMaterialServiceUserID andGroup:group onSuccess:^(NSArray<SenseArMaterial *> *arrMaterials) {
                @synchronized (group) { group.materialsArray = arrMaterials; }
                dispatch_group_leave(efDatasourceGroup);
//                DLog(@"请求成功%@", group.strGroupName);
            } onFailure:^(int iErrorCode, NSString *strMessage) {
//                DLog(@"请求失败%@ - %@", group.strGroupName, strMessage);
                dispatch_group_leave(efDatasourceGroup);
            }];
        }
        dispatch_group_notify(efDatasourceGroup, dispatch_get_main_queue(), ^{
            DLog(@"网络请求结束");
            if (completeSuccess) completeSuccess(arrMaterialGroups);
        });
    } onFailure:^(int iErrorCode , NSString *strMessage) {
        DLog(@"group请求失败 %@", strMessage);
        if (completeFailure) {
            completeFailure(iErrorCode, strMessage);
        }
    }];
}

/// 从服务器获取分组列表
/// @param completeSuccess 获取成功回调
/// @param completeFailure 失败回调
+(void)_efFetchAllRemoteGroupsOnSuccess:(void (^)(NSArray <SenseArMaterialGroup *>* arrMaterialGroups))completeSuccess onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure {
    
    NSDictionary * serviceEffectsGroupDict = [NSDictionary efTakeOutDatasourceFromJson:@"effects_service_group_list"];
    NSArray * serviceEffectsGroupList = serviceEffectsGroupDict[@"effects"];
    NSMutableArray <SenseArMaterialGroup *> * groups = [NSMutableArray array];
    for (NSDictionary * groupDict in serviceEffectsGroupList) {
        SenseArMaterialGroup * group = [[SenseArMaterialGroup alloc] init];
        group.strGroupName = groupDict[@"name"];
        group.strGroupID = groupDict[@"group"];
        [groups addObject:group];
    }

    [self _efAuthorizeWithCallback:^(BOOL isAuthorized, SenseArAuthorizeError code ,SenseArMaterialService * service) {
        if (isAuthorized) {
            [service fetchAllGroupsOnSuccess:^(NSArray<SenseArMaterialGroup *> *arrMaterialGroups) {
                for (SenseArMaterialGroup * group in arrMaterialGroups) {
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF.strGroupName == %@", group.strGroupName];
                    if (![groups filteredArrayUsingPredicate:predicate] || [groups filteredArrayUsingPredicate:predicate].count == 0) {
                        [groups addObject:group];
                    }
                }
                if (completeSuccess) completeSuccess([groups copy]);
            } onFailure:^(int iErrorCode, NSString *strMessage) {
                if (completeSuccess) completeSuccess([groups copy]);
            }];
        }else{
            if (completeFailure) {
                completeFailure(code, @"鉴权失败!!!");
            }
        }
    }];
}

/// 根据group 获取 Material 列表
/// @param userID 用户ID , 如 主播ID, 粉丝ID 等 .
/// @param group 素材所在组的 groupID
/// @param completeSuccess 获取成功回调
/// @param completeFailure 失败回调
+(void)_efFetchMaterialsWithUserID:(NSString *)userID andGroup:(SenseArMaterialGroup *)group onSuccess:(void (^)(NSArray <SenseArMaterial *>* arrMaterials))completeSuccess onFailure:(void (^)(int iErrorCode , NSString *strMessage))completeFailure {
    if ([group.strGroupName isEqualToString:@"物体跟踪"]) {
        if (completeSuccess) {
            completeSuccess([NSArray array]);
        }
    } else {
        [self _efAuthorizeWithCallback:^(BOOL isAuthorized, SenseArAuthorizeError code, SenseArMaterialService *service) {
            if (isAuthorized) [service fetchMaterialsWithUserID:userID GroupID:group.strGroupID onSuccess:completeSuccess onFailure:completeFailure];
        }];
    }
}

/// 鉴权
/// @param callback 鉴权结果回调
+(void)_efAuthorizeWithCallback:(void(^)(BOOL isAuthorized, SenseArAuthorizeError code, SenseArMaterialService * service))callback {
    [EFAuthorizeAdapter efAuthorizeWithCallback:callback];
}

+(NSArray <NSString *> *)_efGetAllTracks {
    return [NSArray array];
}

@end
