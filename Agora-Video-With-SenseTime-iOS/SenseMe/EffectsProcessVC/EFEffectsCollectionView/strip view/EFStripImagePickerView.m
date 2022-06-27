//
//  EFStripImagePickerView.m
//  SenseMeEffects
//
//  Created by 马浩萌 on 2021/11/9.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#import "EFStripImagePickerView.h"
#import "EFStripImagePickerCollectionViewCell.h"
#import "HXPhotoPicker.h"
#import "HXAssetManager.h"
#import "NSBundle+language.h"
#import "EFStripImagePickerAlbumButton.h"
@import Photos;

static NSString * const EFStripImagePickerView_cellReuseIdentifier = @"EFStripImagePickerView_cellReuseIdentifier";

@interface EFStripImagePickerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UICollectionView *stripCollectionView;

@end

@implementation EFStripImagePickerView
{
    NSArray *_imageList;
    NSIndexPath *_selecteIndexPath;
    NSArray *_defaultImageList;
    
    PHChange *_lastChangeInfo;
    HXPhotoModel *_currentModel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageList = [NSArray array];
        [self _customUI];
        [self loadDefaultImages];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self hh_datasource];
        });
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        _selecteIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

-(void)loadDefaultImages {
    NSMutableArray *defaultImages = [NSMutableArray array];
    int i = 0;
    for (int j = 0; j < 4; j ++) {
        UIImage *currentImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"image_background_default_%d", i ++] ofType:@"png"]];
        if (currentImage) {
            [defaultImages addObject:currentImage];
        } else {
            break;
        }
    }
    _defaultImageList = [defaultImages copy];
    [self.stripCollectionView reloadData];
}

-(void)resetImageSelectedStatus {
    _selecteIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UIImage *image = _defaultImageList[_selecteIndexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(stripImagePickerView:selectedImage:)]) {
        [self.delegate stripImagePickerView:self selectedImage:image];
    }
    
    _currentModel = nil;
    [self.stripCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.stripCollectionView reloadData];
}

-(void)_customUI {
    
    EFStripImagePickerAlbumButton *albumButton = [[EFStripImagePickerAlbumButton alloc] initWithFrame:CGRectZero];
    [self addSubview:albumButton];
    
    [albumButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.equalTo(self);
        make.height.mas_equalTo(albumButton.mas_width);
    }];
    
    [albumButton addTarget:self action:@selector(onAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = RGBA(42, 42, 42, 0.8);
    self.layer.cornerRadius = 12.0;
    self.clipsToBounds = YES;
    
    [self addSubview:self.stripCollectionView];
    [self.stripCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.leading.equalTo(albumButton.mas_trailing);
    }];
}

# pragma mark - collection view
-(UICollectionView *)stripCollectionView {
    if (!_stripCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(40, 40);
        
        _stripCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [_stripCollectionView registerClass:[EFStripImagePickerCollectionViewCell class] forCellWithReuseIdentifier:EFStripImagePickerView_cellReuseIdentifier];
        
        _stripCollectionView.showsHorizontalScrollIndicator = NO;
        _stripCollectionView.backgroundColor = UIColor.clearColor;
        
        _stripCollectionView.dataSource = self;
        _stripCollectionView.delegate = self;
    }
    return _stripCollectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _defaultImageList.count + _imageList.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EFStripImagePickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EFStripImagePickerView_cellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row < _defaultImageList.count) {
        cell.contentImageView.image = _defaultImageList[indexPath.row];
        cell.selectedBorderView.hidden = indexPath != _selecteIndexPath;
    } else {
        
        HXPhotoModel *model = _imageList[indexPath.row - _defaultImageList.count];
        cell.selectedBorderView.hidden = ![[model.asset valueForKey:@"filename"] isEqualToString: [_currentModel.asset valueForKey:@"filename"]];
        [model requestThumbImageCompletion:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
            cell.contentImageView.image = image;
        }];
    }
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == _selecteIndexPath) {
        [self resetImageSelectedStatus];
        return;
    }
    if (indexPath.row < _defaultImageList.count) {
        UIImage *image = _defaultImageList[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(stripImagePickerView:selectedImage:)]) {
            [self.delegate stripImagePickerView:self selectedImage:image];
        }
        _currentModel = nil;
    } else {
        HXPhotoModel *model = _imageList[indexPath.row  - _defaultImageList.count];
        [self _imagePickEndCallback:model];
    }
    _selecteIndexPath = indexPath;
    [collectionView reloadData];
}

