//
//  YHHCarouselScorllView.h
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHHPageControl.h"

@protocol YHHCarouselScorllViewDelegate <NSObject>

- (void)CarouselScorllView:(UIScrollView *)scrollView didSelectItemAtPage:(NSInteger)page;
@end

@interface YHHCarouselScorllView : UIView
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (weak, nonatomic) id<YHHCarouselScorllViewDelegate> delegate;

@property (copy, nonatomic) NSArray<UIImage *> *images;
@property (strong, nonatomic, readonly) YHHPageControl *pageControl;
@end
