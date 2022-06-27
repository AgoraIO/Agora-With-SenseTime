//
//  EFSenseArMaterialDataModels.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/4.
//

#import <Foundation/Foundation.h>
#import "SenseArMaterialService.h"
#import "EFDataSourcing.h"
#import "YYModel.h"

#pragma mark - EFDataSourceModel
@interface EFDataSourceModel : NSObject <EFDataSourcing, YYModel, NSCopying>

/// 名称
@property (nonatomic, readwrite, copy) NSString * efName;
/// 别名
@property (nonatomic, readwrite, copy) NSString * efAlias;
/// 图标名称
@property (nonatomic, readwrite, copy) NSString * efThumbnailDefault;
/// 选中图标名称
@property (nonatomic, readonly, copy) NSString * efThumbnailHighlight;
/// 效果地址
@property (nonatomic, readwrite, copy) NSString * efMaterialPath;
/// 效果类型 （sdk枚举 + path_f + mode_f + mode_v）
@property (nonatomic, readwrite, assign) NSUInteger efType;
/// 下级效果列表
@property (nonatomic, readwrite, strong) NSArray <EFDataSourcing> * efSubDataSources;

@property (nonatomic, readwrite, assign) NSUInteger efRoute;

/// 素材列表
@property (nonatomic, readwrite, strong) NSArray <SenseArMaterial *> * efMaterials DEPRECATED_MSG_ATTRIBUTE("已经废弃，「特效」中使用efSubDataSources来代替"); // 特效 才需要此model

/// 表示是否可以叠加（本地多贴纸）
@property (nonatomic, readwrite, assign) BOOL efIsMulti;

-(void)setEfMaterials:(NSArray<SenseArMaterial *> *)efMaterials;

@end

#pragma mark - SenseArMaterialGroup (efMaterial)
@interface SenseArMaterialGroup (efMaterial)

@property (nonatomic, strong) NSArray <SenseArMaterial *> * materialsArray;

@end

#pragma mark - EFDataSourceMaterialModelAction
@interface EFDataSourceMaterialModelAction : NSObject <YYModel>

/**
 *  触发动作
 */
@property (nonatomic , assign , readonly) NSUInteger iTriggerAction;

/**
 *  触发动作描述
 */
@property (nonatomic , copy , readonly) NSString *strTriggerActionTip;

@end

#pragma mark - EFDataSourceMaterialModel
@interface EFDataSourceMaterialModel : EFDataSourceModel

@property (nonatomic, readwrite, assign) BOOL efFromBundle;

@property (nonatomic, readwrite, assign) BOOL efIsLocal;

/**
 *  素材ID
 */
@property (nonatomic , copy , readonly) NSString *strID;


/**
 *  素材文件ID
 */
@property (nonatomic , copy , readonly) NSString *strMaterialFileID;


/**
 *  素材类型
 */
@property (nonatomic , assign , readonly) NSUInteger iMaterialType;


/**
 *  素材缩略图地址
 */
@property (nonatomic , copy , readonly) NSString *strThumbnailURL;


/**
 *  素材文件地址
 */
@property (nonatomic , copy , readonly) NSString *strMaterialURL;


/**
 *  素材文件本地路径
 */
@property (nonatomic , copy , readwrite) NSString *strMaterialPath;


/**
 *  素材触发信息数组 , 触发信息包含触发的动作类型及触发动作的提示
 */
@property (nonatomic , copy , readonly) NSArray <EFDataSourceMaterialModelAction *>* arrMaterialTriggerActions;


/**
 *  素材名称
 */
@property (nonatomic , copy , readonly) NSString *strName;


/**
 *  素材描述
 */
@property (nonatomic , copy , readonly) NSString *strInstructions;


/**
 *  话题
 */
@property (nonatomic , copy , readonly) NSString *strExtendInfo;


/**
 *  扩展信息
 */
@property (nonatomic , copy , readonly) NSString *strExtendInfo2;


/**
    请求标识
 */
@property (nonatomic , copy , readonly) NSString *strRequestID;


/**
    广告语
 */
@property (nonatomic , copy , readonly) NSString *strAdSlogen;


/**
    ideaID
 */
@property (nonatomic , copy , readonly) NSString *strIdeaID;


/**
 广告链接
 */
@property (nonatomic , copy , readonly) NSString *strAdLink;

@end
