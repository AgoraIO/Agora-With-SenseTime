//
//  EFStripImagePickerView.h
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/11/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFStripImagePickerView;

@protocol EFStripImagePickerViewDelegate <NSObject>

-(void)stripImagePickerView:(EFStripImagePickerView *)stripImagePickerView selectedImage:(UIImage *)image;

@end

@interface EFStripImagePickerView : UIView

@property (nonatomic, weak) id<EFStripImagePickerViewDelegate> delegate;

-(void)resetImageSelectedStatus;

@end
