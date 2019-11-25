//
//  SenseAttributeView.h
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "st_mobile_face_attribute.h"

@interface SenseAttributeView : UIView

- (void)clearAttributeDescription;
- (void)setAttributeDescription:(st_mobile_attributes_t) attributeDisplay;
- (void)setBodyActionDescription;
- (void)showDescription:(double)dStart;

@end

