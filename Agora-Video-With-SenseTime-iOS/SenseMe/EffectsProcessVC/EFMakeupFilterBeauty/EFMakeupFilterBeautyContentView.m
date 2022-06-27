//
//  EFMakeupFilterBeautyContentView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/15.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFMakeupFilterBeautyContentView.h"
#import "EFMakeupFilterBeautyCell.h"

@interface EFMakeupFilterBeautyContentView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *noneButton;

@property (nonatomic, strong) UILabel *noneLabel;

///清零
@property (nonatomic, strong) UIButton *clearButton;

///重置
@property (nonatomic, strong) UIButton *resetButton;

@property (nonatomic, assign) EffectsItemType itemType;

@property (nonatomic, strong) EFStatusManager *statusManager;

//--- 记录有多级列表(只在多级列表显示)
@property (nonatomic, strong) NSString *backName;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UILabel *backLabel;

@end

@implementation EFMakeupFilterBeautyContentView
{
    BOOL _is3D;
}


- (instancetype)initWithFrame:(CGRect)frame withType:(EffectsItemType)itemType model:(EFStatusManagerSingletonMode)model{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.statusManager = [EFStatusManager sharedInstanceWith:model];
        
        [self setUI:itemType];
    }
    return self;
}

- (void)setUI:(EffectsItemType)itemType with3D:(BOOL)is3D {
    _is3D = is3D;
    self.itemType = itemType;
    [self addSubview:self.collectionView];
    [self addSubview:self.clearButton];
    [self addSubview:self.resetButton];
    switch (itemType) {
        case effectsItemMakeup:
        {
            [self addSubview:self.noneButton];
            [self addSubview:self.noneLabel];
            
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(120);
                make.right.top.equalTo(self);
                make.left.equalTo(self.mas_left).offset(80);
            }];
            
            [self.noneButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(44);
                make.left.equalTo(self).offset(22);
                make.top.equalTo(self.mas_top).offset(24);
            }];
            
            [self.noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.noneButton.mas_bottom).offset(5);
                make.centerX.equalTo(self.noneButton.mas_centerX);
            }];
        }
            
            break;
        case effectsItemBeauty:
        case effectsItemFilter:
        {
            self.backButton.hidden = YES;
            self.backLabel.hidden = YES;
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
                make.left.right.top.equalTo(self);
            }];
            
            [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.collectionView);
                make.top.equalTo(self.collectionView.mas_bottom);
                make.height.equalTo(@20);
            }];
            self.segment.hidden = !is3D;
            self.segment.selectedSegmentIndex = 0;
        }
            break;
        case effectsItemMulti:
        {
            [self addSubview:self.backButton];
            [self addSubview:self.backLabel];
            self.backButton.hidden = NO;
            self.backLabel.hidden = NO;
            self.backLabel.text = NSLocalizedString(self.backName, nil);
            
            [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(44);
                make.left.equalTo(self).offset(22);
                make.top.equalTo(self.mas_top).offset(24);
            }];
            
            [self.backLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.backButton.mas_bottom).offset(5);
                make.centerX.equalTo(self.backButton.mas_centerX);
            }];
            
            [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(120);
                make.right.top.equalTo(self);
                make.left.equalTo(self.backLabel.mas_right).offset(10);
            }];
            
        }
            break;
    }
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.left.equalTo(self.mas_left).offset(20);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-7);
        } else {
            make.bottom.equalTo(self.mas_bottom).offset(-12);
        }
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.clearButton.mas_centerY);
    }];
}

- (void)setUI:(EffectsItemType)itemType {
    [self setUI:itemType with3D:NO];
}

- (void)setDataSource:(NSMutableArray<EFDataSourceModel *> *)dataSource {
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFMakeupFilterBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFMakeupFilterBeautyCell" forIndexPath:indexPath];
    EFDataSourceModel * model = self.dataSource[indexPath.row];
    BOOL select = [self.statusManager efModelHasSelected:model];
    
    //获取slider value
    if (select) {
        if (self.delegate) {
            [self.delegate selectedCell:self.dataSource[indexPath.row] index:(int)indexPath.row];
        }
    }
    
    CGFloat value = [self.statusManager efStrengthOfModel:self.dataSource[indexPath.row]]/100.0;
    value = [EFMakeupFilterBeautyContentView updateCurrentBeautyValueWithModel:self.dataSource[indexPath.row] value:value];
    //下载状态
    EFMaterialDownloadStatus status = [self.statusManager efDownloadStatus:self.dataSource[indexPath.item]];
    
    [cell config:self.dataSource[indexPath.item]
            type:self.itemType
          select:select
          status:status
           value:[self floatToInt:value]];
    
    return cell;
}

