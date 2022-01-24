//
//  STBMPCollectionViewCell.h
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STBMPCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *m_icon;
@property (nonatomic, strong) UILabel *m_labelName;

- (void)setName:(NSString *)name;

- (void)setIcon:(NSString *)icon;

@end
