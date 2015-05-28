//
//  KFImageCarouselView.m
//  XBAdPageView
//
//  Created by K6F on 15/5/27.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "KFImageCarouselView.h"

@interface KFImageCarouselView()<UIScrollViewDelegate>{
    NSInteger pCurrentIndex;
    NSInteger pCountOfItems;
    NSTimeInterval pDisplayDuration;
    
}
@property (nonatomic,copy) NSMutableArray *imageArray;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView  *prevImageView;
@property (nonatomic,strong) UIImageView  *currentImageView;
@property (nonatomic,strong) UIImageView  *nextImageView;
@property (nonatomic,strong) NSTimer      *advTimer;

@end




@implementation KFImageCarouselView

#pragma mark - Life Cycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self reloadData];
    [self bringSubviewToFront:self.pageControl];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.advTimer) {
        [self.advTimer invalidate];
        self.advTimer = nil;
    };
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.advTimer) {
        [self.advTimer invalidate];
        self.advTimer = nil;
    };
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >=self.frame.size.width*2)
        pCurrentIndex++;
    else if (scrollView.contentOffset.x < self.frame.size.width)
        pCurrentIndex--;
    [self p_resetImageView];
    
    if (!self.advTimer) [self advTimer];
}
#pragma mark - Event
- (void)p_scrollViewTapedInside{
    if (_delegate && [_delegate respondsToSelector:@selector(kf_didTapImageAtIndex:)]) {
        [_delegate kf_didTapImageAtIndex:pCurrentIndex];
    }
}

#pragma mark - Public
- (void)reloadData{
    // clear
    pCurrentIndex = 0;
    pCountOfItems = 0;
    if (_prevImageView) _prevImageView.image = nil;
    if (_currentImageView) _currentImageView.image = nil;
    if (_nextImageView) _nextImageView.image = nil;
    
    // load count
    if (_dataSource && [_dataSource respondsToSelector:@selector(kf_countOfImages)]) {
        pCountOfItems = [_dataSource kf_countOfImages];
        _pageControl.numberOfPages = pCountOfItems;
    }else{
        pCountOfItems = 0;
    }
    if (!pCountOfItems) return;
    if (self.kfDisplayDuration < 1) {
        self.kfDisplayDuration = 1;
    }
    [self p_resetImageView];
    
    [self advTimer];
}
#pragma mark - Private
- (void)p_slideToNextImageView{
    [_scrollView scrollRectToVisible:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
    pCurrentIndex++;
    [self performSelector:@selector(p_resetImageView) withObject:nil afterDelay:0.3];
}
- (void)p_resetImageView{
    if (pCurrentIndex >= pCountOfItems)
        pCurrentIndex = 0;
    if (pCurrentIndex < 0)
        pCurrentIndex = pCountOfItems - 1;
    
    NSInteger prevIndex,nextIndex;
    prevIndex = pCurrentIndex -1;
    nextIndex = pCurrentIndex +1;
    if (prevIndex < 0) {
        prevIndex = pCountOfItems -1;
    }
    if (nextIndex >= pCountOfItems) {
        nextIndex = 0;
    }
    
    self.pageControl.currentPage = pCurrentIndex;
    if(_dataSource && [_dataSource respondsToSelector:@selector(kf_imageView:loadImageAtIndex:)])
    {
        [_dataSource kf_imageView:self.prevImageView loadImageAtIndex:prevIndex];
        [_dataSource kf_imageView:self.currentImageView loadImageAtIndex:pCurrentIndex];
        [_dataSource kf_imageView:self.nextImageView loadImageAtIndex:nextIndex];
    }else{
        self.prevImageView.image = nil;
        self.currentImageView.image = nil;
        self.nextImageView.image = nil;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
    _pageControl.currentPage = pCurrentIndex;
}

#pragma mark - Getter & Setter
- (void)setDataSource:(id<KFImageCarouselViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

- (NSTimeInterval)kfDisplayDuration{
    if (pDisplayDuration < 1.f) {
        pDisplayDuration = 1.f;
    }
    return pDisplayDuration;
}
- (void)setKfDisplayDuration:(NSTimeInterval)duration{
    pDisplayDuration = duration;
    if (_advTimer) {
        [_advTimer invalidate];
        _advTimer = nil;
    }
}
- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    _pageControl.frame = CGRectMake(0, self.bounds.size.height - 37 , self.bounds.size.width, 37);
    return _pageControl;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        _scrollView.delegate = self;
        UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_scrollViewTapedInside)];
        [_scrollView addGestureRecognizer:tapGR];
    }
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.frame = self.bounds;
    return _scrollView;
}

- (UIImageView *)prevImageView{
    if (!_prevImageView) {
        _prevImageView = [[UIImageView alloc] init];
        _prevImageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:_prevImageView];
    }
    _prevImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    return _prevImageView;
}

- (UIImageView *)currentImageView{
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:_currentImageView];
    }
    _currentImageView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
    return _currentImageView;
}

- (UIImageView *)nextImageView{
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:_nextImageView];
    }
    _nextImageView.frame = CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height);
    return _nextImageView;
}

- (NSTimer *)advTimer{
    if (1 >= pCountOfItems) return nil;
    if (!_advTimer){
    _advTimer = [NSTimer scheduledTimerWithTimeInterval:self.kfDisplayDuration
                                                 target:self
                                               selector:@selector(p_slideToNextImageView)
                                               userInfo:nil
                                                repeats:YES];
    }
     return _advTimer;
}

@end