- (int)floatToInt:(float)f{
    int i = 0;
    if(f>0) //正数
        i = (f*10 + 5)/10;
    else if(f<0) //负数
        i = (f*10 - 5)/10;
    else i = 0;
    
    return i;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = (int)indexPath.row;
    if (_is3D) {
        EFDataSourceModel *firstDataSourceModel = self.dataSource[indexPath.row];
        self.segment.selectedSegmentIndex = (firstDataSourceModel.efType & 0b111);
    }
    [self.statusManager efModelSelected:self.dataSource[indexPath.row] onProgress:nil onSuccess:^(id<EFDataSourcing> material) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            if (self.delegate) {
                [self.delegate selectedCell:self.dataSource[indexPath.row] index:(int)indexPath.row];
            }
        });
    } onFailure:nil];
    [self.collectionView reloadData];
    
    if (self.dataSource[indexPath.row].efSubDataSources.count > 0) {
        self.backName = self.dataSource[indexPath.row].efName;
        self.dataSource = [self.dataSource[indexPath.row].efSubDataSources mutableCopy];
        [self setUI:effectsItemMulti];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.dragging || !_is3D) {
        return;
    }
    NSArray<NSIndexPath *> *currentCellsIndexPath = [self.collectionView indexPathsForVisibleItems];
    NSArray<NSIndexPath *> *currentCellsIndexPathSorted = [currentCellsIndexPath sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * obj1, NSIndexPath * obj2) {
        return obj1.row > obj2.row;
    }];
    NSIndexPath * currentIndexPath = currentCellsIndexPathSorted.firstObject;
    EFDataSourceModel *firstDataSourceModel = self.dataSource[currentIndexPath.row];
    self.segment.selectedSegmentIndex = (firstDataSourceModel.efType & 0b111);
}

# pragma mark - action
- (void)clearButtonAction:(UIButton *)sender {
    if (self.dataSource && self.dataSource.count > 0) {
        [self.statusManager efClear:self.dataSource[0]];
        [self.collectionView reloadData];
        if (self.delegate) {
            [self.delegate contentViewEvent:EFContentViewEventClear];
        }
    }
}

- (void)resetButtonAction:(UIButton *)sender {
    [self.statusManager efReset:self.dataSource[0]];
    [self.collectionView reloadData];
    if (self.delegate) {
        [self.delegate contentViewEvent:EFContentViewEventReset];
    }
}

- (void)backButtonAction:(UIButton *)sender {
    
    [self.backButton removeFromSuperview];
    [self.backLabel removeFromSuperview];
    
    if (self.delegate) {
        [self.delegate backButtonAction:sender];
    }
}


- (UIButton *)noneButton {
    if (!_noneButton) {
        _noneButton = [[UIButton alloc]init];
        [_noneButton setImage:[UIImage imageNamed:@"none_process"] forState:UIControlStateNormal];
        [_noneButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noneButton;
}

- (UILabel *)noneLabel {
    if (!_noneLabel) {
        _noneLabel = [[UILabel alloc]init];
        _noneLabel.text = @"None";
        _noneLabel.textColor = RGBA(255, 255, 255, 0.5);
        _noneLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _noneLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]init];
        [_clearButton setImage:[UIImage imageNamed:@"clear_makeup"] forState:UIControlStateNormal];
        [_clearButton setTitle:NSLocalizedString(@"清零", nil) forState:UIControlStateNormal];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _clearButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _clearButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc]init];
        [_resetButton setImage:[UIImage imageNamed:@"reset_makeup"] forState:UIControlStateNormal];
        [_resetButton setTitle:NSLocalizedString(@"重置", nil) forState:UIControlStateNormal];
        _resetButton.hidden = (self.itemType == effectsItemBeauty | self.itemType == effectsItemMulti)  ? NO : YES;
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _resetButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _resetButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [_resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        [_backButton setImage:[UIImage imageNamed:@"beauty_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)backLabel {
    if (!_backLabel) {
        _backLabel = [[UILabel alloc]init];
        _backLabel.textColor = RGBA(255, 255, 255, 1);
        _backLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    }
    return _backLabel;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(64, 75);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(4, (self.itemType == effectsItemMakeup | self.itemType == effectsItemMulti)? 5 : 22, 0, 22);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[EFMakeupFilterBeautyCell class] forCellWithReuseIdentifier:@"EFMakeupFilterBeautyCell"];
    }
    return _collectionView;
}

+ (float)updateCurrentBeautyValueWithModel:(EFDataSourceModel *)model
                                     value:(float)value{
    NSArray * specialTypes = [EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1].efSpecialTypes;
    NSArray *sepcialNames = [EFStatusManager sharedInstanceWith:EFStatusManagerSingletonMode1].efSpecial3DNames;
    NSUInteger realType = model.efType >> 5;
    if ([specialTypes containsObject:@(realType)] || (realType == 801 && [sepcialNames containsObject:model.efName])) {
        return value*200.0 - 100.0;
    } else {
        return value*100.0;
    }
}

-(UISegmentedControl *)segment {
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[
            NSLocalizedString(@"嘴巴", nil),
            NSLocalizedString(@"鼻子", nil),
            NSLocalizedString(@"眼睛", nil),
            NSLocalizedString(@"脸部", nil)]
        ];
        _segment.tintColor = UIColor.lightGrayColor;
        [_segment addTarget:self action:@selector(onSegmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segment];
    }
    return _segment;
}

-(void)onSegmentControlValueChanged:(UISegmentedControl *)sender {
    NSInteger currentMode = sender.selectedSegmentIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.efType & %lu) == %lu", 0b111, currentMode];
    NSArray<EFDataSourceModel *> *filterModels = [self.dataSource filteredArrayUsingPredicate:predicate];
    NSInteger location = [self.dataSource indexOfObject:filterModels.firstObject];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:location inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

@end
