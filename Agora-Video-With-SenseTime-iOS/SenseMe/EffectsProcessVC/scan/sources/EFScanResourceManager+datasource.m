//
//  EFScanResourceManager+datasource.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanResourceManager+datasource.h"

@implementation EFScanResourceManager (datasource)

#define materialServiceInstance [SenseArMaterialService sharedInstance]

-(void)transformSuperModel:(EFDataSourceModel *)superModel WithCallback:(EFScanResourceManagerCallback)callback {
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < self.cacheList.count; i ++) {
        dispatch_group_enter(group);
        EFScanResourceModel *cacheModel = self.cacheList[i];
        NSString *localPath = [materialServiceInstance getDownloadedMaterialLocalPathBy:cacheModel.url];
        if (localPath) {
            NSDictionary *datasourceDict = @{
                @"name": cacheModel.url,
                @"path": localPath,
                @"type": @((superModel.efType << 5) | (1 << 4)),
                @"imageName": @"none",
                @"route": @(superModel.efRoute | (i + 1))
            };
            EFDataSourceMaterialModel * materialModel = [EFDataSourceMaterialModel yy_modelWithDictionary:datasourceDict];
            materialModel.efIsLocal = YES;
//            materialModel.efFromBundle = YES;
            materialModel.efThumbnailDefault = cacheModel.imageName;
            [result addObject:materialModel];
            dispatch_group_leave(group);
        } else {
            ScanSenseArMaterial *maskMeterial = [[ScanSenseArMaterial alloc] init];
            maskMeterial.strMaterialURL = cacheModel.url;
            maskMeterial.strID = cacheModel.url;
            maskMeterial.strMaterialFileID = cacheModel.url;
            [materialServiceInstance downloadMaterial:maskMeterial onSuccess:^(SenseArMaterial *material) {
                NSDictionary *datasourceDict = @{
                    @"name": cacheModel.url,
                    @"path": material.strMaterialPath,
                    @"type": @((superModel.efType << 5) | (1 << 4)),
                    @"imageName": @"none",
                    @"route": @(superModel.efRoute | (i + 1))
                };
                EFDataSourceMaterialModel * materialModel = [EFDataSourceMaterialModel yy_modelWithDictionary:datasourceDict];
                materialModel.efIsLocal = YES;
//                materialModel.efFromBundle = YES;
                materialModel.efThumbnailDefault = cacheModel.imageName;
                [result addObject:materialModel];
                dispatch_group_leave(group);
            } onFailure:^(SenseArMaterial *material, int iErrorCode, NSString *strMessage) {
                dispatch_group_leave(group);
            } onProgress:^(SenseArMaterial *material, float fProgress, int64_t iSize) {
                
            }];
        }
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (callback) {
            callback(result);
        }
    });
}



@end
