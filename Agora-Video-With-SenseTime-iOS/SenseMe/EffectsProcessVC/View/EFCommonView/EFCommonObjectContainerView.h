//
//  STCommonObjectContainerView.h
//  SenseMeEffects
//
//  Created by Sunshine on 2017/6/1.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCommonObjectView.h"

#define POINT_KEY @"POINT_KEY"
#define POINTS_KEY @"POINTS_KEY"
#define RECT_KEY @"RECT_KEY"

@class STCommonObjectView;

@protocol EFCommonObjectContainerViewDelegate <NSObject>

@optional
- (void)commonObjectViewFinishTrackingFrame:(CGRect)frame;
- (void)commonObjectViewStartTrackingFrame:(CGRect)frame;

@end

@interface EFCommonObjectContainerView : UIView

@property (nonatomic, readwrite, strong) EFCommonObjectView *currentCommonObjectView;
@property (nonatomic, readwrite, weak) id<EFCommonObjectContainerViewDelegate> delegate;
@property (nonatomic, strong) NSArray *arrPersons;
@property (nonatomic, assign) BOOL needClear;

@property (nonatomic, strong) NSMutableArray *faceArray;

- (void)addCommonObjectViewWithImage:(UIImage *)image;

@end
