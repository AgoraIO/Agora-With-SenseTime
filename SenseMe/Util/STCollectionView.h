//
//  STCollectionView.h
//
//  Created by HaifengMay on 16/11/8.
//  Copyright © 2016年 SenseTime. All rights reserved.
//

/*
 * 用于显示sticker
 */

#import <UIKit/UIKit.h>
#import "STParamUtil.h"

@interface STCollectionViewDisplayModel : NSObject

@property (nonatomic, copy) NSString *strPath;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *strName;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, readwrite, assign) STEffectsType modelType;

@end

@class STNewBeautyCollectionViewModel;

typedef void(^STCollectionViewDelegateBlock)(STCollectionViewDisplayModel *model);
typedef void(^STNewBeautyCollectionViewDelegateBlock)(STNewBeautyCollectionViewModel *model);
STNewBeautyCollectionViewModel *getModel(UIImage *normalImage, UIImage *highlightImage, NSString *title, int beautyValue, BOOL selected, int modelIndex, STEffectsType modelType, STBeautyType beautyType);

@interface STCollectionView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <STCollectionViewDisplayModel *> *) arrModels andDelegateBlock:(STCollectionViewDelegateBlock) delegateBlock;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray <STCollectionViewDisplayModel *> *arrModels;

@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arr2DModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arr3DModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arrGestureModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arrSegmentModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arrFaceDeformationModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arrFilterModels;
@property (nonatomic, readwrite, strong) NSArray<STCollectionViewDisplayModel *> *arrObjectTrackModels;

@property (nonatomic, readwrite, strong) STCollectionViewDisplayModel *selectedModel;

@end

@interface STFilterCollectionView: UICollectionView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) STCollectionViewDisplayModel *selectedModel;
@property (nonatomic, assign) STEffectsType preSelectedType;
@property (nonatomic, strong) NSArray<STCollectionViewDisplayModel *> *arrModels;

@property (nonatomic, copy) STCollectionViewDelegateBlock delegateBlock;

@property (nonatomic, strong) NSArray<STCollectionViewDisplayModel *> *arrPortraitFilterModels;
@property (nonatomic, strong) NSArray<STCollectionViewDisplayModel *> *arrSceneryFilterModels;
@property (nonatomic, strong) NSArray<STCollectionViewDisplayModel *> *arrStillLifeFilterModels;
@property (nonatomic, strong) NSArray<STCollectionViewDisplayModel *> *arrDeliciousFoodFilterModels;

- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray<STCollectionViewDisplayModel *> *)arrModels andDelegateBlock:(STCollectionViewDelegateBlock)delegateBlock;

@end

@interface STNewBeautyCollectionViewModel : NSObject

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int beautyValue;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) int modelIndex;
@property (nonatomic, assign) STEffectsType modelType;
@property (nonatomic, assign) STBeautyType beautyType;

@end

@interface STNewBeautyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, assign) BOOL highlight;
@property (nonatomic, strong) STNewBeautyCollectionViewModel *model;

@end

@interface STNewBeautyCollectionView : UICollectionView

@property (nonatomic, strong) NSArray<STNewBeautyCollectionViewModel *> *models;

@property (nonatomic, strong) STNewBeautyCollectionViewModel *selectedModel;

- (instancetype)initWithFrame:(CGRect)frame
                       models:(NSArray<STNewBeautyCollectionViewModel *> *)models
                delegateBlock:(STNewBeautyCollectionViewDelegateBlock)block;

@end
