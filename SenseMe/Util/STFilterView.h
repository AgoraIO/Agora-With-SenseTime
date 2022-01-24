//
//  STFilterView.h
//  SenseMeEffects
//
//  Created by Sunshine on 31/10/2017.
//  Copyright © 2017 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STViewButton.h"
#import "STCollectionView.h"

typedef void (^TapBlock)(void);

@interface STFilterView : UIView

@property (nonatomic, strong) STViewButton *leftView;
@property (nonatomic, strong) STFilterCollectionView *filterCollectionView;
@property (nonatomic, copy) TapBlock block;

@end
