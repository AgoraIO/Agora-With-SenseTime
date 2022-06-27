//
//  STTriggerView.m
//
//  Created by HaifengMay on 16/11/10.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "EFTriggerView.h"

@interface EFTriggerView ()
{
    dispatch_source_t _timer;
}
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UILabel *txtLabel;
@property (nonatomic , assign) double dStartTime;

@end


@implementation EFTriggerView

- (instancetype) init{
    CGRect frame = CGRectMake(0, 0, 200, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [self.imageView setBackgroundColor:[UIColor clearColor]];
//        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
//        [self addSubview:self.imageView];
        
//        self.txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame), self.frame.size.height)];
//        [self.txtLabel setBackgroundColor: [UIColor clearColor]];
//        [self.txtLabel setTextColor:[UIColor whiteColor]];
//        [self.txtLabel setFont:[UIFont systemFontOfSize:14]];
//        [self.txtLabel setTextAlignment:NSTextAlignmentLeft];
//        self.txtLabel.numberOfLines = 0;
//        self.txtLabel.minimumScaleFactor = 0.5;
//        self.txtLabel.adjustsFontSizeToFitWidth = YES;
//        [self addSubview:self.txtLabel];
        self.hidden = YES;
        self.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        
        _dStartTime = CFAbsoluteTimeGetCurrent();
        
        uint64_t interval = NSEC_PER_SEC / 1000 * 33;
        dispatch_queue_t queue = dispatch_queue_create("com.sensetime.sticker.timer", NULL);
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!weakSelf.isHidden && (CFAbsoluteTimeGetCurrent() - weakSelf.dStartTime > 3.0)) {
                    weakSelf.hidden = YES;
                }
            });
        });
        
        dispatch_resume(_timer);
    }
    return self;
}

-(UIImageView *)_generateCommonImageView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    return imageView;
}

-(UILabel *)_generateCommonLabel {
    UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [txtLabel setBackgroundColor: [UIColor clearColor]];
    [txtLabel setTextColor:[UIColor whiteColor]];
    [txtLabel setFont:[UIFont systemFontOfSize:14]];
    [txtLabel setTextAlignment:NSTextAlignmentLeft];
    txtLabel.numberOfLines = 0;
    txtLabel.minimumScaleFactor = 0.5;
    txtLabel.adjustsFontSizeToFitWidth = YES;
    return txtLabel;
}

- (void)showTriggerViewWithContents:(NSArray <NSString *> *)contents images:(NSArray <UIImage *> *)images {
    CGFloat standardValue = 40.0;
    CGFloat standardEdge = 10.0;
    dispatch_async(dispatch_get_main_queue(), ^{
 
        
        for (UIView *currentSubview in self.subviews) {
            [currentSubview removeFromSuperview];
        }
        
        self->_dStartTime = CFAbsoluteTimeGetCurrent();
        for (NSInteger i = 0; i < contents.count; i ++) {
            UIImageView *currentImageView = [self _generateCommonImageView];
            currentImageView.frame = CGRectMake(0, standardValue * i + i * standardEdge, standardValue, standardValue);
            [self addSubview:currentImageView];
            
            [currentImageView setImage:images[i]];
            
            UILabel *currentLabel = [self _generateCommonLabel];
            currentLabel.frame = CGRectMake(
                                            currentImageView.frame.origin.x + currentImageView.frame.size.width,
                                            currentImageView.frame.origin.y,
                                            CGRectGetWidth(self.frame) - CGRectGetWidth(currentImageView.frame),
                                            currentImageView.frame.size.height
                                            );
            [self addSubview:currentLabel];
            
            [currentLabel setText:contents[i]];
            
            DLog(@"%@ - %@", NSStringFromCGRect(currentImageView.frame), NSStringFromCGRect(currentLabel.frame));
        }

        self.frame = CGRectMake(0, 0, 200.0, standardValue * contents.count + standardEdge * (contents.count -1));
        self.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        
        self.hidden = NO;
    });
}

- (void)showTriggerViewWithContent:(NSString *)content image:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self->_dStartTime = CFAbsoluteTimeGetCurrent();
        
        [self.imageView setImage:image];
        
        self.txtLabel.text = content;
        
        self.hidden = NO;
    });
    
}


@end
