//
//  EFMakeupFilterBeautyCell.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFMakeupFilterBeautyCell : UICollectionViewCell

- (void)config:(EFDataSourceModel *)model
          type:(EffectsItemType)itemType
        select:(BOOL)isSelect
        status:(EFMaterialDownloadStatus)status
         value:(int)value;

@end

NS_ASSUME_NONNULL_END
