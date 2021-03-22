//
//  SenseSettingManager.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SenseSettingDelegate <NSObject>
- (void)changeResolution640x480;
- (void)changeResolution1280x720;
- (void)changeAttribute:(BOOL)bShow;
@end

@interface SenseSettingView : UIView

@property (nonatomic, weak) id<SenseSettingDelegate> senseSettingDelegate;

@end
