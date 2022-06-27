//
//  EFStyleViewLayout.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/17.
//  Copyright © 2021 SenseTime. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import "EFStyleViewLayout.h"

@interface EFStyleViewLayout ()

//列
@property (nonatomic, assign) NSInteger columnCount;

//列间距
@property (nonatomic, assign) NSInteger columnSpace;

//行间距
@property (nonatomic, assign) NSInteger rowSpace;

//section内容内边距
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@property (nonatomic , assign) CGFloat contentX;

//布局属性数组
@property (nonatomic, strong) NSMutableArray * attributesArray;

@end

@implementation EFStyleViewLayout

- (instancetype)init{
    if (self = [super init]) {
        self.needScale = YES;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

static CGFloat const ActiveDistance = 50;
static CGFloat const ScaleFactor = 0.2;
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    if (!_needScale) {
        return array;
    }
    CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            CGFloat normalizedDistance = distance / ActiveDistance;
            
            if (ABS(distance) < ActiveDistance) {
                CGFloat zoom = 1 + ScaleFactor * (1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
                attributes.alpha = 1.0;
            }
        }
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat centerX = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    for (UICollectionViewLayoutAttributes *layoutAttr in array) {
        CGFloat itemCenterX = layoutAttr.center.x;
        if (ABS(itemCenterX - centerX) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemCenterX - centerX;
        }
    }
    CGPoint point = CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    return point;
}


@end
