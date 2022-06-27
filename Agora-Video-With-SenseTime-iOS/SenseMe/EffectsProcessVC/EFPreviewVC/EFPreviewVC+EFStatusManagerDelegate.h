//
//  EFPreviewVC+EFStatusManagerDelegate.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/6/28.
//  Copyright © 2021 SenseTime. All rights reserved.
//

/// 用以粘合状态层与渲染层

#import "EFPreviewVC.h"

/// 负责接收状态层变化并进行解析，之后调用渲染层api分门别类进行渲染
@interface EFPreviewVC (EFStatusManagerDelegate)

@end
