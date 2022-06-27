//
//  EFVideoRecorderView.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCircleProgressBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EFVideoRecorderViewDelegate <NSObject>

- (void)record:(BOOL)bStart;

- (void)cancelBlock:(void(^)(BOOL))block;

- (void)saveVideoWithBlock:(void(^)(void))block;

@end

@interface EFVideoRecorderView : UIView

@property (nonatomic, weak) id<EFVideoRecorderViewDelegate> delegate;

//设置暗黑图标
@property (nonatomic, assign) BOOL isDark;
 
- (void)startRecroding;

- (void)pauseRecroding;

@end

NS_ASSUME_NONNULL_END
