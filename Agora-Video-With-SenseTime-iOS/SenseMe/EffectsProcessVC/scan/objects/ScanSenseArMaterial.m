//
//  ScanSenseArMaterial.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "ScanSenseArMaterial.h"

@implementation ScanSenseArMaterial
{
    NSString *_strMaterialURL;
    NSString *_strID;
    NSString *_strMaterialFileID;
}

-(void)setStrMaterialURL:(NSString *)strMaterialURL {
    _strMaterialURL = strMaterialURL;
}

-(NSString *)strMaterialURL {
    return _strMaterialURL;
}

-(void)setStrID:(NSString *)strID {
    _strID = strID;
}

-(NSString *)strID {
    return _strID;
}

-(void)setStrMaterialFileID:(NSString *)strMaterialFileID {
    _strMaterialFileID = strMaterialFileID;
}

-(NSString *)strMaterialFileID {
    return _strMaterialFileID;
}

@end
