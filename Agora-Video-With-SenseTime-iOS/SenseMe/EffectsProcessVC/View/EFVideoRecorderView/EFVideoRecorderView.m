//
//  EFVideoRecorderView.m
//  SenseMeEffects
//
//  Created by sunjian on 2021/6/25.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFVideoRecorderView.h"
#import "EFToast.h"

static int FontSize = 10;

typedef NS_ENUM(NSUInteger, EFRecordState) {
    EFRecordStateBegin,
    EFRecordStateFinish,
    EFRecordStateCancel,
    EFRecordStateConfirm,
    EFRecordStateRevoke,
    EFRecordStateDownload,
    EFRecordStateMin
};

@interface EFVideoRecorderView ()
{
    UIColor *fontColor;
    BOOL _recording;
}
@property (nonatomic, strong) NSTimer *recorderTimer;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float minSeconds;
@property (nonatomic, assign) int hours;
@property (nonatomic, assign) int minutes;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) EFRecordState curState;

//UI
@property (nonatomic, strong) UILabel *recordTimeLabel;
@property (nonatomic, strong) STCircleProgressBar *m_circleProgressBar;
@property (nonatomic, strong) UIButton *btnRecorder;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UILabel *labelCancel;
@property (nonatomic, strong) UIButton *btnConfirm;
@property (nonatomic, strong) UILabel *labelConfirm;
@property (nonatomic, strong) UIButton *btnRevoke;
@property (nonatomic, strong) UILabel *labelRevoke;
@property (nonatomic, strong) UIButton *btnDownload;
@end

@implementation EFVideoRecorderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUI];
    return self;
}

#pragma mark - private
- (void)setUI{
    fontColor = [UIColor whiteColor];
    [self addSubview:self.m_circleProgressBar];
    [self addSubview:self.btnRecorder];
    [self addSubview:self.btnCancel];
    [self addSubview:self.labelCancel];
    [self addSubview:self.btnConfirm];
    [self addSubview:self.labelConfirm];
    [self addSubview:self.btnRevoke];
    [self addSubview:self.labelRevoke];
    [self addSubview:self.btnDownload];
    [self addSubview:self.recordTimeLabel];
    
    [self.m_circleProgressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(94);
        make.height.mas_equalTo(94);
        make.bottom.equalTo(self.mas_bottom).offset(-80);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.btnRecorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.centerX.centerY.equalTo(self.m_circleProgressBar);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(self.m_circleProgressBar.mas_centerY);
        make.left.equalTo(self).offset(60);
    }];
    
    [self.labelCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.btnCancel.mas_bottom).offset(10);
        make.centerX.equalTo(self.btnCancel);
    }];
    
    [self.btnConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(self.m_circleProgressBar.mas_centerY);
        make.right.equalTo(self).offset(-60);
    }];
    
    [self.labelConfirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.btnConfirm.mas_bottom).offset(10);
        make.centerX.equalTo(self.btnConfirm);
    }];

    [self.btnDownload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(48);
        make.bottom.equalTo(self).offset(-80);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.btnRevoke mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(self.btnDownload);
        make.left.equalTo(self).offset(50);
    }];
    
    [self.labelRevoke mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.btnRevoke.mas_bottom).offset(5);
        make.centerX.equalTo(self.btnRevoke);
    }];
    
    [self.recordTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(35);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-40);
    }];
}



- (void)setIsDark:(BOOL)isDark {
    
    self.m_circleProgressBar.progressBarTrackColor = isDark ? RGBA(219, 219, 219, 1) : [UIColor whiteColor];
    self.labelCancel.textColor = isDark ? RGBA(95, 95, 95, 1) : fontColor;
    self.labelConfirm.textColor = isDark ? RGBA(95, 95, 95, 1) : fontColor;
    self.labelRevoke.textColor = isDark ? RGBA(95, 95, 95, 1) : fontColor;
    
    [self.btnCancel setImage:[UIImage imageNamed: isDark ? @"delete_icon_dark" : @"delete_icon"] forState:UIControlStateNormal];
    
    [self.btnConfirm setImage:[UIImage imageNamed: isDark ? @"confirm_icon_dark" : @"confirm_icon"] forState:UIControlStateNormal];
    
    //取消
    [self.btnRevoke setImage:[UIImage imageNamed: isDark ? @"revoke_icon_dark" : @"revoke_icon"] forState:UIControlStateNormal];
    
    //下载
    [self.btnDownload setImage:[UIImage imageNamed:isDark ? @"download_icon_dark" : @"download_icon"] forState:UIControlStateNormal];
}


#pragma mark - getter

- (STCircleProgressBar *)m_circleProgressBar{
    if(!_m_circleProgressBar){
        _m_circleProgressBar = [[STCircleProgressBar alloc] init];
        self.m_circleProgressBar.progressBarWidth = 3;
        self.m_circleProgressBar.backgroundColor = [UIColor clearColor];
        UIColor *color = [UIColor colorWithRed:212.0/255.0 green:146.0/255.0 blue:1.0 alpha:1.0];
        self.m_circleProgressBar.progressBarProgressColor = color;
        self.m_circleProgressBar.progressBarTrackColor = [UIColor whiteColor];
        self.m_circleProgressBar.startAngle = -90.0;
        self.m_circleProgressBar.hintHidden = YES;
        [self.m_circleProgressBar setProgress:0.0 animated:YES];
    }
    return _m_circleProgressBar;
}

