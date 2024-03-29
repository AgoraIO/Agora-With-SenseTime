//
//  MainViewController.m
//  BeautifyExample
//
//  Created by support on 2020/9/16.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "EffectsProcess.h"
#import "SenseArSourceService.h"
#import "KeyCenter.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *channelNameTF;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSenseArService];
}

/// 输入房间号开始跳转

- (IBAction)joinBtnClick:(UIButton *)sender {
    
    if (self.channelNameTF.text.length <= 0) {
        
        NSLog(@"请先输入房间号");
        return;
    }
    
}

- (void)setupSenseArService {
    SenseArMaterialService * service = [SenseArMaterialService sharedInstance];
    [[SenseArMaterialService sharedInstance] setMaxCacheSize:800000000];
    if ([SenseArMaterialService isAuthorized]) {
        return;
    }
    [service authorizeWithAppID: KeyCenter.STAppId appKey: KeyCenter.STAppKey onSuccess:^{
        BOOL isSuccess = [self checkLicenseFromServer];
        NSLog(@"isSuccess == %d", isSuccess);
    } onFailure:^(SenseArAuthorizeError iErrorCode, NSString *errMessage) {
        NSLog(@"iErrorCode == %lu errorMEssage == %@", (unsigned long)iErrorCode, errMessage);
    }];
}

//使用服务器拉取的license进行本地鉴权
- (BOOL)checkLicenseFromServer {
    NSData *licenseData = [[SenseArMaterialService sharedInstance] getLicenseData];
    return [EffectsProcess authorizeWithLicenseData:licenseData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueid = segue.identifier;
    
    if ([segueid isEqualToString: @"showRoom"]) {
        if (self.channelNameTF.text == nil) {
            return;
        }
        ViewController *roomVC = segue.destinationViewController;
        roomVC.channelName = self.channelNameTF.text;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.channelNameTF resignFirstResponder];
    
}



@end
