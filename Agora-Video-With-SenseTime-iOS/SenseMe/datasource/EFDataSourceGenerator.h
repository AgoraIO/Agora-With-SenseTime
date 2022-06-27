//
//  EFDataSourceGenerator.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/3.
//

#import <Foundation/Foundation.h>
#import "EFSenseArMaterialDataModels.h"

struct EFDatasourceTypeStruct {
    NSUInteger real_type;
    NSUInteger has_path;
    NSUInteger has_mode;
    NSUInteger mode_type;
};

typedef void(^EFDataSourceGeneratorCallback)(id <EFDataSourcing> datasource);

@interface EFDataSourceGenerator : NSObject

/// 数据源 由于是异步回调 应在 -efGeneratAllDataSourceWithCallback: 回调后再进行访问取值
@property (nonatomic, readonly, strong) EFDataSourceModel * efDataSourceModel;
/// 带基础美颜强度的默认缓存列表
@property (nonatomic, readonly, strong) NSArray * efDefaultStatusArray;

@property (nonatomic, readonly, strong) NSArray * efTryonDatasource;

-(instancetype)init NS_UNAVAILABLE;

+(instancetype)sharedInstance;

/// 生成所有数据
/// @param callback 生成回调 在返回model的efSubDataSources数据中获取所有分类数据
-(void)efGeneratAllDataSourceWithCallback:(EFDataSourceGeneratorCallback)callback;

/// 根据脸型type生成默认美颜参数
/// @param faceType 脸型type
-(void)efGeneratDefaultBeautyParametersBy:(NSUInteger)faceType;

-(NSUInteger)efRealType:(NSUInteger)originType;

struct EFDatasourceTypeStruct efConvertType(NSUInteger modelType);

@end