- (UIButton *)btnRecorder{
    if (!_btnRecorder) {
        _btnRecorder = [[UIButton alloc]init];
        [_btnRecorder setImage:[UIImage imageNamed:@"after recording_icon"] forState:UIControlStateNormal];
        [_btnRecorder addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRecorder;
}

- (UIButton *)btnCancel{
    if (!_btnCancel) {
        _btnCancel = [[UIButton alloc]init];
        [_btnCancel setImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnCancel.tag = 1000;
        _btnCancel.hidden = YES;
    }
    return _btnCancel;
}

- (UILabel *)labelCancel{
    if (!_labelCancel) {
        _labelCancel = [[UILabel alloc]init];
        _labelCancel.font = [UIFont systemFontOfSize:FontSize];
        _labelCancel.textColor = fontColor;
        _labelCancel.textAlignment = NSTextAlignmentCenter;
        _labelCancel.text = NSLocalizedString(@"回删", nil) ;
        _labelCancel.hidden = YES;
    }
    return _labelCancel;
}

- (UIButton *)btnConfirm{
    if (!_btnConfirm) {
        _btnConfirm = [[UIButton alloc]init];
        [_btnConfirm setImage:[UIImage imageNamed:@"confirm_icon"] forState:UIControlStateNormal];
        [_btnConfirm addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnConfirm.tag = 1001;
        _btnConfirm.hidden = YES;
    }
    return _btnConfirm;
}

- (UILabel *)labelConfirm{
    if (!_labelConfirm) {
        _labelConfirm = [[UILabel alloc]init];
        _labelConfirm.font = [UIFont systemFontOfSize:FontSize];
        _labelConfirm.textColor = fontColor;
        _labelConfirm.textAlignment = NSTextAlignmentCenter;
        _labelConfirm.text = NSLocalizedString(@"确认", nil);
        _labelConfirm.hidden = YES;
    }
    return _labelConfirm;
}

- (UIButton *)btnRevoke{
    if (!_btnRevoke) {
        _btnRevoke = [[UIButton alloc]init];
        [_btnRevoke setImage:[UIImage imageNamed:@"revoke_icon"] forState:UIControlStateNormal];
        [_btnRevoke addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnRevoke.tag = 1002;
        _btnRevoke.hidden = YES;
    }
    return _btnRevoke;
}

- (UILabel *)labelRevoke{
    if (!_labelRevoke) {
        _labelRevoke = [[UILabel alloc]init];
        _labelRevoke.font = [UIFont systemFontOfSize:FontSize];
        _labelRevoke.textColor = fontColor;
        _labelRevoke.textAlignment = NSTextAlignmentCenter;
        _labelRevoke.text = NSLocalizedString(@"取消", nil);
        _labelRevoke.hidden = YES;
    }
    return _labelRevoke;
}

- (UIButton *)btnDownload{
    if (!_btnDownload) {
        _btnDownload = [[UIButton alloc]init];
        [_btnDownload setImage:[UIImage imageNamed:@"download_icon"] forState:UIControlStateNormal];
        [_btnDownload addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _btnDownload.tag = 1003;
        _btnDownload.hidden = YES;
    }
    return _btnDownload;
}

- (NSTimer *)recorderTimer{
    if (!_recorderTimer) {
        _recorderTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(recorderTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_recorderTimer
                                     forMode:NSRunLoopCommonModes];
    }
    return _recorderTimer;
}

- (UILabel *)recordTimeLabel {
    if (!_recordTimeLabel) {
        _recordTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _recordTimeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _recordTimeLabel.layer.cornerRadius = 5;
        _recordTimeLabel.clipsToBounds = YES;
        _recordTimeLabel.font = [UIFont systemFontOfSize:11];
        _recordTimeLabel.textAlignment = NSTextAlignmentCenter;
        _recordTimeLabel.textColor = [UIColor whiteColor];
        _recordTimeLabel.text = @"• 00:00:00";
        _recordTimeLabel.hidden = YES;
    }
    
    return _recordTimeLabel;
}

#pragma mark - public
- (void)startRecroding{
    [self record];
}

- (void)pauseRecroding {
    if (_curState == EFRecordStateBegin) {
        [self record];
    }
}

#pragma mark - Action
- (void)record{
    _recording = !_recording;
    [self recording:_recording];
}

- (void)recording:(BOOL)recording{
    if (recording) {
        [self updateState:EFRecordStateBegin];
    }else{
        if (_duration < 2.0) {
            [self updateState:EFRecordStateMin];
        }else{
            [self updateState:EFRecordStateFinish];
        }
    }
    if (self.delegate) {
        [self.delegate record:recording];
    }
}

- (void)updateState:(EFRecordState)state{
    _curState = state;
    switch (state) {
        case EFRecordStateBegin:
            _btnRecorder.hidden = NO;
            [_btnRecorder setImage:[UIImage imageNamed:@"recording_icon"] forState:UIControlStateNormal];
            [self.recorderTimer fire];
            _m_circleProgressBar.hidden = NO;
            [_m_circleProgressBar setProgress:0.0 animated:NO];
            _hours = _minutes = _seconds = 0;
            _minSeconds = _duration = 0.0;
            _recordTimeLabel.hidden = NO;
            _btnCancel.hidden = YES;
            _labelCancel.hidden = YES;
            _btnConfirm.hidden = YES;
            _labelConfirm.hidden = YES;
            break;
        case EFRecordStateFinish:
            [_btnRecorder setImage:[UIImage imageNamed:@"after recording_icon"] forState:UIControlStateNormal];
            [self.recorderTimer invalidate];
            _hours = _minutes = _seconds = 0;
            _minSeconds = _duration = 0.0;
            self.recorderTimer = nil;
            self.btnCancel.hidden = NO;
            self.btnConfirm.hidden = NO;
            _labelCancel.hidden = NO;
            _labelConfirm.hidden = NO;
            break;
        case EFRecordStateCancel:
            if (self.delegate) {
                [self.delegate cancelBlock:^(BOOL confirm) {
                    if (confirm) {
                        self.btnCancel.hidden = YES;
                        self.btnConfirm.hidden = YES;
                        self.labelCancel.hidden = YES;
                        self.labelConfirm.hidden = YES;
                        self.recordTimeLabel.hidden = YES;
                        [self.m_circleProgressBar setProgress:0.0 animated:NO];
                    }
                }];
            }
            break;
        case EFRecordStateConfirm:
            self.btnCancel.hidden = YES;
            self.btnConfirm.hidden = YES;
            self.labelCancel.hidden = YES;
            self.labelConfirm.hidden = YES;
            self.recordTimeLabel.hidden = YES;
            self.m_circleProgressBar.hidden = YES;
            self.btnRecorder.hidden = YES;
            self.btnRevoke.hidden = NO;
            self.labelRevoke.hidden = NO;
            self.btnDownload.hidden = NO;
            break;
        case EFRecordStateRevoke:
            self.btnCancel.hidden = NO;
            self.btnConfirm.hidden = NO;
            self.labelCancel.hidden = NO;
            self.labelConfirm.hidden = NO;
            self.recordTimeLabel.hidden = NO;
            self.m_circleProgressBar.hidden = NO;
            self.btnRecorder.hidden = NO;
            self.btnRevoke.hidden = YES;
            self.labelRevoke.hidden = YES;
            self.btnDownload.hidden = YES;
            break;
        case EFRecordStateDownload:
            if (self.delegate && [self.delegate respondsToSelector:@selector(saveVideoWithBlock:)]) {
                [self.delegate saveVideoWithBlock:^{
                    self.btnRevoke.hidden = YES;
                    self.labelRevoke.hidden = YES;
                    self.btnDownload.hidden = YES;
                    self.btnDownload.enabled = YES;
                }];
            }
            break;
        case EFRecordStateMin:
            self.btnCancel.hidden = NO;
            self.btnConfirm.hidden = NO;
            
            self.btnConfirm.hidden = YES;
            self.labelConfirm.hidden = YES;
            
            _labelCancel.hidden = NO;
            [self.recorderTimer invalidate];
            self.recorderTimer = nil;
            [EFToast showError:self
                   description:NSLocalizedString(@"视频录制时间小于2s，请重新录制", nil)];
            [self.m_circleProgressBar setProgress:0.0 animated:YES];
            [_btnRecorder setImage:[UIImage imageNamed:@"after recording_icon"] forState:UIControlStateNormal];
        default:
            break;
    }
}

- (void)btnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1000:
            [self updateState:EFRecordStateCancel];
            break;
        case 1001:
            [self updateState:EFRecordStateConfirm];
            break;
        case 1002:
            [self updateState:EFRecordStateRevoke];
            break;
        case 1003:
            [self updateState:EFRecordStateDownload];
            btn.enabled = NO;
            break;
        default:
            break;
    }
}

static CGFloat recordMax = 60.f;

#pragma mark - Action
- (void)recorderTime:(NSTimer *)timer{
    [self updateTimerLabel];
    _duration+=0.1;
    if (_duration > recordMax) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self record];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.m_circleProgressBar setProgress:self.duration/recordMax animated:YES];
    });
}

- (void)updateTimerLabel{
    _minSeconds += 0.1;
    if (_minSeconds >= 1.0) {
        _minSeconds = 0.0;
        ++_seconds;
    }
    if (_seconds == 60) {
        _seconds = 0;
        ++_minutes;
    }
    if (_minutes == 60) {
        _minutes = 0;
        ++_hours;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.recordTimeLabel.text = [NSString stringWithFormat:@"• %02d:%02d:%02d", self.hours, self.minutes, self.seconds];
    });
}

@end
