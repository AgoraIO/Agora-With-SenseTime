//
//  STTriggerView.h
//
//  Created by HaifengMay on 16/11/10.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

/*
 * 用于显示trigger的提示语
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EFTriggerType) {
    EFTriggerTypeNod,                //点头
    EFTriggerTypeMoveEyebrow,        //挑眉
    EFTriggerTypeBlink,              //眨眼
    EFTriggerTypeOpenMouse,          //张嘴
    EFTriggerTypeTurnHead,           //转头
    EFTriggerTypeHandGood,           //大拇哥
    EFTriggerTypeHandPalm,           //手掌
    EFTriggerTypeHandLove,           //爱心
    EFTriggerTypeHandHoldUp,         //托手
    EFTriggerTypeHandCongratulate,   //恭贺(抱拳)
    EFTriggerTypeHandFingerHeart,    //单手比爱心
    EFTriggerTypeHandTwoIndexFinger, // 平行手指
    EFTriggerTypeHandFingerIndex,    //食指指尖
    EFTriggerTypeHandOK,             //OK手势
    EFTriggerTypeHandScissor,        //剪刀手
    EFTriggerTypeHandPistol,         //手枪
    EFTriggerTypeHand666,            //666
    EFTriggerTypeHandBless,          //双手合十
    EFTriggerTypeHandILoveYou,       //手势ILoveYou
    EFTriggerTypeHandFist,           //拳头手势
};

@interface EFTriggerView : UIView

- (void)showTriggerViewWithType:(EFTriggerType)type;
//- (void)showTriggerViewWithContent:(NSString *)content image:(UIImage *)image;
- (void)showTriggerViewWithContents:(NSArray <NSString *> *)contents images:(NSArray <UIImage *> *)images;

@end
