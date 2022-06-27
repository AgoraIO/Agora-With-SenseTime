//
//  EFStyleContentCell.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFStyleContentCell : UICollectionViewCell

//- (void)config:(EFDataSourceModel *)model select:(BOOL)select;
- (void)config:(EFDataSourceModel *)model status:(EFMaterialDownloadStatus)status select:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
