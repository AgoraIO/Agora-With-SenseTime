//
//  TryOnControlViewDataSource.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/1/6.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TryOnControlView, EFTryOnDatasourceManager;

@protocol TryOnControlViewDataSource <NSObject>

@required
-(EFTryOnDatasourceManager *)dataSourceManagerOfControlView:(TryOnControlView *)controlView;

@end

NS_ASSUME_NONNULL_END
