//
//  EFTryOnTitleView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFTryOnTitleView;
@protocol TryOnDataElementInterface;

NS_ASSUME_NONNULL_BEGIN

@protocol EFTryOnTitleViewDelegate <NSObject>

-(void)tryOnTitleView:(EFTryOnTitleView *)tryOnTitleView titleChanged:(NSIndexPath *)indexPath withModel:(id<TryOnDataElementInterface>)model;

@end

@interface EFTryOnTitleView : UIView

@property (nonatomic, weak) id<EFTryOnTitleViewDelegate> delegate;

-(instancetype)initWithDatasource:(NSArray<id<TryOnDataElementInterface>> *)dataSource;

@end

NS_ASSUME_NONNULL_END
