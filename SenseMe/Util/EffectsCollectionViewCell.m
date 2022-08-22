//
//  EffectsCollectionViewCell.m
//  SenseMeEffects
//
//  Created by Lin Sun on 2018/12/8.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "EffectsCollectionViewCell.h"
#import "STParamUtil.h"

@implementation EffectsCollectionViewCellModel

@end

@implementation EffectsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5.0f;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.thumbView.image = nil;
    self.thumbView.hidden = YES;
    self.loadingView.hidden = YES;
    self.downloadSign.hidden = NO;
}

- (void)setModel:(EffectsCollectionViewCellModel *)model
{
    _model = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshUIWithModel:model];
    });
}

- (void)refreshUIWithModel:(EffectsCollectionViewCellModel *)model
{
    if (!model) {
        
        self.hidden = YES;
        
        return;
    }else{
        
        self.hidden = NO;
        self.thumbView.hidden = NO;
        self.downloadSign.hidden = NO;
        self.loadingView.hidden = NO;
    }
    
    if (model.imageThumb) {
     
        self.thumbView.image = model.imageThumb;
    }else{
        
        self.thumbView.hidden = YES;
    }
    
    BOOL isDirectory = YES;
    BOOL isExist = [[NSFileManager defaultManager]
                    fileExistsAtPath:model.strMaterialPath
                    isDirectory:&isDirectory];
    
    if (Downloaded == model.state && (isDirectory || !isExist)) {
        
        model.state = NotDownloaded;
    }
    
    if (model.state != IsSelected && !isDirectory && isExist) {
        
        model.state = Downloaded;
    }
    
    self.layer.borderColor =  model.state == IsSelected ? UIColorFromRGB(0xb036f5).CGColor : [UIColor clearColor].CGColor;
    self.thumbView.alpha = (model.state == NotDownloaded || model.state == IsDownloading || !isExist || isDirectory) ? 0.5 : 1.0;
    
    self.downloadSign.hidden = model.state != NotDownloaded;
    
    if (IsDownloading == model.state) {
        
        [self startDownloadAnimation];
    }else{
        
        [self stopDownloadAnimation];
    }
}


- (void)startDownloadAnimation
{
    self.loadingView.hidden = NO;
    [self.loadingView.layer removeAnimationForKey:@"rotation"];
    
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    circleAnimation.duration = 2.5f;
    circleAnimation.repeatCount = MAXFLOAT;
    circleAnimation.toValue = @(M_PI * 2);
    [self.loadingView.layer addAnimation:circleAnimation forKey:@"rotation"];
}

- (void)stopDownloadAnimation
{
    self.loadingView.hidden = YES;
    [self.loadingView.layer removeAnimationForKey:@"rotation"];
}

@end
