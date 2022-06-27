//
//  EFEffectsView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/10.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFEffectsView.h"

typedef NS_ENUM(NSUInteger, EFBtnType) {
    EFBtnTypeTakePhoto,
    EFBtnTypeRecord,
};

@interface EFEffectsView ()
{
    EFViewType _type;
    EffectsActionType _actionType;
    EFBtnType _efBtnType;
}


//放大
@property (nonatomic, strong) UIButton *enlargedButton;

//对比
@property (nonatomic, strong) UIButton *comparisonButton;

//拍照按钮
@property (nonatomic, strong) UIButton *takePhotoButton;

//style
@property (nonatomic, strong) UIButton *styleButton;

//视频
@property (nonatomic, strong) UIButton *videoButton;

//拍摄
@property (nonatomic, strong) UIButton *cameraButton;

//底部View
@property (nonatomic, strong) UIView *bottomView;

//黑点
@property (nonatomic, strong) UIView *pointView;

//data
@property (nonatomic, strong) NSMutableArray <EFDataSourceModel *> *dataArray;

//按钮列表
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonList;

@property (nonatomic, strong) NSMutableArray <UILabel *>  *labelList;

@end

@implementation EFEffectsView

- (instancetype)initWithFrame:(CGRect)frame type:(EFViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        self.dataArray = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor clearColor];
        self.buttonList = [[NSMutableArray alloc]init];
        self.labelList = [[NSMutableArray alloc]init];
        [self setUI];
    }
    return self;
}


