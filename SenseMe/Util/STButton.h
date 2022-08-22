//
//  STButton.h
//  SenseME_HumanAction
//
//  Created by Sunshine on 13/10/2017.
//  Copyright © 2017 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STButton : UIButton

@property (nonatomic, assign) UIEdgeInsets touchEdgeInsets; //扩展后的点击区域
@property (nonatomic, readonly, assign) CGRect touchFrame;  //扩展后的包括点击区域的frame

@end
