//
//  EffectsCollectionView.m
//  SenseMeEffects
//
//  Created by Lin Sun on 2018/12/8.
//  Copyright © 2018 SenseTime. All rights reserved.
//

#import "EffectsCollectionView.h"

@implementation EffectsCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        self.alwaysBounceVertical = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

@end
