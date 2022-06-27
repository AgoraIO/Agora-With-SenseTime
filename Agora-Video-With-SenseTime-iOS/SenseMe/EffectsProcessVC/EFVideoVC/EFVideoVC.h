//
//  EFVideoVC.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/28.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFBaseEffectsProcess.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFVideoVC : EFBaseEffectsProcess
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) BOOL showPhotoStripView;

- (void)processFirstFrame;

@end

NS_ASSUME_NONNULL_END
