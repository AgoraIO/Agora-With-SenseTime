//
//  SenseSettingManager.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseSettingView.h"
#import "STParamUtil.h"
#import "SenseTimeUtil.h"

@interface SenseSettingView()<UIWebViewDelegate>

@property (nonatomic, readwrite, strong) UILabel *resolutionLabel;
@property (nonatomic, readwrite, strong) UILabel *attributeLabel;

@property (nonatomic, readwrite, strong) UISwitch *attributeSwitch;

//resolution change btn
@property (nonatomic, readwrite, strong) UIButton *btn640x480;
@property (nonatomic, readwrite, strong) UIButton *btn1280x720;
@property (nonatomic, readwrite, strong) CAShapeLayer *btn640x480BorderLayer;
@property (nonatomic, readwrite, strong) CAShapeLayer *btn1280x720BorderLayer;

@property (nonatomic, strong) UILabel *lblTermsOfUse;

@property (nonatomic, strong) UIView *termsOfUseView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation SenseSettingView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews {
    [self addSubview:self.resolutionLabel];
    [self addSubview:self.btn640x480];
    [self addSubview:self.btn1280x720];
    [self addSubview:self.attributeLabel];
    [self addSubview:self.attributeSwitch];
    [self addSubview:self.lblTermsOfUse];
}

- (UIButton *)btn640x480 {
    
    if (!_btn640x480) {
        _btn640x480 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.resolutionLabel.frame) + 21, 25, 84, 35)];
        
        _btn640x480.backgroundColor = [UIColor clearColor];
        _btn640x480.layer.cornerRadius = 7;
        _btn640x480.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btn640x480.layer addSublayer:self.btn640x480BorderLayer];
        
        [_btn640x480 setTitle:@"640x480" forState:UIControlStateNormal];
        [_btn640x480 setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        _btn640x480.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn640x480.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_btn640x480 addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _btn640x480;
}

- (UIButton *)btn1280x720 {
    
    if (!_btn1280x720) {
        
        _btn1280x720 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.btn640x480.frame) + 20, 25, 93, 35)];
        
        _btn1280x720.backgroundColor = [UIColor whiteColor];
        _btn1280x720.layer.cornerRadius = 7;
        _btn1280x720.layer.borderColor = [UIColor whiteColor].CGColor;
        _btn1280x720.layer.borderWidth = 1;
        [_btn1280x720.layer addSublayer:self.btn1280x720BorderLayer];
        self.btn1280x720BorderLayer.hidden = YES;
        
        [_btn1280x720 setTitle:@"1280x720" forState:UIControlStateNormal];
        [_btn1280x720 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _btn1280x720.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn1280x720.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_btn1280x720 addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btn1280x720;
}

- (UILabel *)resolutionLabel {
    
    CGRect bounds = [@"分辨率" boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
    
    
    if (!_resolutionLabel) {
        _resolutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 33, bounds.size.width, bounds.size.height)];
        _resolutionLabel.text = @"分辨率";
        _resolutionLabel.font = [UIFont systemFontOfSize:15];
        _resolutionLabel.textColor = [UIColor whiteColor];
    }
    return _resolutionLabel;
}



- (UILabel *)attributeLabel {
    
    if (!_attributeLabel) {
        _attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(self.resolutionLabel.frame) + 30, CGRectGetMaxX(self.resolutionLabel.frame), self.resolutionLabel.frame.size.height)];
        _attributeLabel.text = @"性  能";
        _attributeLabel.textAlignment = NSTextAlignmentLeft;
        _attributeLabel.font = [UIFont systemFontOfSize:15];
        _attributeLabel.textColor = [UIColor whiteColor];
    }
    return _attributeLabel;
}

- (UILabel *)lblTermsOfUse {
    
    if (!_lblTermsOfUse) {
        _lblTermsOfUse = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(self.attributeLabel.frame) + 25, 100, 20)];
        _lblTermsOfUse.userInteractionEnabled = YES;
        NSString *str = @"使用条款";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 4)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 4)];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 4)];
        _lblTermsOfUse.attributedText = attributedString;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermsOfUse:)];
        [_lblTermsOfUse addGestureRecognizer:tapGesture];
        
    }
    return _lblTermsOfUse;
}

