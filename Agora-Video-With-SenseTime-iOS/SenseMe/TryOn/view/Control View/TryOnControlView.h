//
//  TryOnControlView.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnDatasourceManager;

@interface TryOnControlView : UIView

-(instancetype)initWithFrame:(CGRect)frame andDataSourceManager:(EFTryOnDatasourceManager *)dataSourceManager;

@end

NS_ASSUME_NONNULL_END
