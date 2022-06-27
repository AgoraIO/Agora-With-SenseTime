//
//  EFResolutionPopView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/16.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "XTPopViewBase.h"

@class EFResolutionPopView;
NS_ASSUME_NONNULL_BEGIN

@protocol EFResolutionPopViewDelegate <NSObject>

/// 640x480 1280x720 1920x1080
- (void)EFResolutionPopView:(EFResolutionPopView *_Nullable)view didSelectType:(ResolutionType)type;

@end

@interface EFResolutionPopView : XTPopViewBase

@property (nonatomic, assign) ResolutionType resolutType;

@property (nonatomic, weak) id <EFResolutionPopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
