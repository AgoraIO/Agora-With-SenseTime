//
//  TryOnLocalSenseArMaterial.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/18.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TryOnLocalSenseArMaterial : NSObject

/**
 *  素材ID
 */
@property (nonatomic , copy) NSString *strID;

/**
 *  素材缩略图地址
 */
@property (nonatomic , copy) NSString *strThumbnailURL;


/**
 *  素材文件地址
 */
@property (nonatomic , copy) NSString *strMaterialURL;


/**
 *  素材文件本地路径
 */
@property (nonatomic , copy) NSString *strMaterialPath;


/**
 *  素材名称
 */
@property (nonatomic , copy) NSString *strName;

@end

NS_ASSUME_NONNULL_END
