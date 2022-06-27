//
//  EFNavigationView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EFNavigationView;

@protocol EFNavigationViewDelegate <NSObject>

- (void)EFNavigationView:(EFNavigationView *_Nonnull)view didSelect:(NSInteger)index sender:(id _Nonnull )sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EFNavigationView : UIView

@property (nonatomic, weak) id <EFNavigationViewDelegate> delegate;

@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIButton *scaleButton;

@property (nonatomic, strong) UIButton *playButton;

- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type;
- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type andIsTryOn:(BOOL)isTryOn;

//录制视频调用 更新View显示
- (void)hideSubview:(BOOL)hide;

@end

NS_ASSUME_NONNULL_END