- (void)setUI {
    if (EFViewTypePreview == _type) {
        self.enlargedButton = [[UIButton alloc] init];
        self.enlargedButton.tag = 100;
        [self.enlargedButton setImage:[UIImage imageNamed:@"enlarged_icon"] forState:UIControlStateNormal];
        [self.enlargedButton addTarget:self action:@selector(amplificationContrastAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.enlargedButton];
        [self.enlargedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(16);
        }];
    }
    
    self.comparisonButton = [[UIButton alloc] init];
    self.comparisonButton.tag = 101;
    [self.comparisonButton setImage:[UIImage imageNamed:@"comparison_icon"] forState:UIControlStateNormal];
    [self.comparisonButton setImage:[UIImage imageNamed:@"comparison_icon"] forState:UIControlStateSelected];
    [self.comparisonButton addTarget:self action:@selector(onBtnCompareTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.comparisonButton addTarget:self action:@selector(onBtnCompareTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.comparisonButton];
    [self.comparisonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.left.right.bottom.equalTo(self);
    }];
    
    if (EFViewTypePreview == _type) {
        self.pointView = [[UIView alloc]init];
        self.pointView.layer.cornerRadius = 2;
        self.pointView.layer.masksToBounds = YES;
        self.pointView.backgroundColor = [UIColor blackColor];
        [self.bottomView addSubview:self.pointView];
        [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(4);
            make.centerX.equalTo(self.bottomView);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-20);
        }];
        
        self.cameraButton = [[UIButton alloc]init];
        self.cameraButton.tag = 100;
        self.cameraButton.selected = YES;
        [self.cameraButton setTitle:NSLocalizedString(@"拍摄", nil) forState:UIControlStateNormal];
        self.cameraButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        [self.cameraButton setTitleColor:RGBA(61, 61, 61, 1) forState:UIControlStateSelected];
        [self.cameraButton setTitleColor:RGBA(127, 127, 127, 1) forState:UIControlStateNormal];
        [self.cameraButton addTarget:self action:@selector(bottomViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.cameraButton];
        [self.cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.pointView);
            make.top.equalTo(self.bottomView.mas_top).offset(6);
        }];
        
        self.videoButton = [[UIButton alloc]init];
        self.videoButton.tag = 101;
        [self.videoButton setTitle:NSLocalizedString(@"视频", nil)  forState:UIControlStateNormal];
        self.videoButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [self.videoButton setTitleColor:RGBA(127, 127, 127, 1) forState:UIControlStateNormal];
        [self.videoButton setTitleColor:RGBA(61, 61, 61, 1) forState:UIControlStateSelected];
        [self.videoButton addTarget:self action:@selector(bottomViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.videoButton];
        [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cameraButton.mas_top);
            make.right.equalTo(self.cameraButton.mas_left).offset(-30);
        }];
        
        self.styleButton = [[UIButton alloc]init];
        self.styleButton.tag = 102;
        [self.styleButton setTitle:NSLocalizedString(@"风格", nil) forState:UIControlStateNormal];
        self.styleButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        [self.styleButton setTitleColor:RGBA(221, 144, 250, 1) forState:UIControlStateNormal];
        [self.styleButton addTarget:self action:@selector(bottomViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.styleButton];
        [self.styleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cameraButton.mas_top);
            make.left.equalTo(self.cameraButton.mas_right).offset(30);
        }];
    }
    
    NSMutableArray <EFDataSourceModel *> *buttonArray = [[NSMutableArray alloc]init];
    EFDataSourceModel *model = [EFDataSourceGenerator sharedInstance].efDataSourceModel;
    for (int i = 0; i < model.efSubDataSources.count; i++) {
        EFDataSourceModel *dataModel = model.efSubDataSources[i];
        if ([dataModel.efName isEqualToString:@"特效"]) {
            [buttonArray addObject:dataModel];
        }
        if ([dataModel.efName isEqualToString:@"美妆"]) {
            [buttonArray addObject:dataModel];
        }
        if ([dataModel.efName isEqualToString:@"滤镜"]) {
            [buttonArray addObject:dataModel];
        }
        if ([dataModel.efName isEqualToString:@"美颜"]) {
            [buttonArray addObject:dataModel];
        }
    }
    self.dataArray = [[[buttonArray reverseObjectEnumerator] allObjects] mutableCopy];
    
    NSArray *imageList = @[@"texiao_process", @"meizhuang_process", @"lvjing_process", @"meiyan_process"];
    NSArray *titleList = @[@"特效", @"美妆", @"滤镜", @"美颜"];
    
    [imageList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //过滤网络请求为nil情况
        if (model == nil) {
            EFDataSourceModel *dataModel = [[EFDataSourceModel alloc]init];
            dataModel.efName = titleList[idx];
            [self.dataArray addObject:dataModel];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = idx;
        [button setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(effectsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttonList addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (idx < 2) {
                make.left.equalTo(self.mas_left).offset(28 + (36 + 28)*idx);
            } else {
                NSInteger right = (-36 - 28) * (3 - idx);
                make.right.equalTo(self.mas_right).offset(-28 + right);
            }
            make.bottom.equalTo(self.bottomView.mas_top).offset(-54);
        }];

        UILabel *label = [[UILabel alloc]init];
        label.text = NSLocalizedString(titleList[idx], nil);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [self addSubview:label];
        [self.labelList addObject:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(button.mas_centerX);
            make.top.equalTo(button.mas_bottom).offset(8);
        }];
    }];
    
    if (EFViewTypePreview == _type) {
        self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.takePhotoButton setImage:[UIImage imageNamed:@"takePhoto_process"] forState:UIControlStateNormal];
        [self.takePhotoButton addTarget:self action:@selector(takePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.takePhotoButton];
        [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.bottomView.mas_top).offset(-28);
        }];
    }
    
    if (EFViewTypePreview != _type) {
        self.styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.styleButton setImage:[UIImage imageNamed:@"fengge_process"] forState:UIControlStateNormal];
        [self.styleButton addTarget:self action:@selector(takePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.styleButton];
        [self.styleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.bottomView.mas_top).offset(-28);
        }];
    }
}

- (void)hideSubview:(BOOL)hide {
    for (UIView *view in self.subviews) {
        if ([view isEqual: self.bottomView]) {
            view.hidden = NO;
            for (UIView *sub in self.bottomView.subviews) {
                sub.hidden = hide;
            }
        } else {
            view.hidden = hide;
        }
    }
}

- (void)bottomViewButtonAction:(UIButton *)sender {
    [self contentOffset:(int)sender.tag];
    _actionType = sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(efEffectsView:videoCamearStyleAction:)]) {
        [self.delegate efEffectsView:self videoCamearStyleAction:sender.tag - 100];
    }
}


