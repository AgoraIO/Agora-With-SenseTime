//
//  EFTryOnBeautyView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TryOnDataElementInterface.h"

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnBeautyView;

@protocol EFTryOnBeautyViewDelegate <NSObject>

@optional
-(void)tryOnBeautyView:(EFTryOnBeautyView *)tryOnBeautyView selectModel:(id<TryOnBeautyItemInterface>)model withIndex:(NSInteger)index;
-(void)tryOnBeautyView:(EFTryOnBeautyView *)tryOnBeautyView deselectModel:(id<TryOnBeautyItemInterface>)model withIndex:(NSInteger)index;

@end

@interface EFTryOnBeautyView : UIView

@property (nonatomic, weak) id<EFTryOnBeautyViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentTryonBeauty; // 手动设置tryon美颜素材

-(instancetype)initWithDatasource:(id<TryOnDataElementInterface>)dataSource;

@end

NS_ASSUME_NONNULL_END
