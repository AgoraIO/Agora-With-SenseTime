//
//  ViewController.h
//
//  Created by HaifengMay on 16/11/7.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>

@interface ViewController : UIViewController

@property (copy, nonatomic) NSString *channelName;
@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;    //Agora Engine

@end
