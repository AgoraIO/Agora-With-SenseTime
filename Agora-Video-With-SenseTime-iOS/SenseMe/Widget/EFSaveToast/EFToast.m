//
//  EFToast.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/29.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFToast.h"
#import "MBProgressHUD.h"


@interface EFToast ()


@end


@implementation EFToast

+ (void)show:(UIView *)view description:(nonnull NSString *)description{
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 120, 30)];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.text = description;
    contentLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [contentLabel sizeToFit];
    
    float width = contentLabel.frame.size.width;
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width + 20, 80)];
    subView.backgroundColor = [UIColor blackColor];
    subView.layer.cornerRadius = 5.0;
    subView.layer.masksToBounds = YES;
    subView.alpha = 0.6;
    [view addSubview:subView];
    subView.center = view.center;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage: [description containsString :NSLocalizedString(@"成功", nil)] ? [UIImage imageNamed:@"saved_success"] : [UIImage imageNamed:@"saved_failed"]];
    [subView addSubview:imageView];
    [subView addSubview:contentLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subView.mas_top).offset(10);
        make.centerX.equalTo(subView.mas_centerX);
    }];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(5);
        make.centerX.equalTo(subView.mas_centerX);
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subView removeFromSuperview];
    });
}

+ (void)showError:(UIView *)view
      description:(NSString *)description{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(description, nil);
    hud.center = view.center;
    [hud hideAnimated:YES afterDelay:2.0f];
    
}


+ (void)showFail:(UIView *)view
     description:(NSString *)description {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(description, nil);
    hud.center = view.center;
    [hud hideAnimated:YES afterDelay:4.0f];
}



@end
