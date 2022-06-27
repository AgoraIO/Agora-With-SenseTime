//
//  EFTryOnLipsAndHairView.m
//  SenseMeEffects
//
//  Created by sensetimesunjian on 2021/8/18.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFTryOnLipsAndHairView.h"
#import "EFTryOnBeautyCollectionViewCell.h"
#import "EFTryOnLipsColorStrengthView.h"
#import "NSObject+dictionary.h"
#import "EFTryOnLipsColorStrengthView.h"
#import "EFTryOnColorWheelView.h"

@interface EFTryOnLipsAndHairView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EFTryOnLipsColorStrengthViewDelegate>

@property (nonatomic, strong) EFTryOnLipsColorStrengthView *strengthView;

@property (nonatomic, strong) UIButton *styleButton;
@property (nonatomic, strong) UILabel *styleLabel;

@property (nonatomic, strong) UIButton *colorButton;
@property (nonatomic, strong) UILabel *colorLabel;

@property (nonatomic, strong) UICollectionView *contentCollectionView;

@property (nonatomic, strong) NSArray<id<TryOnItemInterface>> *styleDefaultItems; // 无
@property (nonatomic, strong) NSArray<id<TryOnItemInterface>> *colorDefaultItems; // 无 + 颜色

@end

@implementation EFTryOnLipsAndHairView
{
    //    UIButton * _currentSelectedButton;
    //    UILabel * _currentSelectedTitleLabel;
    //
    //    NSInteger _currentIndex; // 质地0 or 颜色1
    //
    //    NSIndexPath * _selectedIndexPath1;
    //    NSIndexPath * _selectedIndexPath2;
}

-(instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self customSubViews];
    }
    return self;
}

-(void)setDataSource:(id<TryOnDataElementInterface>)dataSource {
    [self _beforeSetDataSource];
    _dataSource = dataSource;
    [self _afterSetDataSource];
}

-(void)_beforeSetDataSource {
    switch (self.dataSource.currentSelectedGroupType) {
        case TryOnGroupTypeColor:
            self.dataSource.colors.contentOffset = self.contentCollectionView.contentOffset;
            break;
        default:
            self.dataSource.styles.contentOffset = self.contentCollectionView.contentOffset;
            break;
    }
}

-(void)_afterSetDataSource {
    [self.contentCollectionView reloadData];
    [self.colorButton setImage:[UIImage imageNamed:self.dataSource.colors.imageName] forState:UIControlStateNormal];
    [self.colorButton setImage:[UIImage imageNamed:self.dataSource.colors.highLightImageName] forState:UIControlStateSelected];
    self.colorLabel.text = NSLocalizedString(self.dataSource.colors.name, nil);
    
    if (self.dataSource.styles) { // 有材质的类型（口红、唇线）
        [self.styleButton setImage:[UIImage imageNamed:self.dataSource.styles.imageName] forState:UIControlStateNormal];
        [self.styleButton setImage:[UIImage imageNamed:self.dataSource.styles.highLightImageName] forState:UIControlStateSelected];
        self.styleLabel.text = NSLocalizedString(self.dataSource.styles.name, nil);
        
        [self.styleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.height.width.equalTo(@40);
            make.bottom.equalTo(self).offset(-40);
        }];
        [self.colorButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.styleButton.mas_trailing);
            make.centerY.equalTo(self.styleButton);
            make.height.width.equalTo(@40);
        }];
    } else {
        self.styleButton.hidden = YES;
        [self.colorButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.height.width.equalTo(@40);
            make.bottom.equalTo(self).offset(-40);
        }];
    }
    
    self.styleButton.hidden = self.dataSource.styles == nil;
    self.styleLabel.hidden = self.dataSource.styles == nil;
    
    self.colorButton.selected = self.dataSource.currentSelectedGroupType == TryOnGroupTypeColor;
    self.styleButton.selected = self.dataSource.currentSelectedGroupType == TryOnGroupTypeStyle;
    
    switch (self.dataSource.currentSelectedGroupType) {
        case TryOnGroupTypeColor:
            self.contentCollectionView.contentOffset = self.dataSource.colors.contentOffset;
            break;
        default:
            self.contentCollectionView.contentOffset = self.dataSource.styles.contentOffset;
            break;
    }
    
    [self _afterColorResourceMaterialSelected];
}

