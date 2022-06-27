//
//  EFWebViewController.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFWebViewController.h"
#import <WebKit/WebKit.h>

@interface EFWebViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation EFWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage *image = [UIImage imageNamed:@"back_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(_efBackAction:)];
}


- (void)configWebViewWithTitle:(NSString *)title html:(NSURL *)path{
    self.title = title;
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
}

-(void)_efBackAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(webViewControllerDismiss:)]) {
        [self.delegate webViewControllerDismiss:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
