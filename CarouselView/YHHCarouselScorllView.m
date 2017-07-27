//
//  YHHCarouselScorllView.m
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "YHHCarouselScorllView.h"
#import "YHHCarouselCell.h"
#import "NSObject+Runtime.h"

@interface YHHCarouselScorllView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (assign, nonatomic) CGFloat CarouselOffset; //记录当前偏移量
@property (assign, nonatomic) CGFloat pageSize; //获取每页单位尺寸
//@property (assign, nonatomic) NSInteger currentPage; //当前页码

@end

@implementation YHHCarouselScorllView {
    NSTimer *_timer;
    NSInteger _imageCount;
    BOOL _isDirectionHorizontal;
}

static NSString *YHHCarouseIdentifier = @"YHHCarouseIdentifierCell";

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.pagingEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YHHCarouselCell class] forCellWithReuseIdentifier:YHHCarouseIdentifier];
    [self addSubview:_collectionView];
    
    _pageControl = [[YHHPageControl alloc] initWithFrame:CGRectMake(50, 100, 200, 40)];
    [self addSubview:_pageControl];
    
    NSArray *arr = [UIPageControl getAllIvars];
    NSLog(@"%@", arr);
    
//    NSArray *arr1 = [UIPageControl getAllMethods];
//    NSLog(@"%@", arr1);
}


/**
 设置轮播图滑动方向
 */
- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    self.layout.scrollDirection = scrollDirection;
    
    /**
     无限轮播展示顺序为： lastImage, (image[0], images[1], ..., images[Last]), firstImage,
               page：                0,        1,    2～ast-2,  last-1
     所以需要从第二页开始展示，滑动到最后的firstImage时，将scrollView置为image[0],
                          从image[0]往前拖拽时，将scrollView置为images[Last]。
     */
    if (scrollDirection == UICollectionViewScrollDirectionVertical) {
        _collectionView.contentOffset = CGPointMake(0, self.frame.size.height);
        _isDirectionHorizontal = NO;
    }else {
        _collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _isDirectionHorizontal = YES;
    }
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = self.frame.size;
        
        // 设置默认的轮播方向为水平
        if (!_scrollDirection) {
            _layout.scrollDirection = _scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _collectionView.contentOffset = CGPointMake(self.frame.size.width, 0);
            _isDirectionHorizontal = YES;
        }
    }
    return _layout;
}

- (void)setImages:(NSArray<UIImage *> *)images {
    _images = images;
    if (_images.count < 1) return;
    
    _imageCount = images.count==1 ? 1 : images.count + 2;
    if (_imageCount > 1) {
        [self addTimer];
        _collectionView.scrollEnabled = YES;
        _pageControl.numberOfPages = 5;
    }else {
        _collectionView.scrollEnabled = NO;
    }
}

- (CGFloat)CarouselOffset {
    _CarouselOffset = _isDirectionHorizontal ?
             _collectionView.contentOffset.x : _collectionView.contentOffset.y;
    
    return _CarouselOffset;
}

- (CGFloat)pageSize {
    if (!_pageSize) {
        _pageSize = _isDirectionHorizontal ?
                     self.frame.size.width : self.frame.size.height;
    }
    return _pageSize;
}


#pragma mark --- Timer
- (void)addTimer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
            CGFloat offsetx = 0;
            CGFloat offsety = 0;
            _isDirectionHorizontal ? (offsetx = _collectionView.contentOffset.x + self.frame.size.width) :
            (offsety = _collectionView.contentOffset.y + self.frame.size.height);
            
            [_collectionView scrollRectToVisible:CGRectMake(offsetx, offsety, self.frame.size.width, self.frame.size.height) animated:YES];
        }];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark --- ScorllDelegate 滚动控制
/**
 判断滑动的位置：控制pageControl和 无限滚动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%s", __func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
    CGFloat actualPage = self.CarouselOffset / self.pageSize;
    
    CGFloat offsetx = 0;
    CGFloat offsety = 0;
    NSInteger page = -1;
    
    if (actualPage == 0) {
        _isDirectionHorizontal ? (offsetx = self.frame.size.width * (_imageCount - 2)) :
                                 (offsety = self.frame.size.height * (_imageCount - 2));
        page = _images.count - 1;
        scrollView.contentOffset = CGPointMake(offsetx, offsety);
    }else if (actualPage == _imageCount -1) {
        _isDirectionHorizontal ? (offsetx = self.frame.size.width) :
                                 (offsety = self.frame.size.height);
        page = 0;
        scrollView.contentOffset = CGPointMake(offsetx, offsety);
    }
    _pageControl.currentPage =  page>=0 ? page : actualPage - 1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 结束拖拽，添加定时器
    [self addTimer];
}


#pragma mark --- Collection Data Source / Collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSInteger page;
    if (indexPath.row == 0) {
        page = _images.count - 1;
    }else if (indexPath.row == _imageCount - 1) {
        page = 0;
    }else {
        page = indexPath.row - 1;
    }
    
    if ([self.delegate respondsToSelector:@selector(CarouselScorllView:didSelectItemAtPage:)]) {
        [self.delegate CarouselScorllView:collectionView didSelectItemAtPage:page];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YHHCarouselCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YHHCarouseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.image = [_images lastObject];
    }else if (indexPath.row == _imageCount - 1) {
        cell.image = [_images firstObject];
    }else {
        cell.image = _images[indexPath.row - 1];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSLog(@"%@", NSStringFromCGRect(_pageControl.frame));
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat offset = _pageControl.frame.size.width;
        _pageControl.transform = CGAffineTransformMakeRotation(M_PI_2);
        _pageControl.center = CGPointMake(self.frame.size.width - offset - 10, self.frame.size.height / 2);
    }else {
        _pageControl.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 12);
    }
}
@end
