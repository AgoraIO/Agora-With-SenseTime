//
//  STStickersCollectionView.m
//
//  Created by HaifengMay on 16/11/8.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

#import "STCollectionView.h"
#import "STCollectionViewCell.h"

@implementation STCollectionViewDisplayModel

@end

@interface STCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) STCollectionViewDelegateBlock delegateBlock;

@end

@implementation STCollectionView

- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <STCollectionViewDisplayModel *> *) arrModels andDelegateBlock:(STCollectionViewDelegateBlock) delegateBlock
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 30);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.alwaysBounceVertical = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.arrModels = [arrModels copy];
        self.delegateBlock = delegateBlock;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[STCollectionViewCell class] forCellWithReuseIdentifier:@"STCollectionViewCell"];
        [self registerClass:[STCollectionLabelCell class] forCellWithReuseIdentifier:@"STCollectionLabelCell"];
    }
    return self;
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arrModels.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"STCollectionViewCell" forIndexPath:indexPath];
    
    STCollectionViewDisplayModel *model = self.arrModels[indexPath.row];
    cell.imageView.image = model.image;
//    cell.maskView.layer.borderColor = model.isSelected ? UIColorFromRGB(0xb036f5).CGColor : [UIColor clearColor].CGColor;
    cell.layer.borderColor = model.isSelected ? UIColorFromRGB(0xb036f5).CGColor : [UIColor clearColor].CGColor;
//    cell.maskView.hidden = !(model.isSelected);
    cell.maskView.hidden = YES;
    return cell;
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedModel) {
        self.selectedModel.isSelected = NO;
    }
    
    if (self.arrModels[indexPath.row].modelType == self.selectedModel.modelType
        && self.arrModels[indexPath.row].index == self.selectedModel.index) {
        self.selectedModel = nil;
    } else {
        self.arrModels[indexPath.row].isSelected = YES;
        self.selectedModel = self.arrModels[indexPath.row];
    }
    
    [collectionView reloadData];
    
    if (self.delegateBlock) {
        
        self.delegateBlock(self.arrModels[indexPath.row]);
    }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition
{
    [super selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    
    [self collectionView:self didSelectItemAtIndexPath:indexPath];
}

@end

@interface STFilterCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation STFilterCollectionView

- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray<STCollectionViewDisplayModel *> *)arrModels andDelegateBlock:(STCollectionViewDelegateBlock)delegateBlock {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(65, 90);
    flowLayout.minimumInteritemSpacing = 180;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(-10, 5, 5, 5);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        self.preSelectedType = STEffectsTypeNone;
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.arrModels = [arrModels copy];
        self.delegateBlock = delegateBlock;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[STCollectionLabelCell class] forCellWithReuseIdentifier:@"STCollectionLabelCell"];
    }
    return self;
}

#pragma mark - dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrModels.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STCollectionLabelCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"STCollectionLabelCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    STCollectionViewDisplayModel *model = self.arrModels[indexPath.row];
    cell.imageView.image = model.image;
    cell.lblName.text = model.strName;
    cell.maskContainerView.hidden = !(model.isSelected);
    cell.imageMaskView.hidden = !(model.isSelected);
    cell.lblMaskView.hidden = !(model.isSelected);
    cell.lblName.highlighted = model.isSelected;
    
    return cell;
}

#pragma mark - delegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedModel) {
        self.selectedModel.isSelected = NO;
    }
    self.arrModels[indexPath.row].isSelected = YES;
    
    self.selectedModel = self.arrModels[indexPath.row];
    [collectionView reloadData];
    
    if (self.delegateBlock) {
        self.delegateBlock(self.arrModels[indexPath.row]);
    }
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    
    [super selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
    
    [self collectionView:self didSelectItemAtIndexPath:indexPath];
}

@end

@implementation STNewBeautyCollectionViewModel

@end

