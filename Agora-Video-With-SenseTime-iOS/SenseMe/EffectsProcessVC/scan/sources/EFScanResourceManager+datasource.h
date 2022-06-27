//
//  EFScanResourceManager+datasource.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFScanResourceManager.h"
#import "ScanSenseArMaterial.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EFScanResourceManagerCallback)(NSArray <EFDataSourceMaterialModel *> *models);

@interface EFScanResourceManager (datasource)

-(void)transformSuperModel:(EFDataSourceModel *)superModel WithCallback:(EFScanResourceManagerCallback)callback;

@end

NS_ASSUME_NONNULL_END
