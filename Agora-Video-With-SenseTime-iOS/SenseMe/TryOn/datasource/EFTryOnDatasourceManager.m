//
//  EFTryOnDatasourceManager.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/24.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnDatasourceManager.h"
#import "TryOnBeautyDataElement.h"
#import "TryOnDataElement.h"
#import "TryOnLocalSenseArMaterial.h"
#import "EFSenseArMaterialDataModels.h"

#define TRY_ON_LOCAL 0

@interface EFTryOnDatasourceManager ()

@property (nonatomic, strong) NSArray *lipsticks;

@end

@implementation EFTryOnDatasourceManager

#pragma mark - properties
-(NSArray<id<TryOnDataElementInterface>> *)dataSource {
    if (!_dataSource) {
        TryOnBeautyDataElement *beautyDataElement = [[TryOnBeautyDataElement alloc] init];
        NSMutableArray *result = [NSMutableArray arrayWithObject:beautyDataElement];
        [result addObjectsFromArray:[self generateColors]];
        _dataSource = result.copy;
    }
    return _dataSource;
}

-(NSArray<TryOnDataElement *> *)generateColors {
    NSArray *remoteMaterialGroups = [EFDataSourceGenerator sharedInstance].efTryonDatasource;
    NSMutableArray *tryOnElements = [NSMutableArray array];
    for (SenseArMaterialGroup *group in remoteMaterialGroups) {
        if ([group.strGroupName isEqualToString:@"TryOn"]) {
            continue;
        }
        TryOnDataElement *dataElement = [[TryOnDataElement alloc] init];
        dataElement.name = [group.strGroupName stringByReplacingOccurrencesOfString:@"TryOn" withString:@""];
        dataElement.colors.materialGroup = group;
        dataElement.colors.imageName = @"tryon_color_gray";
        dataElement.colors.highLightImageName = @"tryon_color";
        dataElement.currentSelectedGroupType = TryOnGroupTypeColor;
        if ([group.strGroupName containsString:@"口红"]) {
            dataElement.styles = [self generateLipstickStyles];
        }
        dataElement.tryOnBeautyType = [self _transformGroupInfo:group];
        [tryOnElements addObject:dataElement];
    }
    
#if TRY_ON_LOCAL
    NSString *tryOnBundlePath = [[NSBundle mainBundle] pathForResource:@"temp_tryon_zips" ofType:@"bundle"];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tryOnBundlePath error:nil];
    for(NSString *file in files) {
        NSString *fullPath = [tryOnBundlePath stringByAppendingPathComponent:file];
        SenseArMaterialGroup *group = [[SenseArMaterialGroup alloc] init];
        group.strGroupName = file;
        group.strGroupID = file;
         
        TryOnLocalSenseArMaterial *material = [[TryOnLocalSenseArMaterial alloc] init];
        material.strID = file;
        material.strName = file;
        material.strMaterialURL = fullPath;
        material.strMaterialPath = fullPath;
        material.strThumbnailURL = @"none";
        group.materialsArray = @[material];
        
        TryOnDataElement *dataElement = [[TryOnDataElement alloc] init];
        dataElement.name = group.strGroupName;
        dataElement.colors.materialGroup = group;
        dataElement.colors.imageName = @"tryon_color_gray";
        dataElement.colors.highLightImageName = @"tryon_color";
        dataElement.currentSelectedGroupType = TryOnGroupTypeColor;
        dataElement.tryOnBeautyType = [self _transformTryOnDataElement:dataElement];
        [tryOnElements addObject:dataElement];
    }
#endif
    
    return [tryOnElements copy];
}

-(TryOnGroup *)generateLipstickStyles {
    TryOnGroup *styles = [[TryOnGroup alloc] init];
    styles.name = @"质地";
    styles.imageName = @"tryon_texture_gray";
    styles.highLightImageName = @"tryon_texture";
    NSMutableArray<id<TryOnItemInterface>> *items = [NSMutableArray array];
    for (NSDictionary *lipstick in self.lipsticks) {
        TryOnItem *item = [TryOnItem yy_modelWithJSON:lipstick];
        [items addObject:item];
    }
    styles.items = items.copy;
    return styles;
}

