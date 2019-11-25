//
//  SenseTouchView.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SenseTouchViewDelegate <NSObject>
- (void)onTouchISOValueChange:(float) value;
- (void)onTouchExposurePointChange:(CGPoint) point;
@end

@interface SenseTouchView : UIView

@property (nonatomic, weak) id<SenseTouchViewDelegate> senseTouchDelegate;

@end

