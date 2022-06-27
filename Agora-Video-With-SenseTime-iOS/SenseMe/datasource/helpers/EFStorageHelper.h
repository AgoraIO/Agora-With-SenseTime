//
//  EFStorageHelper.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/30.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFStorageHelper;

@protocol EFStorageHelperDelegate <NSObject>

-(void)efRenderAction:(EFStorageHelper *)helper withRenderModel:(EFRenderModel *)renderModel;
-(void)efRenderAction:(EFStorageHelper *)helper set3DBeauties:(NSArray <EFRenderModel *> *)renderModels isClear:(BOOL)isClear;

@end

@interface EFStorageHelper : NSObject

@property (nonatomic, readonly, strong) NSArray *efSpecialTypes;
@property (nonatomic, readonly, strong) NSArray *efSpecial3DNames;

@property (nonatomic, readwrite, weak) id<EFStorageHelperDelegate> efDelegate;

-(void)efSelectModel:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels **)currentStorage andCacheStorage:(EFStatusModels **)cacheStorage;

-(void)efSelectModel:(id<EFDataSourcing>)targetModel withStrength:(CGFloat)strength withCurrentStorage:(EFStatusModels **)currentStorage andCacheStorage:(EFStatusModels **)cacheStorage;

- (EFRenderModel *)efHasSelectedTargetModel:(id<EFDataSourcing>)targetModel byCurrentStorage:(EFStatusModels **)currentStorage;

- (CGFloat)efStrengthOfModel:(id<EFDataSourcing>)model byCurrentStorage:(EFStatusModels *)currentStorage;

-(void)efClear:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels **)currentStorage andCacheStorage:(EFStatusModels **)cacheStorage;

-(void)efReset:(id<EFDataSourcing>)targetModel withCurrentStorage:(EFStatusModels **)currentStorage cacheStorage:(EFStatusModels **)cacheStorage andDefault:(EFStatusModels *)defaultModels;

-(BOOL)efIfNeedUpdateOverLap:(NSArray *)newOverlapArray;

/// 移除current storage中所有的贴纸效果
/// @param currentStorage current storage
-(void)efRemoveAllStickerFromCurrentStorageOnly:(EFStatusModels *__autoreleasing *)currentStorage;

/// 将美颜参数从cache恢复到current
/// @param currentStorage currentStorage
/// @param cacheStorage cacheStorage
-(void)efRestoreAllMakeupParametersWithCurrentStorage:(EFStatusModels *__autoreleasing *)currentStorage andCacheStorage:(EFStatusModels *__autoreleasing *)cacheStorage;

@end
