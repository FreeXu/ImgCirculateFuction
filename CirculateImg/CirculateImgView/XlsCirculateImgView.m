//
//  XlsCirculateImgView.m
//  CirculateImg
//
//  Created by 56tg on 2016/10/17.
//  Copyright © 2016年 56tg. All rights reserved.
//

#import "XlsCirculateImgView.h"

@interface XlsCirculateImgView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    KHSourceType imgSourceType;
    BOOL isShutScroll;
}
@property (nonatomic, weak)  UICollectionView *collectionView;
@property (nonatomic, weak)  UIPageControl *pageControl;
@property (nonatomic, weak)  UIView *bottomView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation XlsCirculateImgView

#pragma mark - Lazy load
- (UIView *)bottomView {
    if (!_bottomView ) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = self.bottomViewColor;
        view.alpha = self.alpha;
        [self addSubview:view];
        _bottomView = view;
        [self bringSubviewToFront:self.pageControl];
    }
    return _bottomView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageC = [[UIPageControl alloc]init];
        pageC.currentPage = 0;
        
        [self addSubview:pageC];
        _pageControl = pageC;
    }
    _pageControl.numberOfPages = self.dataSource.count;
    return _pageControl;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = NO;
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
        _collectionView.scrollEnabled = !isShutScroll; //关闭滑动
    }
    return _collectionView;
}

#pragma mark - set methods
- (void)setHideBottomView:(BOOL)hideBottomView {
    _hideBottomView = hideBottomView;
    self.bottomView.hidden = hideBottomView;
}

- (void)setHidePageControl:(BOOL)hidePageControl {
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}

- (void)setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    self.bottomView.alpha = alpha;
}

- (void)setIsAutoCircle:(BOOL)isAutoCircle {
    _isAutoCircle = isAutoCircle;
    if (_isAutoCircle && !isShutScroll) {
        [self timer];
    }
}

#pragma mark - init methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _timeInterval = 2.f;
    _bottomViewColor = [UIColor blackColor];
    _pageIndicatorTintColor = [UIColor whiteColor];
    _currentPageIndicatorTintColor = [UIColor redColor];
    _bottomViewHeight = 30;
    _direction = KHScrollDirectionFromRight;
    _alpha = 0.3;
}

#pragma mark - layoutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.bottomViewHeight;
    CGFloat y = CGRectGetHeight(self.frame) - height;
    
    self.bottomView.frame = CGRectMake(0, y, width, height);
    self.pageControl.frame = CGRectMake(0, y, width, height);
    
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
}

- (void)timerHandle {
    NSInteger curPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    NSInteger nextPage = 0;
    if (self.direction == KHScrollDirectionFromRight) {
        nextPage = curPage + 1;
        if (nextPage == self.images.count) {
            nextPage = 2;
        }
    }
    else {
        nextPage = curPage - 1;
        if (nextPage < 0) {
            nextPage = self.images.count - 2;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)invalidateTimer {
    [self stopTimer];
}

- (void)startTimer {
    if (self.isAutoCircle && !isShutScroll) {
        [self timer];
    }
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Events Hanlde
- (void)setDataSource:(NSArray<NSString *> *)dataSource WithSourceType:(KHSourceType)sourceType{
    _dataSource = dataSource;
    imgSourceType = sourceType;
    if (dataSource.count == 1) {
        isShutScroll = YES;
        self.pageControl.hidden = YES;
    }
    
    self.images = [NSMutableArray array];
    NSInteger count = dataSource.count + 2;
    for (NSInteger i = 0; i < count; i++) {
        switch (sourceType) {
            case KHSourceInternetType: {
                NSURL *imgUrl;
                if (0 == i) {
                    imgUrl = [NSURL URLWithString:[dataSource lastObject]];
                }
                else if(count - 1 == i) {
                    imgUrl = [NSURL URLWithString:[dataSource firstObject]];
                }
                else {
                    imgUrl = [NSURL URLWithString:dataSource[i - 1]];
                }
                [self.images addObject:imgUrl];
                break;
            }
                
            default: {
                UIImage *image;
                if (0 == i) {
                    image = [UIImage imageNamed:[dataSource lastObject]];
                }
                else if(count - 1 == i) {
                    image = [UIImage imageNamed:[dataSource firstObject]];
                }
                else{
                    image = [UIImage imageNamed:dataSource[i - 1]];
                }
                [self.images addObject:image];
                break;
            }
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:imageView];
    if (imgSourceType == KHSourceInternetType) {
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.images[indexPath.row]]];//用缓存数据替代
    }
    else {
        imageView.image = self.images[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",self.images[indexPath.row]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentWhenSelectView:andSourceType:)]) {
        [self.delegate contentWhenSelectView:self.images[indexPath.row] andSourceType:imgSourceType];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = (scrollView.contentOffset.x / CGRectGetWidth(self.frame)) - 1;
    self.pageControl.currentPage = currentPage;
    
    if (currentPage < 0) {
        self.pageControl.currentPage = self.dataSource.count - 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
    else if (currentPage == self.dataSource.count) {
        self.pageControl.currentPage = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

@end
