//
//  STBannerView.h
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/1.
//

#import <UIKit/UIKit.h>
@class STBannerView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, BannerViewPageStyle) {
    pageStyleLeft = 0,  // 左边
    pageStyleMiddle,    // 中间
    pageStyleRight      // 右边
};

@protocol STBannerViewDelegate <NSObject>

@optional
// 点击图片
- (void)bannerView:(STBannerView *)bannerView didSelectAtIndex:(NSInteger)index;

@end


@interface STBannerView : UIView

@property (nonatomic, weak) id<STBannerViewDelegate> delegate;


//pageControl 位置样式
@property (nonatomic, assign) BannerViewPageStyle pageStyle;

//pageControl 未选中圆点颜色
@property (nonatomic, strong) UIColor *pageTintColor;

//pageControl 选中圆点颜色
@property (nonatomic, strong) UIColor *currentPageTintColor;

//轮播时间
@property (nonatomic, assign) NSTimeInterval interval;

//构造方法
- (instancetype)initWithImages:(NSArray <UIImage *> *)image;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *> *)image;


- (void)configBanner: (NSArray <UIImage *>*)image;


@end

NS_ASSUME_NONNULL_END
