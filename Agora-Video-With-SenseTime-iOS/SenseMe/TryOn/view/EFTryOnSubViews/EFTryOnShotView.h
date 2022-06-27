//
//  EFTryOnShotView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/23.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EFTryOnShotView;

@protocol EFTryOnShotViewDelegate <NSObject>

@optional
-(void)tryOnShotView:(EFTryOnShotView *)shotView onShotButtonClick:(UIButton *)shotButton;

@end

@interface EFTryOnShotView : UIView

@property (nonatomic, weak) id<EFTryOnShotViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