-(void)customSubViews {
    self.styleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.styleButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.styleButton setImage:[UIImage imageNamed:@"tryon_color"] forState:UIControlStateNormal];
    [self.styleButton setImage:[UIImage imageNamed:@"tryon_color"] forState:UIControlStateSelected];
    [self.styleButton addTarget:self action:@selector(onStyleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.styleButton];
    
    [self.styleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.height.width.equalTo(@40);
        make.bottom.equalTo(self).offset(-40);
    }];
    self.styleLabel = [[UILabel alloc] init];
    self.styleLabel.text = NSLocalizedString(@"颜色", nil);
    [self.styleLabel setHighlightedTextColor:UIColor.lightGrayColor];
    self.styleLabel.font = [UIFont systemFontOfSize:12];
    self.styleLabel.textColor = RGBA(82, 82, 82, 1);
    self.styleLabel.highlighted = YES;
    [self addSubview:self.styleLabel];
    
    [self.styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.styleButton);
        make.top.equalTo(self.styleButton.mas_bottom).inset(5);
    }];
    
    self.colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.colorButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.colorButton setImage:[UIImage imageNamed:@"tryon_color"] forState:UIControlStateNormal];
    [self.colorButton setImage:[UIImage imageNamed:@"tryon_color"] forState:UIControlStateSelected];
    [self.colorButton addTarget:self action:@selector(onColorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.colorButton];
    
    [self.colorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.styleButton.mas_trailing);
        make.centerY.equalTo(self.styleButton);
        make.height.width.equalTo(@40);
    }];
    
    self.colorLabel = [[UILabel alloc] init];
    self.colorLabel.text = NSLocalizedString(@"颜色", nil);
    [self.colorLabel setHighlightedTextColor:UIColor.lightGrayColor];
    self.colorLabel.font = [UIFont systemFontOfSize:12];
    self.colorLabel.textColor = RGBA(82, 82, 82, 1);
    self.colorLabel.highlighted = YES;
    [self addSubview:self.colorLabel];
    
    [self.colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.colorButton);
        make.top.equalTo(self.colorButton.mas_bottom).inset(5);
    }];
    
    UIView * splitView = [[UIView alloc] init];
    splitView.backgroundColor = UIColor.lightGrayColor;
    [self addSubview:splitView];
    [splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.colorButton.mas_trailing).inset(10);
        make.centerY.equalTo(self.colorButton);
        make.width.equalTo(@1);
        make.height.equalTo(@20);
    }];
    
    [self addSubview:self.contentCollectionView];
    [self.contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(splitView.mas_trailing).inset(10);
        make.bottom.trailing.equalTo(self);
        make.height.equalTo(@90);
    }];
    
    self.strengthView = [[EFTryOnLipsColorStrengthView alloc] initWithFrame:CGRectZero];
    self.strengthView.delegate = self;
    self.strengthView.hidden = YES;
    [self addSubview:self.strengthView];
    [self.strengthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@44);
    }];
}

#pragma mark - actions
-(void)onStyleButtonClick:(UIButton *)sender {
    if (!self.dataSource.colors.currentIndexPath) {
        [self showToast];
        return;
    }
    [self _beforeSetDataSource];
    self.dataSource.currentSelectedGroupType = TryOnGroupTypeStyle;
    [self _afterSetDataSource];
}

-(void)onColorButtonClick:(UIButton *)sender {
    [self _beforeSetDataSource];
    self.dataSource.currentSelectedGroupType = TryOnGroupTypeColor;
    [self _afterSetDataSource];
}

-(void)showToast {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnLipsAndHairView:showToast:)]) {
        [self.delegate tryOnLipsAndHairView:self showToast:@"请先选择颜色"];
    }
}

-(void)showColorWheelView:(BOOL)isShow {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:isShowColorWheel:andDatasource:)]) {
        [self.delegate tryOnView:self isShowColorWheel:isShow andDatasource:self.dataSource];
    }
}

