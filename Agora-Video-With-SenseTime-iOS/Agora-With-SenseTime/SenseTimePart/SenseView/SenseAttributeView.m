//
//  SenseAttributeView.m
//  Agora-With-SenseTime
//
//  Created by SRS on 2019/11/18.
//  Copyright © 2019 agora. All rights reserved.
//

#import "SenseAttributeView.h"
#import "STParamUtil.h"

@interface SenseAttributeView ()

@property (nonatomic, strong) UILabel *lblAttribute;
@property (nonatomic, strong) UILabel *lblSpeed;
@property (nonatomic, strong) UILabel *lblCPU;

@property (nonatomic, copy) NSString *strBodyAction;
@property (nonatomic, strong) UILabel *lblBodyAction;

@end

@implementation SenseAttributeView

- (instancetype)init {
    if(self = [super init]){
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)setupView {
    
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.lblSpeed];
    [self addSubview:self.lblCPU];
    
    self.userInteractionEnabled = NO;
}

- (UILabel *)lblAttribute {
    
    if (!_lblAttribute) {
        
        _lblAttribute = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 15.0)];
        _lblAttribute.textAlignment = NSTextAlignmentCenter;
        _lblAttribute.font = [UIFont systemFontOfSize:14.0];
        _lblAttribute.numberOfLines = 0;
        _lblAttribute.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _lblAttribute.shadowOffset = CGSizeMake(0, 1.0);
        _lblAttribute.backgroundColor = [UIColor clearColor];
        _lblAttribute.textColor = [UIColor whiteColor];
    }
    
    return _lblAttribute;
}

- (UILabel *)lblSpeed {
    if (!_lblSpeed) {
        
        _lblSpeed = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 ,SCREEN_WIDTH, 15)];
        _lblSpeed.textAlignment = NSTextAlignmentLeft;
        [_lblSpeed setTextColor:[UIColor whiteColor]];
        [_lblSpeed setBackgroundColor:[UIColor clearColor]];
        [_lblSpeed setFont:[UIFont systemFontOfSize:15.0]];
        [_lblSpeed setShadowColor:[UIColor blackColor]];
        [_lblSpeed setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
    
    return _lblSpeed;
}

- (UILabel *)lblCPU {
    
    if (!_lblCPU) {
        
        _lblCPU = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lblSpeed.frame), CGRectGetMaxY(_lblSpeed.frame) + 2 , CGRectGetWidth(_lblSpeed.frame), CGRectGetHeight(_lblSpeed.frame))];
        _lblCPU.textAlignment = NSTextAlignmentLeft;
        [_lblCPU setTextColor:[UIColor whiteColor]];
        [_lblCPU setBackgroundColor:[UIColor clearColor]];
        [_lblCPU setFont:[UIFont systemFontOfSize:15.0]];
        [_lblCPU setShadowColor:[UIColor blackColor]];
        [_lblCPU setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
    
    return _lblCPU;
}

- (UILabel *)lblBodyAction {
    
    if (!_lblBodyAction) {
        _lblBodyAction = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.lblCPU.frame), CGRectGetMaxY(self.lblCPU.frame) + 2, SCREEN_WIDTH, 15)];
        _lblBodyAction.textAlignment = NSTextAlignmentLeft;
        [_lblBodyAction setTextColor:[UIColor whiteColor]];
        [_lblBodyAction setBackgroundColor:[UIColor clearColor]];
        [_lblBodyAction setFont:[UIFont systemFontOfSize:15.0]];
        [_lblBodyAction setShadowColor:[UIColor blackColor]];
        [_lblBodyAction setShadowOffset:CGSizeMake(1.0, 1.0)];
    }
    return _lblBodyAction;
}

- (void)clearAttributeDescription {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.lblAttribute setText:@""];
        [self.lblAttribute setHidden:YES];
    });
}
- (void)setAttributeDescription:(st_mobile_attributes_t) attributeDisplay {
    
   //获取属性描述
   NSString *strAttrDescription = [self getDescriptionOfAttribute:attributeDisplay];
   
   dispatch_async(dispatch_get_main_queue(), ^{
       
       [self.lblAttribute setText:[@"第一张人脸: " stringByAppendingString:strAttrDescription]];
       [self.lblAttribute setHidden:NO];
   });
}

- (void)setBodyActionDescription {
    if (![self.strBodyAction isEqualToString:self.lblBodyAction.text]) {
        self.lblBodyAction.text = self.strBodyAction;
    }
}

- (void)showDescription:(double)dStart {
    self.hidden = NO;
    
    double dCost = 0.0;
    dCost = CFAbsoluteTimeGetCurrent() - dStart;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBodyActionDescription];
        [self setSpeedDescription:[NSString stringWithFormat:@"单帧耗时: %.0fms", dCost * 1000.0]];
        [self setCpuDescription:[NSString stringWithFormat:@"CPU占用率: %.1f%%", [STParamUtil getCpuUsage]]];
    });
}

- (void)setSpeedDescription:(NSString*)text {
    [self.lblSpeed setText:text];
}
- (void)setCpuDescription:(NSString*)text {
    [self.lblCPU setText:text];
}

#pragma mark - private methods
- (NSString *)getDescriptionOfAttribute:(st_mobile_attributes_t)attribute {
    NSString *strAge , *strGender , *strAttricative = nil;
    
    for (int i = 0; i < attribute.attribute_count; i ++) {
        
        // 读取一条属性
        st_mobile_attribute_t attributeOne = attribute.p_attributes[i];
        
        // 获取属性类别
        const char *attr_category = attributeOne.category;
        const char *attr_label = attributeOne.label;
        
        // 年龄
        if (0 == strcmp(attr_category, "age")) {
            
            strAge = [NSString stringWithUTF8String:attr_label];
        }
        
        // 颜值
        if (0 == strcmp(attr_category, "attractive")) {
            
            strAttricative = [NSString stringWithUTF8String:attr_label];
        }
        
        // 性别
        if (0 == strcmp(attr_category, "gender")) {
            
            if (0 == strcmp(attr_label, "male") ) {
                
                strGender = @"男";
            }
            
            if (0 == strcmp(attr_label, "female") ) {
                
                strGender = @"女";
            }
        }
    }
    
    NSString *strAttrDescription = [NSString stringWithFormat:@"颜值:%@ 性别:%@ 年龄:%@" , strAttricative , strGender , strAge];
    
    return strAttrDescription;
}

@end