@interface STNewBeautyCollectionViewCell ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation STNewBeautyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = [UIColor greenColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, frame.size.width - 20, 76)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 76 + 24, frame.size.width, 18)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:13.0];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 7.5, 76 + 24 + 25, 15, 15)];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        _valueLabel.font = [UIFont systemFontOfSize:9.0];
        _valueLabel.layer.cornerRadius = 7.5;
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = _valueLabel.frame;
        _shapeLayer.strokeColor = UIColorFromRGB(0xffffff).CGColor;
        _shapeLayer.fillColor = nil;
        _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:_valueLabel.bounds cornerRadius:7.5].CGPath;
        _shapeLayer.lineWidth = 1;
        _shapeLayer.lineDashPattern = @[@4, @2];
        
        [self.layer addSublayer:_shapeLayer];
        
        [self addSubview:_imageView];
        [self addSubview:_nameLabel];
        [self addSubview:_valueLabel];
    }
    return self;
}

- (void)setHighlight:(BOOL)highlight {
    
    UIColor *color = highlight ? UIColorFromRGB(0xbc47ff) : UIColorFromRGB(0xffffff);
    
    _nameLabel.textColor = color;
    _valueLabel.textColor = color;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _shapeLayer.strokeColor = color.CGColor;
    [CATransaction commit];
    
    _imageView.image = highlight? self.model.highlightedImage : self.model.normalImage;
}

@end

@interface STNewBeautyCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) STNewBeautyCollectionViewDelegateBlock block;
@property (nonatomic) NSIndexPath *preIndexPath;

@end

@implementation STNewBeautyCollectionView

- (instancetype)initWithFrame:(CGRect)frame
                       models:(NSArray<STNewBeautyCollectionViewModel *> *)models
                delegateBlock:(STNewBeautyCollectionViewDelegateBlock)block {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(70, 150);
    flowLayout.minimumInteritemSpacing = 50;
    flowLayout.minimumLineSpacing = 30;
    flowLayout.sectionInset = UIEdgeInsetsMake(-100, 20, 0, 20);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.models = models;
        self.block = block;
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[STNewBeautyCollectionViewCell class] forCellWithReuseIdentifier:@"STNewBeautyCollectionViewCell"];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STNewBeautyCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"STNewBeautyCollectionViewCell" forIndexPath:indexPath];
    
    STNewBeautyCollectionViewModel *model = self.models[indexPath.row];
    
    cell.model = model;
    cell.highlight = model.selected;
    
    cell.imageView.image = model.selected ? model.highlightedImage : model.normalImage;
    cell.nameLabel.text = model.title;
    cell.valueLabel.text = [NSString stringWithFormat:@"%d", model.beautyValue];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (!_selectedModel) {
        STNewBeautyCollectionViewCell *cell = (STNewBeautyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.highlight = YES;
        
        _selectedModel = self.models[indexPath.row];
        _selectedModel.selected = YES;
        
        if (self.block) {
            self.block(self.models[indexPath.row]);
        }
    }
    
    
    if (_selectedModel && _selectedModel.modelType == self.models[indexPath.row].modelType) {
        
        
        if (_selectedModel.modelIndex != self.models[indexPath.row].modelIndex) {
            
            _selectedModel.selected = NO;
            
            
            self.models[indexPath.row].selected = YES;
            
            
            [collectionView reloadItemsAtIndexPaths:@[
                                                      indexPath,
                                                      [NSIndexPath indexPathForRow:_selectedModel.modelIndex inSection:0]
                                                      ]];
            
            _selectedModel = self.models[indexPath.row];
            
            self.block(self.models[indexPath.row]);
            
            
        }
        
    } else {
        
        STNewBeautyCollectionViewCell *cell1 = (STNewBeautyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell1.highlight = YES;
        
        _selectedModel.selected = NO;
        
        self.models[indexPath.row].selected = YES;
        _selectedModel = self.models[indexPath.row];
        
        self.block(self.models[indexPath.row]);
        
    }
}

@end

STNewBeautyCollectionViewModel* getModel(UIImage *normalImage, UIImage *highlightImage, NSString *title, int beautyValue, BOOL selected, int modelIndex, STEffectsType modelType, STBeautyType beautyType) {

    STNewBeautyCollectionViewModel *model = [[STNewBeautyCollectionViewModel alloc] init];
    model.normalImage = normalImage;
    model.highlightedImage = highlightImage;
    model.title = title;
    model.beautyValue = beautyValue;
    model.selected = selected;
    model.modelIndex = modelIndex;
    model.modelType = modelType;
    model.beautyType = beautyType;

    return model;
}