#pragma mark - properties
- (UICollectionView *)contentCollectionView {
    if (!_contentCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _contentCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.pagingEnabled = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.backgroundColor = [UIColor clearColor];
        [_contentCollectionView registerClass:[EFTryOnBeautyCollectionViewCell class] forCellWithReuseIdentifier:@"EFTryOnBeautyCollectionViewCell"];
        
    }
    return _contentCollectionView;
}

-(NSArray<id<TryOnItemInterface>> *)styleDefaultItems {
    if (!_styleDefaultItems) {
        TryOnItem *noneModel = [[TryOnItem alloc] init];
        noneModel.name = NSLocalizedString(@"无", nil);
        noneModel.imageName = @"tryon_None";
        _styleDefaultItems = @[noneModel];
    }
    return _styleDefaultItems;
}

-(NSArray<id<TryOnItemInterface>> *)colorDefaultItems {
    if (!_colorDefaultItems) {
        TryOnItem *noneModel = [[TryOnItem alloc] init];
        noneModel.name = NSLocalizedString(@"无", nil);
        noneModel.imageName = @"tryon_None";
        
        TryOnItem *colorModel = [[TryOnItem alloc] init];
        colorModel.name = NSLocalizedString(@"颜色", nil);
        colorModel.imageName = @"tryon_tinting";
        
        _colorDefaultItems = @[noneModel, colorModel];
    }
    return _colorDefaultItems;
}

#pragma mark - collection view Delegate&DataDource
- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(64, self.contentCollectionView.bounds.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.dataSource.currentSelectedGroupType) {
        case TryOnGroupTypeColor:
            return self.colorDefaultItems.count + self.dataSource.colors.materialGroup.materialsArray.count;
        default:
            return self.styleDefaultItems.count + self.dataSource.styles.items.count;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TryOnItem *model;
    BOOL isSelected;
    EFMaterialDownloadStatus downloadStatus = EFMaterialDownloadStatusNotDownload;
    switch (self.dataSource.currentSelectedGroupType) {
        case TryOnGroupTypeColor: {
            isSelected = [self.dataSource.colors.currentIndexPath isEqual:indexPath];
            if (indexPath.row < 2) {
                model = (TryOnItem *)self.colorDefaultItems[indexPath.row];
            } else {
                SenseArMaterial *material = self.dataSource.colors.materialGroup.materialsArray[indexPath.row - self.colorDefaultItems.count];
                model = [[TryOnItem alloc] init];
                model.name = material.strName;
                model.imageName = material.strThumbnailURL;
                EFDataSourceMaterialModel *downloadModel = [EFDataSourceMaterialModel yy_modelWithDictionary:[material efDictionaryValue]];
                downloadStatus = [[EFMaterialDownloadStatusManager sharedInstance] efDownloadStatus:downloadModel];
            }
        }
            break;
            
        default: {
            isSelected = [self.dataSource.styles.currentIndexPath isEqual:indexPath];
            if (indexPath.row < 1) {
                model = (TryOnItem *)self.styleDefaultItems[indexPath.row];
            } else {
                model = (TryOnItem *)self.dataSource.styles.items[indexPath.row - self.styleDefaultItems.count];
            }
        }
            break;
    }
    
    EFTryOnBeautyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EFTryOnBeautyCollectionViewCell" forIndexPath:indexPath];
    [cell config:model status:downloadStatus select:isSelected];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.dataSource.currentSelectedGroupType) {
        case TryOnGroupTypeColor: // 选择颜色
            if (indexPath.row == 0) { // 无
                self.dataSource.colors.currentIndexPath = nil;
                [self _onCancelTryOnBeautyType:self.dataSource.tryOnBeautyType];
            } else if (indexPath.row == 1) { // 颜色选择
                if (!self.dataSource.colors.currentIndexPath) {
                    [self showToast];
                    return;
                }
                [self showColorWheelView:YES];
            } else {
                if (self.dataSource.colors.currentIndexPath == indexPath) return;
                SenseArMaterial *material = self.dataSource.colors.materialGroup.materialsArray[indexPath.row - self.colorDefaultItems.count];
                if (material.strMaterialPath) {
                    self.dataSource.colors.currentIndexPath = indexPath;
                    [collectionView reloadData];
                    [self _onColorResourceMaterial:material clickWithBeautyType:self.dataSource.tryOnBeautyType];
                    return;
                }
                EFDataSourceMaterialModel *downloadModel = [EFDataSourceMaterialModel yy_modelWithDictionary:[material efDictionaryValue]];
                EFMaterialDownloadStatusManager *materialDownloadManager = [EFMaterialDownloadStatusManager sharedInstance];
                [materialDownloadManager efStartDownloadTryOn:downloadModel onProgress:nil onSuccess:^(SenseArMaterial *material) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.dataSource.colors.currentIndexPath = indexPath;
                        [collectionView reloadData];
                        [self _onColorResourceMaterial:material clickWithBeautyType:self.dataSource.tryOnBeautyType];
                    });
                } onFailure:nil];
            }
            break;
            
        default: // 选择质地等
            if (indexPath.row == 0) { // 无
                self.dataSource.styles.currentIndexPath = nil;
            } else {
                self.dataSource.styles.currentIndexPath = indexPath;
            }
            [self _onStyleChanged];
            break;
    }
    [collectionView reloadData];
}

