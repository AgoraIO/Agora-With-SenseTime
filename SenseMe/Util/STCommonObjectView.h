//
//  STCommonObjectView.h
//  SenseMeEffects
//
//  Created by Sunshine on 2017/6/1.
//  Copyright © 2017年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMMON_OBJCET_VIEW_WIDTH 128
#define COMMON_OBJECT_VIEW_HEIGHT 128
#define COMMON_OBJECT_VIEW_MARGIN 0

@protocol STCommonObjectViewDelegate<NSObject>

@optional
- (void)makeCommonObjectViewBecomeFirstRespond:(int)commonObjectViewID;
- (void)removeCommonObjectView:(int)commonObjectViewID;
- (void)commonObjectViewBeginMove:(int)commonObjectViewID;
- (void)commonObjectViewEndMove:(int)commonObjectViewID;

@end

@interface STCommonObjectView : UIView

@property (nonatomic, readwrite, strong) UIImage *image;
@property (nonatomic, readwrite, assign) int commonObjectViewID;
@property (nonatomic, readwrite, assign, getter=isOnFirst) BOOL onFirst;
@property (nonatomic, readwrite, weak) id<STCommonObjectViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
           commonObjectViewID:(int)viewID
                        image:(UIImage *)image;

- (void)removeCommonObjectView;

@end
