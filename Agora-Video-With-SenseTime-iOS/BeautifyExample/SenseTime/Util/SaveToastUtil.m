//
//  SaveToastUtil.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SaveToastUtil.h"
#import "STParamUtil.h"

SaveToastUtil *manager = nil;

@interface SaveToastUtil ()
@property (nonatomic, strong) UILabel *lblSaveStatus;
@end

@implementation SaveToastUtil
 + (instancetype)shareInstance{
     if(!manager){
         static dispatch_once_t onceToken;
         dispatch_once(&onceToken, ^{
             manager = [SaveToastUtil new];
         });
     }
     return manager;
}

+(void)showToastInView:(UIView *)view text:(NSString *)textStr {
    
    [view addSubview:SaveToastUtil.shareInstance.lblSaveStatus];
    [SaveToastUtil.shareInstance.lblSaveStatus setText:textStr];
    [SaveToastUtil.shareInstance showAnimation];
}

- (UILabel *)lblSaveStatus {
    
    if (!_lblSaveStatus) {
        
        _lblSaveStatus = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 266) / 2, -44, 266, 44)];
        [_lblSaveStatus setFont:[UIFont systemFontOfSize:18.0]];
        [_lblSaveStatus setTextAlignment:NSTextAlignmentCenter];
        [_lblSaveStatus setTextColor:UIColorFromRGB(0xffffff)];
        [_lblSaveStatus setBackgroundColor:UIColorFromRGB(0x000000)];
        
        _lblSaveStatus.layer.cornerRadius = 22;
        _lblSaveStatus.clipsToBounds = YES;
        _lblSaveStatus.alpha = 0.6;
        
        _lblSaveStatus.text = @"图片已保存到相册";
        _lblSaveStatus.hidden = YES;
    }
    
    return _lblSaveStatus;
}

- (void)showAnimation  {
    if(!self.lblSaveStatus.hidden) {
        return;
    }
    self.lblSaveStatus.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.lblSaveStatus.center = CGPointMake(SCREEN_WIDTH / 2.0 , 102);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.05 delay:2
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             
                             self.lblSaveStatus.center = CGPointMake(SCREEN_WIDTH / 2.0 , -44);
                             
                         } completion:^(BOOL finished) {
                             
                             self.lblSaveStatus.hidden = YES;
                         }];
    }];
}

@end
