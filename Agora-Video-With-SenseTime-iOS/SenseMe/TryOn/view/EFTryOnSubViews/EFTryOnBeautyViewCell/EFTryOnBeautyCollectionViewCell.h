//
//  EFTryOnBeautyCollectionViewCell.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TryOnDataElementInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFTryOnBeautyCollectionViewCell : UICollectionViewCell

- (void)config:(id<TryOnItemInterface>)model status:(EFMaterialDownloadStatus)status select:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
