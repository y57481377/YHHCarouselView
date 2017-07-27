//
//  YHHPageControl.m
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "YHHPageControl.h"

@implementation YHHPageControl {
    NSMutableArray<UIImageView *> *_imageViews;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    
    //第一次先创建YHHPageControl 会先调用"setCurrentPage",再调用"layoutSubviews"
    if (!_imageViews) [self layoutSubviews];
    // 如果没有设置显示image则return
    if (!_imageNormal && !_imageHighlight) return;
    
    for (int i = 0; i < _imageViews.count; i++) {
        
        if (i == currentPage) {
            _imageViews[i].image = _imageHighlight;
            _imageViews[i].backgroundColor = self.currentPageIndicatorTintColor;
        }
        if (i != currentPage) {
            _imageViews[i].image = _imageNormal;
            _imageViews[i].backgroundColor = self.pageIndicatorTintColor;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat itemW = 7;
    CGFloat itemH = 7;
    if (_itemSize.height != 0 && _itemSize.width !=0) {
        itemH = _itemSize.height;
        itemW = _itemSize.width;
    }
    CGFloat itemGap = itemW * 1.285; // item之间的间隔
    CGFloat needW = itemW * self.numberOfPages + itemGap * (self.numberOfPages - 1); // 所有item需要的宽度
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(needW, itemH);
    self.frame = frame;
    
//    CGFloat x = (self.frame.size.width - needW) * 0.5; // 第一个item的x
//    CGFloat y = (self.frame.size.height - itemH) * 0.5;
    if (_imageViews.count < self.numberOfPages) {
        if (!_imageViews) _imageViews = [NSMutableArray array];
        
        for (int i = 0; i < self.numberOfPages; i++) {
            
            // 隐藏系统小红点
            self.subviews[i].hidden = YES;
            
            UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake((itemGap + itemW) * i, 0, itemW, itemH)];
            imagev.contentMode = UIViewContentModeScaleAspectFill;
            [_imageViews addObject:imagev];
            [self addSubview:imagev];
        }
    }
    
}
@end
