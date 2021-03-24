//
//  STBMPDetailColV.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBMPModel.h"

@protocol STBMPDetailColVDelegate <NSObject>

- (void)didSelectedModel:(STBMPModel *)model;

@end

@interface STBMPDetailColV : UIView<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<STBMPDetailColVDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)didSelectedBmpType:(STBMPModel *)model;

@end

