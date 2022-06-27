//
//  EFScanViewController.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/12/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFScanViewControllerScanResultObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef EFScanViewControllerScanResultObject EFScanResultObject;
typedef void (^EFScanViewControllerCallbackBlock) (EFScanResultObject * result);

@interface EFScanViewController : UIViewController

@property (nonatomic, copy) EFScanViewControllerCallbackBlock scanCallback;

@end

NS_ASSUME_NONNULL_END