- (void)contentOffset:(int)index {
    
    switch (index) {
            //拍摄
        case 100:
        {
            [self.takePhotoButton setImage:[UIImage imageNamed:@"takePhoto_process"] forState:UIControlStateNormal];
            self.cameraButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
            self.videoButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.styleButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.cameraButton.selected = YES;
            self.videoButton.selected = NO;
            self.takePhotoButton.hidden  = NO;
            [UIView animateWithDuration:0.25 animations:^{
                [self.cameraButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.pointView.mas_centerX);
                }];
                [self.bottomView layoutIfNeeded];
            }];
            _efBtnType = EFBtnTypeTakePhoto;
        }
            break;
            //视频
        case 101:
        {
            [self.takePhotoButton setImage:[UIImage imageNamed:@"record_icon-1"] forState:UIControlStateNormal];
            self.videoButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
            self.cameraButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.styleButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.cameraButton.selected = NO;
            self.videoButton.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
                [self.cameraButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.pointView.mas_centerX).offset(28 + 30);
                }];
                [self.bottomView layoutIfNeeded];
            }];
            _efBtnType = EFBtnTypeRecord;
        }
            break;
            //风格
        case 102:
        {
            self.styleButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
            self.cameraButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.videoButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
            self.cameraButton.selected = NO;
            self.videoButton.selected = NO;
            self.takePhotoButton.hidden  = YES;
            [UIView animateWithDuration:0.25 animations:^{
                [self.cameraButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.pointView.mas_centerX).offset(-(28 + 30));
                }];
                [self.bottomView layoutIfNeeded];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)effectsWithDark:(BOOL)dark {
    
    for (UILabel *label in self.labelList) {
        label.textColor = dark ? RGBA(78, 78, 78, 1) : RGBA(255, 255, 255, 1);
    }
    
    NSArray *imageList = @[@"texiao", @"meizhuang", @"lvjing", @"meiyan"]; //_process _dark
    for (UIButton *button in self.buttonList) {
        NSString *str = dark ? @"dark" : @"process";
        NSString *imageName = [NSString stringWithFormat:@"%@_%@", imageList[button.tag], str];
        [button setImage:[UIImage imageNamed: imageName] forState:UIControlStateNormal];
    }
}



#pragma mark - Action
- (void)onBtnCompareTouchDown:(UIButton *)sender{
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(efEffectsView:amplificationContrastAction:sender:)]) {
        [self.delegate efEffectsView:self amplificationContrastAction:sender.tag - 100 sender:sender];
    }
}

- (void)onBtnCompareTouchUpInside:(UIButton *)sender{
    sender.selected = NO;
    if ([self.delegate respondsToSelector:@selector(efEffectsView:amplificationContrastAction:sender:)]) {
        [self.delegate efEffectsView:self amplificationContrastAction:sender.tag - 100 sender:sender];
    }
}


- (void)amplificationContrastAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(efEffectsView:amplificationContrastAction:sender:)]) {
        [self.delegate efEffectsView:self amplificationContrastAction:sender.tag - 100 sender:sender];
    }
}

- (void)effectsAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(efEffectsView:effectsAction:index:)]) {
        if (self.dataArray.count > sender.tag) {
            [self.delegate efEffectsView:self effectsAction:self.dataArray[sender.tag] index:0];
        } else {
            EFDataSourceModel *model = [[EFDataSourceModel alloc]init];
            [self.delegate efEffectsView:self effectsAction:model index:0];
        }
    }
}

- (void)takePhotoButtonAction:(UIButton *)sender{
    if (sender == self.takePhotoButton) {
        if (_efBtnType == EFBtnTypeRecord) {
            _actionType = effectsRecord;
        }else{
            _actionType = effectsTakePhoto;
        }
    }
    if (sender == self.styleButton) {
        _actionType = effectsStyle;
    }
    if ([self.delegate respondsToSelector:@selector(efEffectsView:videoCamearStyleAction:)]) {
        [self.delegate efEffectsView:self videoCamearStyleAction:_actionType];
    }
}


@end
