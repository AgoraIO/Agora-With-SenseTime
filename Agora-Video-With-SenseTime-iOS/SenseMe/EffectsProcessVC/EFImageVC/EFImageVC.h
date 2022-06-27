//
//  EFImageVC.h
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/28.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFBaseEffectsProcess.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFImageVC : EFBaseEffectsProcess

@property (nonatomic, strong) UIImage *imageOriginal;
@property (nonatomic, assign) BOOL showPhotoStripView;

- (void)processImageAndDisplay;

@end

NS_ASSUME_NONNULL_END
