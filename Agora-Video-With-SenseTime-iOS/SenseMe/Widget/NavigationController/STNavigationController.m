//
//  STNavigationController.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/7.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "STNavigationController.h"

@interface STNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *currentShowViewController;

@end

@implementation STNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}

+ (void)initialize {

    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    [bar setTintColor:[UIColor clearColor]];

    UIImage *image = [UIImage imageNamed:@"back_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    bar.backIndicatorImage = image;
    bar.backIndicatorTransitionMaskImage = image;
}


- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    STNavigationController *nav = [super initWithRootViewController:rootViewController];
    UIImage *image = [UIImage imageNamed:@"back_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.navigationBar.backIndicatorImage = image;
    nav.navigationBar.backIndicatorTransitionMaskImage = image;
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}


#pragma mark - UIGestureRecognizerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if (navigationController.viewControllers.count == 1) {
        self.currentShowViewController = nil;
    }else{
        self.currentShowViewController = viewController;
    }
}

//返回YES 允许侧滑手势的激活, 返回NO不允许侧滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.currentShowViewController == self.topViewController) {
            return NO;
        }
    }
    return NO;
}

//获取侧滑返回手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

@end
