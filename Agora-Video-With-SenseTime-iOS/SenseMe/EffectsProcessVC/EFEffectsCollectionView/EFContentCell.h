//
//  EFContentCell.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/11.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EFContentCell : UICollectionViewCell

- (void)config:(EFDataSourceMaterialModel *)model status:(EFMaterialDownloadStatus)status select:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