#pragma mark - sdk call
/// 选中了try on效果（素材包）
/// @param material 素材包model
/// @param beautyType try on类型
-(void)_onColorResourceMaterial:(SenseArMaterial *)material clickWithBeautyType:(st_effect_beauty_type_t)beautyType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:selectedMaterial:andBeautyType:andDataSource:)]) {
        [self.delegate tryOnView:self selectedMaterial:material andBeautyType:beautyType andDataSource:self.dataSource];
        
        [self _afterColorResourceMaterialSelected];
    }
}

/// 素材包发生变化后更新ui
-(void)_afterColorResourceMaterialSelected {
    if (self.dataSource.tryonInfo) {
        self.strengthView.hidden = NO;
        if (self.dataSource.currentSelectedGroupType == TryOnGroupTypeColor) {
            self.strengthView.title = @"强度";
            self.strengthView.value = self.dataSource.tryonInfo -> strength;
        } else {
            self.strengthView.title = @"光泽度";
            self.strengthView.value = self.dataSource.tryonInfo -> highlight;
        }
    } else {
        self.strengthView.hidden = YES;
    }
}

/// 取消try on效果
/// @param beautyType try on type
-(void)_onCancelTryOnBeautyType:(st_effect_beauty_type_t)beautyType {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:cancelTryOnBeautyType:andDataSource:)]) {
        [self.delegate tryOnView:self cancelTryOnBeautyType:beautyType andDataSource:self.dataSource];
        
        [self _afterColorResourceMaterialSelected];
    }
}

/// 选中/取消了质地
-(void)_onStyleChanged {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:updateTryOnInfo:withBeautyType:)]) {
        NSInteger idx = self.dataSource.styles.currentIndexPath ? self.dataSource.styles.currentIndexPath.row  - self.styleDefaultItems.count : 0;
        TryOnItem *tryonItem = (TryOnItem *)self.dataSource.styles.items[idx];
        self.dataSource.tryonInfo -> lip_finish_type = tryonItem.type;
        [self.delegate tryOnView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

#pragma mark - EFTryOnLipsColorStrengthViewDelegate
-(void)tryOnLipsColorStrengthView:(EFTryOnLipsColorStrengthView *)tryOnLipsColorStrengthView sliderValueChanged:(CGFloat)value {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tryOnView:updateTryOnInfo:withBeautyType:)]) {
        if (self.dataSource.currentSelectedGroupType == TryOnGroupTypeColor) { // 颜色强度发生改变
            self.dataSource.tryonInfo -> strength = value;
        } else { // 材质光泽度发生变化
            self.dataSource.tryonInfo -> highlight = value;
        }
        [self.delegate tryOnView:self updateTryOnInfo:self.dataSource.tryonInfo withBeautyType:self.dataSource.tryOnBeautyType];
    }
}

@end
