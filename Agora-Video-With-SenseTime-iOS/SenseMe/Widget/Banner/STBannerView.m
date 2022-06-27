//
//  STBannerView.m
//  SenseMeEffects
//
//  Created by zhangbaoshan on 2021/6/1.
//

#import "STBannerView.h"
#import "STBannerCell.h"

@interface STBannerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger page;

@end


@implementation STBannerView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 1;
        self.interval = 3;
        self.pageStyle = pageStyleMiddle;
        [self addSubviews];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)image {
    self = [super init];
    if (self) {
        [self configBanner:image];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)image {
    self = [super initWithFrame:frame];
    if (self) {
        self.page = 1;
        self.interval = 3;
        self.pageStyle = pageStyleMiddle;
        [self addSubviews];
        [self configBanner:image];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}


- (void)configBanner:(NSArray<UIImage *> *)image {
    [self.dataArray removeAllObjects];
    [self removeTimer];
    if (image.count == 0) {
        [self.collectionView reloadData];
        return;
    }
    if (image.count == 1) {
        [self.dataArray addObjectsFromArray:image];
    } else {
        [self.dataArray addObject:image.lastObject];
        [self.dataArray addObjectsFromArray:image];
        [self.dataArray addObject:image.firstObject];
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
        self.pageControl.numberOfPages = image.count;
        self.pageControl.currentPage = 0;
        [self makeConstraintForPageControlWithPageStyle:self.pageStyle];
        [self addTimer];
    }
    [self.collectionView reloadData];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    [self makeConstraintForPageControlWithPageStyle:self.pageStyle];
    if (self.dataArray.count > 1) {
        [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    }
    [self.collectionView reloadData];
}

- (void)run {
    if (self.dataArray.count  > 1) {
        [self addTimer];
    }
}

- (void)stop {
    [self removeTimer];
}

#pragma mark - private
- (void)makeConstraintForPageControlWithPageStyle:(BannerViewPageStyle)pageStyle {
    
    float interval = 15;
    switch (pageStyle) {
        case pageStyleLeft:
            _pageControl.frame = CGRectMake(10, self.bounds.size.height - 40, self.dataArray.count * interval, 50);
            break;
        case pageStyleMiddle:
            if (@available(iOS 14.0, *)) {
                _pageControl.frame = CGRectMake(0, self.bounds.size.height - 40, SCREEN_W, 50);
                
            }else {
                _pageControl.frame = CGRectMake((self.bounds.size.width - self.dataArray.count * interval) / 2 , self.bounds.size.height - 40, self.dataArray.count * interval, 50);
            }
            
            break;
        case pageStyleRight:
            _pageControl.frame = CGRectMake(self.bounds.size.width - 10 - self.dataArray.count * interval, self.bounds.size.height - 40, self.dataArray.count * interval, 50);
            break;
    }
}

#pragma mark - timer

- (void)addTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(bannerRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)bannerRun {
    _page++;
    [self.collectionView setContentOffset:CGPointMake(_page * self.bounds.size.width, 0) animated:YES];
    if (_page == self.dataArray.count - 1) {
        _page = 1;
    }
}

#pragma mark - collectionView delegate and dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STBannerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STBannerCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        UIImage *image = self.dataArray[indexPath.row];
        [cell configCellWithImage:image];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    if (index == 0) {
        index = self.dataArray.count - 3;
    } else if (index == self.dataArray.count - 1) {
        index = 0;
    } else {
        index -= 1;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:didSelectAtIndex:)]) {
        [self.delegate bannerView:self didSelectAtIndex:index];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.collectionView) {
        if (self.dataArray.count > 1) {
            _page = self.collectionView.contentOffset.x / self.bounds.size.width;
            if (self.collectionView.contentOffset.x == 0) {
                _pageControl.currentPage = self.dataArray.count - 3;
                [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width * (self.dataArray.count - 2), 0)];
            } else if (self.collectionView.contentOffset.x == self.bounds.size.width * (self.dataArray.count - 1)) {
                _pageControl.currentPage = 0;
                [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
            } else if (self.collectionView.contentOffset.x == self.bounds.size.width * _page) {
                _pageControl.currentPage = _page - 1;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self addTimer];
}

#pragma mark - setter and getter

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.bounces = NO;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [collectionView registerClass:[STBannerCell class] forCellWithReuseIdentifier:@"STBannerCell"];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl * pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.9];
        pageControl.currentPageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setPageStyle:(BannerViewPageStyle)pageStyle {
    _pageStyle = pageStyle;
    [self makeConstraintForPageControlWithPageStyle:pageStyle];
}


- (void)setPageTintColor:(UIColor *)pageTintColor {
    _pageTintColor = pageTintColor;
    self.pageControl.pageIndicatorTintColor = pageTintColor;
}

- (void)setCurrentPageTintColor:(UIColor *)currentPageTintColor {
    _currentPageTintColor = currentPageTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageTintColor;
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval = interval;
    if (self.dataArray.count > 0) {
        [self removeTimer];
        [self addTimer];
    }
}


@end
