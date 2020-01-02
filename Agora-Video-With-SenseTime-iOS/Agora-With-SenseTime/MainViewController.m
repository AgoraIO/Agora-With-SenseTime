//
//  MainViewController.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/11.
//  Copyright © 2019 agora. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "KeyCenter.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *channelNameTF;

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onClickJoin:nil];
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:[KeyCenter agoraAppId] delegate: nil];
}

- (IBAction)onClickJoin:(id)sender {
    if(self.channelNameTF.text == nil || self.channelNameTF.text.length == 0){
        return;
    }
    
    ViewController *vc = [ViewController new];
    vc.channelName = self.channelNameTF.text;
    vc.agoraKit =  self.agoraKit;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc  animated:YES completion:nil];
}


@end

