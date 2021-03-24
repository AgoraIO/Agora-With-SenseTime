//
//  EffectsCollectionViewCell.h
//  SenseMeEffects
//
//  Created by Lin Sun on 2018/12/8.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STParamUtil.h"

typedef enum : NSUInteger {
    NotDownloaded = 0,
    IsDownloading,
    Downloaded,
    IsSelected
} ModelState;

@interface EffectsCollectionViewCellModel : NSObject

@property (nonatomic , assign) ModelState state;
@property (nonatomic , assign) int indexOfItem;
@property (nonatomic , assign) STEffectsType iEffetsType;
@property (nonatomic , strong) UIImage *imageThumb;

@property (nonatomic , copy) NSString *strMaterialPath;

@end

@interface EffectsCollectionViewCell : UICollectionViewCell

@property (nonatomic , strong) EffectsCollectionViewCellModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadSign;


@end


