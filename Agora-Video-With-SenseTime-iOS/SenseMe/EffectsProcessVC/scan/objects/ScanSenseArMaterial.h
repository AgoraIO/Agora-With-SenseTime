//
//  ScanSenseArMaterial.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "SenseArMaterial.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScanSenseArMaterial : SenseArMaterial

@property (nonatomic, copy) NSString *strMaterialURL;
@property (nonatomic, copy) NSString *strID;
@property (nonatomic, copy) NSString *strMaterialFileID;

@end

NS_ASSUME_NONNULL_END