- (UISwitch *)attributeSwitch {
    
    if (!_attributeSwitch) {
        _attributeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.btn640x480.frame.origin.x, CGRectGetMaxY(self.btn640x480.frame) + 15, 79, 35)];
        [_attributeSwitch addTarget:self action:@selector(onAttributeSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _attributeSwitch;
}

- (void)onAttributeSwitch:(UISwitch *)sender {
    if(self.senseSettingDelegate != nil) {
        [self.senseSettingDelegate changeAttribute: sender.isOn];
    }
}

- (void)changeResolution:(UIButton *)sender {

    if (sender == _btn640x480) {
        self.btn640x480.backgroundColor = [UIColor whiteColor];
        [self.btn640x480 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btn640x480.layer.borderWidth = 1;
        self.btn640x480.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btn640x480BorderLayer.hidden = YES;

        self.btn1280x720.backgroundColor = [UIColor clearColor];
        [self.btn1280x720 setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.btn1280x720.layer.borderWidth = 0;
        self.btn1280x720BorderLayer.hidden = NO;

        self.btn1280x720.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btn1280x720.enabled = YES;
        });
        
        if(self.senseSettingDelegate != nil) {
            [self.senseSettingDelegate changeResolution640x480];
        }
    }

    if (sender == _btn1280x720) {

        self.btn1280x720.backgroundColor = [UIColor whiteColor];
        [self.btn1280x720 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btn1280x720.layer.borderWidth = 1;
        self.btn1280x720.layer.borderColor = [UIColor whiteColor].CGColor;
        self.btn1280x720BorderLayer.hidden = YES;

        self.btn640x480.backgroundColor = [UIColor clearColor];
        [self.btn640x480 setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.btn640x480.layer.borderWidth = 0;
        self.btn640x480BorderLayer.hidden = NO;

        self.btn640x480.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.btn640x480.enabled = YES;
        });
        
        if(self.senseSettingDelegate != nil) {
            [self.senseSettingDelegate changeResolution1280x720];
        }
    }
}

- (void)showTermsOfUse:(UITapGestureRecognizer *)tapGesture {
    [UIApplication.sharedApplication.keyWindow addSubview: self.termsOfUseView];
    self.termsOfUseView.hidden = NO;
    
    NSString *strTermsOfUsePath = [[NSBundle mainBundle] pathForResource:@"TermsOfUse" ofType:@"htm"];
    NSString *strContentOfTerms = [NSString stringWithContentsOfFile:strTermsOfUsePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:strContentOfTerms baseURL:nil];
    [_indicatorView startAnimating];
}

- (void)hideTermsOfUseView {
    [self.termsOfUseView removeFromSuperview];
    self.termsOfUseView.hidden = YES;
}

- (UIView *)termsOfUseView {
    
    if (!_termsOfUseView) {
        
        _termsOfUseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _termsOfUseView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"使用条款";
        [_termsOfUseView addSubview:titleLabel];
        
        UIButton *btnHide = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [btnHide setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
        [btnHide addTarget:self action:@selector(hideTermsOfUseView) forControlEvents:UIControlEventTouchUpInside];
        [_termsOfUseView addSubview:btnHide];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
        _webView.delegate = self;
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        [_termsOfUseView addSubview:_webView];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 25, SCREEN_HEIGHT / 2 - 25, 50, 50)];
        indicatorView.color = [UIColor grayColor];
        [_termsOfUseView addSubview:indicatorView];
        _indicatorView = indicatorView;
        
        if ([SenseTimeUtil isIphoneX]) {
            titleLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 30);
            btnHide.frame = CGRectMake(5, 30, 30, 30);
            _webView.frame = CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT - 70);
        }
        _termsOfUseView.hidden = YES;
    }
    return _termsOfUseView;
}

- (CAShapeLayer *)btn640x480BorderLayer {
    
    if (!_btn640x480BorderLayer) {
        
        _btn640x480BorderLayer = [CAShapeLayer layer];
        
        _btn640x480BorderLayer.frame = self.btn640x480.bounds;
        _btn640x480BorderLayer.strokeColor = [UIColor whiteColor].CGColor;
        _btn640x480BorderLayer.fillColor = nil;
        _btn640x480BorderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.btn640x480.bounds cornerRadius:7].CGPath;
        _btn640x480BorderLayer.lineWidth = 1;
        _btn640x480BorderLayer.lineDashPattern = @[@4, @2];
    }
    return _btn640x480BorderLayer;
}

- (CAShapeLayer *)btn1280x720BorderLayer {
    
    if (!_btn1280x720BorderLayer) {
        
        _btn1280x720BorderLayer = [CAShapeLayer layer];
        
        _btn1280x720BorderLayer.frame = self.btn1280x720.bounds;
        _btn1280x720BorderLayer.strokeColor = [UIColor whiteColor].CGColor;
        _btn1280x720BorderLayer.fillColor = nil;
        _btn1280x720BorderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.btn1280x720.bounds cornerRadius:7].CGPath;
        _btn1280x720BorderLayer.lineWidth = 1;
        _btn1280x720BorderLayer.lineDashPattern = @[@4, @2];
    }
    return _btn1280x720BorderLayer;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicatorView stopAnimating];
}

@end
