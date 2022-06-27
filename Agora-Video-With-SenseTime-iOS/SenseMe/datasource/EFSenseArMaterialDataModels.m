//
//  EFSenseArMaterialDataModels.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/4.
//

#import "EFSenseArMaterialDataModels.h"
#import <objc/runtime.h>
#import "NSObject+dictionary.h"

static NSString * const efMaterialsArrayKey;

@interface EFDataSourceModel ()

//@property (nonatomic, readwrite, copy) NSString * efName;
//@property (nonatomic, readwrite, copy) NSString * efThumbnailDefault;
@property (nonatomic, readwrite, copy) NSString * efThumbnailHighlight;
//@property (nonatomic, readwrite, copy) NSString * efMaterialPath;
//@property (nonatomic, readwrite, assign) NSUInteger efType;
//@property (nonatomic, readwrite, assign) NSUInteger efRoute;

@end

@implementation EFDataSourceModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"efName": @"name",
        @"efThumbnailDefault": @"imageName",
        @"efThumbnailHighlight": @"highlightImageName",
        @"efType": @"type",
        @"efMaterialPath": @"path",
        @"efRoute": @"route",
        @"efSubDataSources": @[@"subDataSources", @"all_categories"],
    };
}

-(void)setEfMaterials:(NSArray<SenseArMaterial *> *)efMaterials {
    NSMutableArray * efMaterialModels = [NSMutableArray array];
    for (NSInteger i = 0; i < efMaterials.count; i ++) {
        SenseArMaterial * efMaterial = efMaterials[i];
        EFDataSourceMaterialModel * materialModel = [EFDataSourceMaterialModel yy_modelWithDictionary:[efMaterial efDictionaryValue]];
        materialModel.efName = materialModel.strName;
        materialModel.efThumbnailDefault = materialModel.strThumbnailURL;
        /// ——/—/—/———
        /// type/path_flag/mode_flag/mode
        materialModel.efType = (materialModel.iMaterialType << 5) | (1 << 4);
        //        materialModel.efMaterialPath = materialModel.strMaterialPath;
        materialModel.efRoute = (self.efRoute | (i + 1));
        [efMaterialModels addObject:materialModel];
    }
    self.efSubDataSources = [efMaterialModels copy];
}

-(NSString *)efAlias {
    if (_efAlias) return _efAlias;
    return _efName;
}

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"efSubDataSources": EFDataSourceModel.class
    };
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

@end

@implementation SenseArMaterialGroup (efMaterial)

-(void)setMaterialsArray:(NSArray<SenseArMaterial *> *)materialsArray {
    objc_setAssociatedObject(self, &efMaterialsArrayKey, materialsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray<SenseArMaterial *> *)materialsArray {
    return objc_getAssociatedObject(self, &efMaterialsArrayKey);
}

@end

@implementation SenseArMaterial (efMaterial)

@end

@interface EFDataSourceMaterialModel ()

@property (nonatomic , copy , readwrite) NSString *strID;
@property (nonatomic , copy , readwrite) NSString *strMaterialFileID;
@property (nonatomic , assign , readwrite) NSUInteger iMaterialType;
@property (nonatomic , copy , readwrite) NSString *strThumbnailURL;
@property (nonatomic , copy , readwrite) NSString *strMaterialURL;
//@property (nonatomic , copy , readwrite) NSString *strMaterialPath;
@property (nonatomic , copy , readwrite) NSArray <EFDataSourceMaterialModelAction *>* arrMaterialTriggerActions;
@property (nonatomic , copy , readwrite) NSString *strName;
@property (nonatomic , copy , readwrite) NSString *strInstructions;
@property (nonatomic , copy , readwrite) NSString *strExtendInfo;
@property (nonatomic , copy , readwrite) NSString *strExtendInfo2;
@property (nonatomic , copy , readwrite) NSString *strRequestID;
@property (nonatomic , copy , readwrite) NSString *strAdSlogen;
@property (nonatomic , copy , readwrite) NSString *strIdeaID;
@property (nonatomic , copy , readwrite) NSString *strAdLink;

@end

@implementation EFDataSourceMaterialModel

-(NSString *)strThumbnailURL {
    if (!_strThumbnailURL) {
        return self.efThumbnailDefault;
    }
    return _strThumbnailURL;
}

-(NSString *)strID {
    if (!_strID) {
        return self.efName;
    }
    return _strID;
}

-(NSString *)strMaterialPath {
    if (!_strMaterialPath) {
        return self.efMaterialPath;
    }
    return _strMaterialPath;
}

-(NSString *)strName {
    if (!_strName) {
        return self.efName;
    }
    return _strName;
}

@end

@interface EFDataSourceMaterialModelAction ()

@property (nonatomic , assign , readwrite) NSUInteger iTriggerAction;
@property (nonatomic , copy , readwrite) NSString *strTriggerActionTip;

@end

@implementation EFDataSourceMaterialModelAction

@end


