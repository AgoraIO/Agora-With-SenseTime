//
//  STBeautyMakeUpCollectionView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2019/5/10.
//  Copyright © 2019 SenseTime. All rights reserved.
//

#import "STBMPCollectionView.h"
#import "STBMPCollectionViewCell.h"

@interface STBMPCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,STBMPDetailColVDelegate>
//ui
@property (nonatomic, strong) UIView *m_backBaseV;
@property (nonatomic, strong) UIImageView *m_backImgV;
@property (nonatomic, strong) UIButton *m_backBtn;
@property (nonatomic, strong) UILabel *m_itemName;
@property (nonatomic, strong) UICollectionView *m_bmpTypeColv;
@property (nonatomic, strong) STBMPDetailColV *m_bmpDetailColV;

//data source
@property (nonatomic, strong) NSMutableArray<STBMPModel *>*m_bmpTypeArr;
@property (nonatomic, strong) STBMPModel *m_curModel;

@property (nonatomic, strong) NSMutableArray<STBMPModel *> *m_bmpModels;

@end

@implementation STBMPCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUis) name:@"resetUIs" object:nil];
        
        [self setupDefaults];
        
        [self setupUIs];
        
        return self;
    }
    
    return nil;
}

- (void)setupDefaults
{
    NSArray *types = @[@"腮红",@"眉毛",@"修容",@"口红",@"眼影",@"眼线",@"眼睫毛"];
    NSArray *bmpTypes = @[@(STBMPTYPE_BLUSH),@(STBMPTYPE_BROW),@(STBMPTYPE_FACE),@(STBMPTYPE_LIP),@(STBMPTYPE_EYE),@(STBMPTYPE_EYELINER),@(STBMPTYPE_EYELASH)];
    NSArray *iconDefaults = @[@"blush",@"brow",@"face",@"lip",@"eyeshadow-white",@"eyeline-white",@"eyelash-white"];
    NSArray *iconHightLights = @[@"blush_selected",@"brow_selected",@"face_selected",@"lip_selected",@"eyeshadow-purple",@"eyeline-purple",@"eyelash-purple"];
    self.m_bmpTypeArr = [NSMutableArray array];
    for(int i = 0; i < types.count; ++i){
        STBMPModel *model = [[STBMPModel alloc] init];
        model.m_name = types[i];
        model.m_iconDefault = iconDefaults[i];
        model.m_iconHighlight = iconHightLights[i];
        NSNumber *num = bmpTypes[i];
        model.m_bmpType = num.integerValue;
        [_m_bmpTypeArr addObject:model];
    };
}

- (void)setupUIs
{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 90);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.m_bmpTypeColv = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 20, self.frame.size.width, 80) collectionViewLayout:flowLayout];
    self.m_bmpTypeColv.delegate = self;
    self.m_bmpTypeColv.dataSource = self;
    self.m_bmpTypeColv.backgroundColor = [UIColor clearColor];
    self.m_bmpTypeColv.showsVerticalScrollIndicator = NO;
    [self.m_bmpTypeColv registerClass:[STBMPCollectionViewCell class] forCellWithReuseIdentifier:@"STBMPCollectionViewCell"];
    [self addSubview:self.m_bmpTypeColv];
    
    //back btn
    UIView *backBaseV = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 70, 90)];
    [self addSubview:backBaseV];
    backBaseV.backgroundColor = [UIColor clearColor];
    _m_backBaseV = backBaseV;
    backBaseV.hidden = YES;
    
    UIImageView *backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 10, 10)];
    [backBaseV addSubview:backImgV];
    [backImgV setImage:[UIImage imageNamed:@"filter_back_btn"]];
    _m_backImgV = backImgV;
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 60, 60)];
    [backBaseV addSubview:backBtn];
    [backBtn addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
    _m_backBtn = backBtn;
    
    UILabel *itemName = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backBtn.frame), 50, 20)];
    itemName.textAlignment = NSTextAlignmentCenter;
    itemName.textColor = [UIColor whiteColor];
    itemName.font = [UIFont systemFontOfSize:14];
    itemName.backgroundColor = [UIColor clearColor];
    [backBaseV addSubview:itemName];
    itemName.center = CGPointMake(_m_backBtn.center.x, itemName.center.y);
    _m_itemName = itemName;
    
    _m_bmpDetailColV = [[STBMPDetailColV alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame), 20, self.frame.size.width - CGRectGetMaxX(backBaseV.frame), 90)];
    [self addSubview:_m_bmpDetailColV];
    _m_bmpDetailColV.hidden = YES;
    _m_bmpDetailColV.delegate = self;
    
    backBaseV.center = CGPointMake(_m_backBaseV.center.x, _m_bmpDetailColV.center.y);
}

- (void)backToMenu
{
    [self onBackClick];
}

- (void)onBackClick
{
    [self backToPreView:YES];
}

- (void)backToPreView:(BOOL)back
{
    if (back) {

        _m_backBaseV.hidden = YES;
        _m_bmpDetailColV.hidden = YES;
        _m_bmpTypeColv.hidden = NO;
    }else{
        
        _m_backBaseV.hidden = NO;
        _m_bmpDetailColV.hidden = NO;
        _m_bmpTypeColv.hidden = YES;
    }
    
    if (self.delegate) {
        [self.delegate backToMainView];
    }
}

- (void)updateUIsWithModel:(STBMPModel *)model
{
    _m_itemName.text = model.m_name;
    if (model.m_selected) {
        [_m_backBtn setBackgroundImage:[UIImage imageNamed:model.m_iconHighlight] forState:UIControlStateNormal];
    }else{
        [_m_backBtn setBackgroundImage:[UIImage imageNamed:model.m_iconDefault] forState:UIControlStateNormal];
    }
}

#pragma collectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _m_bmpTypeArr.count;
}

#pragma dataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STBMPCollectionViewCell *cell = (STBMPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"STBMPCollectionViewCell" forIndexPath:indexPath];
    STBMPModel *model = _m_bmpTypeArr[(int)indexPath.row];
    [cell setName:model.m_name];
    if (model.m_selected) {
        [cell setIcon:model.m_iconHighlight];
    }else{
        [cell setIcon:model.m_iconDefault];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    STBMPModel *model = _m_bmpTypeArr[(int)indexPath.row];
    _m_curModel = model;
    [self backToPreView:NO];
    [self updateUIsWithModel:model];
    [_m_bmpDetailColV didSelectedBmpType:model];
}

#pragma STBMPDetailColVDelegate
- (void)didSelectedModel:(STBMPModel *)model
{
    if (model.m_index != 0) {
        _m_curModel.m_selected = YES;
    }else{
        _m_curModel.m_selected = NO;
    }
    [self updateUIsWithModel:_m_curModel];
    [_m_bmpTypeColv reloadData];
    
    if (self.delegate) {
        [self.delegate didSelectedDetailModel:model];
    }
}

- (void)resetUis
{
    for (STBMPModel *model in _m_bmpTypeArr) {
        model.m_selected = NO;
    }
    [_m_bmpTypeColv reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetUIs" object:nil];
}

@end
