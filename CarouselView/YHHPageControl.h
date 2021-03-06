//
//  YHHPageControl.h
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHHPageControl : UIPageControl

@property (strong, nonatomic) UIImage *imageNormal;
@property (strong, nonatomic) UIImage *imageHighlight;

@property (assign, nonatomic) CGSize itemSize;

@end
