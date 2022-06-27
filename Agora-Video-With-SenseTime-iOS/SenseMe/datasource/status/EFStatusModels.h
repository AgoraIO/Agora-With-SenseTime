//
//  EFStatusModels.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface EFStatusModels : NSObject <YYModel, NSCoding, NSSecureCoding, NSCopying>

@property (nonatomic, readwrite, strong) NSMutableArray <EFRenderModel *> * efCachedStatusModels;

@end

typedef enum : NSUInteger {
    /// 标识反选
    EFRenderModelActionDeselect = 0,
    /// 标识选中
    EFRenderModelActionSelect = 1,
    /// 标识强度变化
    EFRenderModelActionStrengthChanged = 2,
    /// 目前风格专用 标识效果存在但是不会高亮（选中了风格然后调整了滤镜或者美妆后会产生这种状态）
    EFRenderModelActionUnactive = 3,
    /// 目前美颜专用 标识选中高亮但是没有渲染效果（第一次选中某个美颜但是没有调节其参数时会产生这种状态）
    EFRenderModelActionHighlightOnly = 4,
    /// 目前美颜专用 标识仅有强度以及效果但是不会高亮（非调节状态的美颜效果和从cache中恢复的状态都会处于这种状态）
    EFRenderModelActionEffectsOnly = 5,
} EFRenderModelAction;

@interface EFRenderModel : NSObject <YYModel, NSCoding, NSSecureCoding, NSCopying>

@property (nonatomic, readwrite, copy) NSString * efStickerId;

@property (nonatomic, readwrite, copy) NSString * efName;

@property (nonatomic, readwrite, assign) NSUInteger efType;
@property (nonatomic, readwrite, copy) NSString * efPath;
@property (nonatomic, readwrite, assign) CGFloat efStrength;
@property (nonatomic, readwrite, assign) NSUInteger efRoute;
@property (nonatomic, readwrite, assign) NSUInteger efMode;

@property (nonatomic, readwrite, assign) EFRenderModelAction efAction;
@property (nonatomic, readwrite, assign) NSInteger efId;

/// 表示是否可以叠加（本地多贴纸）
@property (nonatomic, readwrite, assign) BOOL efIsMulti;

@end
