//
//  EFTryOnSegmentView.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2022/2/9.
//  Copyright © 2022 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EFTryOnSegmentView;

@protocol EFTryOnSegmentViewDelegate <NSObject>

-(void)tryOnSegmentView:(EFTryOnSegmentView *)tryOnSegmentView segmentIndexChanged:(NSInteger)currentIndex;

@end

@interface EFTryOnSegmentView : UIView

@property (nonatomic, weak) id<EFTryOnSegmentViewDelegate> delegate;
@property (nonatomic, assign) int itemsCount;
@property (nonatomic, assign) int currentIndex;

@end

NS_ASSUME_NONNULL_END
