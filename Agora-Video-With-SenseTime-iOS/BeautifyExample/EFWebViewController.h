//
//  EFWebViewController.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class EFWebViewController;

@protocol EFWebViewControllerDelegate <NSObject>

-(void)webViewControllerDismiss:(EFWebViewController *)webViewController;

@end

@interface EFWebViewController : UIViewController

@property (nonatomic, weak) id<EFWebViewControllerDelegate> delegate;

- (void)configWebViewWithTitle:(NSString *)title html:(NSURL *)path;

@end

NS_ASSUME_NONNULL_END
