//
//  SenseEffectsView.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/20.
//  Copyright © 2019 agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SenseEffectsManager.h"
#import "STTriggerView.h"
#import "STCommonObjectContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SenseEffectsViewDelegate <NSObject>
- (void)onDevicePositionChange:(AVCaptureDevicePosition)devicePosition;
@end

@interface SenseEffectsView : UIView

@property (nonatomic, weak) id<SenseEffectsViewDelegate> senseEffectsDelegate;
@property (nonatomic, strong) STTriggerView *triggerView;
@property (nonatomic, strong) STCommonObjectContainerView *commonObjectContainerView;

- (void)initSenseEffectsManager:(SenseEffectsManager *)manager;
- (void)resetCommonObjectViewPosition;

@end

NS_ASSUME_NONNULL_END
