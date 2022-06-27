//
//  EFEffectsView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/10.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFDataSourceGenerator.h"

@class EFEffectsView;

NS_ASSUME_NONNULL_BEGIN

@protocol EFEffectsViewDelegate <NSObject>

///0放大 1对比
- (void)efEffectsView:(EFEffectsView *)view amplificationContrastAction:(NSInteger)index sender:(id)sender;

///特效 美妆 滤镜 美颜 Action
- (void)efEffectsView:(EFEffectsView *)view effectsAction:(EFDataSourceModel *)model index:(int)index;

///视频 拍摄 风格 Action
- (void)efEffectsView:(EFEffectsView *)view videoCamearStyleAction:(EffectsActionType)type;

@end

@interface EFEffectsView : UIView

@property (nonatomic, weak) id <EFEffectsViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type;

//录制视频调用 更新View显示
- (void)hideSubview:(BOOL)hide;

//设置偏移 100拍摄 101 视频 102风格
- (void)contentOffset:(int)index;

//适配不同分辨率UI
- (void)effectsWithDark:(BOOL)dark;

@end

NS_ASSUME_NONNULL_END
