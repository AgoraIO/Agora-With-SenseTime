//
//  STBeautyMakeUpCollectionView.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBMPDetailColV.h"

@protocol STBMPCollectionViewDelegate <NSObject>

- (void)didSelectedDetailModel:(STBMPModel *)model;

- (void)backToMainView;

@end

@interface STBMPCollectionView : UIView

@property (nonatomic, weak) id<STBMPCollectionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)backToMenu;

@end