-(void)hh_datasource {
    HXPhotoManager *photoManager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
    photoManager.configuration.reverseDate = YES;
    photoManager.configuration.openCamera = NO;
    [photoManager getCameraRollAlbumCompletion:^(HXAlbumModel *albumModel) {
        [photoManager getPhotoListWithAlbumModel:albumModel complete:^(NSMutableArray * _Nullable allList, NSMutableArray * _Nullable previewList, NSUInteger photoCount, NSUInteger videoCount, HXPhotoModel * _Nullable firstSelectModel, HXAlbumModel * _Nullable albumModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_imageList = allList;
                [self.stripCollectionView reloadData];
            });
        }];
    }];
}

#pragma mark - album actions
-(void)onAlbumButtonClick:(UIButton *)sender {
    HXPhotoManager *photoManager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
    photoManager.configuration.type = HXConfigurationTypeWXMoment;
    photoManager.configuration.photoMaxNum = 1;
    photoManager.configuration.hideOriginalBtn = YES;
    photoManager.configuration.photoEditConfigur.aspectRatio = HXPhotoEditAspectRatioType_None;
    photoManager.configuration.openCamera = NO;
    
    NSString *language = [NSBundle currentLanguage];
    if ([language hasPrefix:@"zh-Hans"] || language == nil) {
        photoManager.configuration.languageType = HXPhotoLanguageTypeSc;
    }
    if ([language hasPrefix:@"en"]) {
        photoManager.configuration.languageType = HXPhotoLanguageTypeEn;
    }
    
    UIViewController *currentViewController = [self _getViewsCurrentViewController:sender];
    [currentViewController hx_presentSelectPhotoControllerWithManager:photoManager didDone:^(NSArray<HXPhotoModel *> * _Nullable allList, NSArray<HXPhotoModel *> * _Nullable photoList, NSArray<HXPhotoModel *> * _Nullable videoList, BOOL isOriginal, UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _imagePickEndCallback:photoList[0]];
            [self _collectionViewScrollToModel:photoList[0]];
        });
    } cancel:^(UIViewController * _Nullable viewController, HXPhotoManager * _Nullable manager) {
    }];
}

-(void)_imagePickEndCallback:(HXPhotoModel *)imageModel {
    _currentModel = imageModel;
    UIImage *image = [HXAssetManager originImageForAsset:imageModel.asset];
    if (self.delegate && [self.delegate respondsToSelector:@selector(stripImagePickerView:selectedImage:)]) {
        [self.delegate stripImagePickerView:self selectedImage:image];
    }
}

-(void)_collectionViewScrollToModel:(HXPhotoModel *)imageModel {
    if (imageModel.currentIndexPath.row >= _imageList.count) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:imageModel.currentIndexPath.row + _defaultImageList.count inSection:0];
    [self.stripCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    _selecteIndexPath = indexPath;
    [self.stripCollectionView reloadData];
}

-(UIViewController *)_getViewsCurrentViewController:(UIView *)targetView {
    UIResponder *nextResponder = targetView.nextResponder;
    if (!nextResponder) {
        return nil;
    } else {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        } else {
            return [self _getViewsCurrentViewController:(UIView *)nextResponder];
        }
    }
}

#pragma mark - PHPhotoLibraryChangeObserver & after photo library changed
- (void)photoLibraryDidChange:(PHChange *)changeInfo {
    if (changeInfo == _lastChangeInfo) {
        return;
    }
    _lastChangeInfo = changeInfo;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self hh_datasource];
    });
}

@end
