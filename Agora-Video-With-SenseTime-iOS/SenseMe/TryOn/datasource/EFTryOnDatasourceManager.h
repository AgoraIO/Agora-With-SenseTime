//
//  EFTryOnDatasourceManager.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/24.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TryOnDataElementInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface EFTryOnDatasourceManager : NSObject

@property (nonatomic, strong) NSArray<id<TryOnDataElementInterface>> *dataSource;

@end

NS_ASSUME_NONNULL_END