-(NSArray *)lipsticks {
    return @[
        //        @{
        //            @"name": NSLocalizedString(@"无", nil),
        //            @"imageName": @"tryon_None",
        //            @"type": @(-1)
        //        },
        @{
            @"name": @"水润",
            @"imageName": @"tryon_shuirun",
            @"type": @(EFFECT_LIPSTICK_LUSTRE)
        },
        @{
            @"name": @"金属",
            @"imageName": @"tryon_jinshu",
            @"type": @(EFFECT_LIPSTICK_METAL)
        },
        @{
            @"name": @"闪烁",
            @"imageName": @"tryon_shanshuo",
            @"type": @(EFFECT_LIPSTICK_FROST)
        },
        @{
            @"name": @"雾面",
            @"imageName": @"tryon_wumian",
            @"type": @(EFFECT_LIPSTICK_MATTE)
        },
        @{
            @"name": @"自然",
            @"imageName": @"tryon_ziran",
            @"type": @(EFFECT_LIPSTICK_CREAMY)
        },
    ];
}

#pragma mark - privated helper
-(st_effect_beauty_type_t)_transformTryOnDataElement:(TryOnDataElement *)dataElement {
    NSString *name = dataElement.name;
    if ([name containsString:@"染发"]) {
        return EFFECT_BEAUTY_TRYON_HAIR_COLOR;
    } else if ([name containsString:@"口红"]) {
        return EFFECT_BEAUTY_TRYON_LIPSTICK;
    } else if ([name containsString:@"tryonBlush"]) {
        return EFFECT_BEAUTY_TRYON_BLUSH;
    } else if ([name containsString:@"tryonBrow"]) {
        return EFFECT_BEAUTY_TRYON_BROW;
    } else if ([name containsString:@"tryonContour"]) {
        return EFFECT_BEAUTY_TRYON_CONTOUR;
    } else if ([name containsString:@"tryonEyelash"]) {
        return EFFECT_BEAUTY_TRYON_EYELASH;
    } else if ([name containsString:@"tryonEyeliner"]) {
        return EFFECT_BEAUTY_TRYON_EYELINER;
    } else if ([name containsString:@"tryonEyeshadow"]) {
        return EFFECT_BEAUTY_TRYON_EYESHADOW;
    } else if ([name containsString:@"tryonFoundation"]) {
        return EFFECT_BEAUTY_TRYON_FOUNDATION;
    } else if ([name containsString:@"tryonLipline"]) {
        return EFFECT_BEAUTY_TRYON_LIPLINE;
    } else if ([name containsString:@"tryonStampliner"]) {
        return EFFECT_BEAUTY_TRYON_STAMPLINER;
    } 
    else {
        return 0;
    }
}

-(st_effect_beauty_type_t)_transformGroupInfo:(SenseArMaterialGroup *)groupInfo {
    NSString *groupId = groupInfo.strGroupID;
    if ([groupId containsString:@"4c7a47e9a14c4849aeb1bb57fca90b4a"]) { // 染发
        return EFFECT_BEAUTY_TRYON_HAIR_COLOR;
    } else if ([groupId containsString:@"62f5d3f985ac44c09931dc26c257a29b"]) { // 口红
        return EFFECT_BEAUTY_TRYON_LIPSTICK;
    } else if ([groupId containsString:@"20e8919978bf4448963b75e92886278a"]) { // 腮红
        return EFFECT_BEAUTY_TRYON_BLUSH;
    } else if ([groupId containsString:@"a1df70f0609c4d27ae475be1c3b4410d"]) { // 眉毛
        return EFFECT_BEAUTY_TRYON_BROW;
    } else if ([groupId containsString:@"6da2eb1713d24110a4c1cfec23cc7e68"]) { // 修容
        return EFFECT_BEAUTY_TRYON_CONTOUR;
    } else if ([groupId containsString:@"a364806843484b77a387b3c87dbfe560"]) { // 眼睫毛
        return EFFECT_BEAUTY_TRYON_EYELASH;
    } else if ([groupId containsString:@"fd556fefe3804042848588f3d1283c38"]) { // 眼线
        return EFFECT_BEAUTY_TRYON_EYELINER;
    } else if ([groupId containsString:@"f733b547a6894cb19b0bb85ad8c771f8"]) { // 眼影
        return EFFECT_BEAUTY_TRYON_EYESHADOW;
    } else if ([groupId containsString:@"2fd76cc738bc48c9a3ad1fc84049d911"]) { // 粉底
        return EFFECT_BEAUTY_TRYON_FOUNDATION;
    } else if ([groupId containsString:@"299eff2498c24a229764d996b0c4329c"]) { // 唇线
        return EFFECT_BEAUTY_TRYON_LIPLINE;
    } else if ([groupId containsString:@"87b7f985d8274735872a97a40e9927cc"]) { // 眼印
        return EFFECT_BEAUTY_TRYON_STAMPLINER;
    }
    else {
        return 0;
    }
}

@end
