//
//  STTriggerView.m
//
//  Created by HaifengMay on 16/11/10.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STTriggerView.h"
#import "STParamUtil.h"

@interface STTriggerView ()
{
    dispatch_source_t _timer;
}
@property (nonatomic , strong) UIImageView *imageView;
@property (nonatomic , strong) UILabel *txtLabel;
@property (nonatomic , assign) double dStartTime;

@end


@implementation STTriggerView

- (instancetype) init{
    CGRect frame = CGRectMake(0, 0, 200, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.imageView setBackgroundColor:[UIColor clearColor]];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:self.imageView];
        
        self.txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.imageView.frame), self.frame.size.height)];
        [self.txtLabel setBackgroundColor: [UIColor clearColor]];
        [self.txtLabel setTextColor:[UIColor whiteColor]];
        [self.txtLabel setFont:[UIFont systemFontOfSize:14]];
        [self.txtLabel setTextAlignment:NSTextAlignmentLeft];
        self.txtLabel.numberOfLines = 0;
        self.txtLabel.minimumScaleFactor = 0.5;
        self.txtLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.txtLabel];
        self.hidden = YES;
        self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        
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

- (void)showTriggerViewWithContent:(NSString *)content image:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.dStartTime = CFAbsoluteTimeGetCurrent();
        
        [self.imageView setImage:image];
        
        self.txtLabel.text = content;
        
        self.hidden = NO;
    });
    
}

- (void)showTriggerViewWithType:(STTriggerType) type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.dStartTime = CFAbsoluteTimeGetCurrent();
        
        switch (type) {
                
            case STTriggerTypeNod:
                [self.imageView setImage:[UIImage imageNamed:@"head_pitch"]];
                self.txtLabel.text = @"请点点头～";
                break;
            case STTriggerTypeBlink:
                [self.imageView setImage:[UIImage imageNamed:@"eye_blink"]];
                self.txtLabel.text = @"请眨眨眼～";
                break;
            case STTriggerTypeTurnHead:
                [self.imageView setImage:[UIImage imageNamed:@"head_yaw"]];
                self.txtLabel.text = @"请摇摇头～";
                break;
            case STTriggerTypeOpenMouse:
                [self.imageView setImage:[UIImage imageNamed:@"mouth_ah"]];
                self.txtLabel.text = @"请张张嘴～";
                break;
            case STTriggerTypeMoveEyebrow:
                [self.imageView setImage:[UIImage imageNamed:@"head_brow_jump"]];
                self.txtLabel.text = @"请挑挑眉～";
                break;
            case STTriggerTypeHandGood:
                [self.imageView setImage:[UIImage imageNamed:@"hand_good"]];
                self.txtLabel.text = @"请比个赞～";
                break;
                
            case STTriggerTypeHandPalm:
                [self.imageView setImage:[UIImage imageNamed:@"hand_palm"]];
                self.txtLabel.text = @"请伸手掌～";
                break;
                
            case STTriggerTypeHandLove:
                [self.imageView setImage:[UIImage imageNamed:@"hand_love"]];
                self.txtLabel.text = @"请双手比心～";
                break;
                
            case STTriggerTypeHandHoldUp:
                [self.imageView setImage:[UIImage imageNamed:@"hand_holdup"]];
                self.txtLabel.text = @"请托个手～";
                break;
                
            case STTriggerTypeHandCongratulate:
                [self.imageView setImage:[UIImage imageNamed:@"hand_congratulate"]];
                self.txtLabel.text = @"请抱个拳～";
                break;
                
            case STTriggerTypeHandFingerHeart:
                [self.imageView setImage:[UIImage imageNamed:@"hand_finger_heart"]];
                self.txtLabel.text = @"请单手比心～";
                break;
            case STTriggerTypeHandTwoIndexFinger:
                [self.imageView setImage:[UIImage imageNamed:@"two_index_finger"]];
                self.txtLabel.text = @"请如图所示伸出手指～";
                break;
                
            case STTriggerTypeHandPistol:
                [self.imageView setImage:[UIImage imageNamed:@"hand_gun"]];
                self.txtLabel.text = @"请比个手枪～";
                break;
                
            case STTriggerTypeHandScissor:
                [self.imageView setImage:[UIImage imageNamed:@"hand_victory"]];
                self.txtLabel.text = @"请比个剪刀手～";
                break;
                
            case STTriggerTypeHandOK:
                [self.imageView setImage:[UIImage imageNamed:@"hand_ok"]];
                self.txtLabel.text = @"请亮出OK手势～";
                break;
                
            case STTriggerTypeHandFingerIndex:
                [self.imageView setImage:[UIImage imageNamed:@"hand_finger"]];
                self.txtLabel.text = @"请伸出食指～";
                break;
                
            case STTriggerTypeHand666:
                self.imageView.image = [UIImage imageNamed:@""];
                self.txtLabel.text = @"请亮出666手势～";
                break;
                
            case STTriggerTypeHandBless:
                self.imageView.image = [UIImage imageNamed:@""];
                self.txtLabel.text = @"请双手合十～";
                
                break;
                
                
            case STTriggerTypeHandILoveYou:
                self.imageView.image = [UIImage imageNamed:@""];
                self.txtLabel.text = @"请亮出我爱你手势～";
                
                break;
                
            case STTriggerTypeHandFist:
                self.imageView.image = [UIImage imageNamed:@""];
                self.txtLabel.text = @"请举起拳头～";
                break;
                
            default:
                break;
        }
        
        self.hidden = NO;
    });
    
}

@end
