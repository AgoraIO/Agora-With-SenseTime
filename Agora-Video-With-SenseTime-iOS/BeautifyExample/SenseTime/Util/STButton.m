//
//  STButton.m
//  SenseME_HumanAction
//
//  Created by Sunshine on 13/10/2017.
//  Copyright © 2017 SenseTime. All rights reserved.
//

#import "STButton.h"

@implementation STButton


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (([event type] != UIEventTypeTouches)) {
        return [super pointInside:point withEvent:event];
    }
    CGRect frame = CGRectMake(self.touchEdgeInsets.left,
                              self.touchEdgeInsets.top,
                              self.bounds.size.width - self.touchEdgeInsets.left - self.touchEdgeInsets.right,
                              self.bounds.size.height - self.touchEdgeInsets.top - self.touchEdgeInsets.bottom);
    return CGRectContainsPoint(frame, point);
}

- (CGRect)touchFrame {
    return CGRectMake(CGRectGetMinX(self.frame) + self.touchEdgeInsets.left,
                      CGRectGetMinY(self.frame) + self.touchEdgeInsets.top,
                      CGRectGetWidth(self.frame) - self.touchEdgeInsets.left - self.touchEdgeInsets.right,
                      CGRectGetHeight(self.frame) - self.touchEdgeInsets.top - self.touchEdgeInsets.bottom);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
