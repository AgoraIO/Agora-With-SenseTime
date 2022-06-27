//
//  EFStatusManagerDelegate.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFStatusManager, EFRenderModel;

@protocol EFStatusManagerDelegate <NSObject>

@optional
-(void)efStatusManager:(EFStatusManager *)statusManager statusChanged:(EFRenderModel *)renderModel;
-(void)efStatusManager:(EFStatusManager *)statusManager set3DBeauties:(NSArray <EFRenderModel *> *)renderModels isClear:(BOOL)isClear;

-(NSArray <NSDictionary *>*)efStatusManagerGetOverlapValues:(EFStatusManager *)statusManager;

@end
