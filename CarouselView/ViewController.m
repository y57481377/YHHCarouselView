//
//  ViewController.m
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "ViewController.h"
#import "YHHCarouselScorllView.h"

#import "NSObject+Runtime.h"

@interface ViewController ()<YHHCarouselScorllViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *imagesArr = @[[UIImage imageNamed:@"t7p9Yyed5WF-hvBtAkQEzQ%3D%3D%2F1419469527229004"],
                           [UIImage imageNamed:@"YBH56fWBu166r2"],
                           [UIImage imageNamed:@"fbbfbf14d6b1ab363e0634239a04b455"]];
    NSArray *ZeroArr = @[[UIImage imageNamed:@"t7p9Yyed5WF-hvBtAkQEzQ%3D%3D%2F1419469527229004"]];
    
    YHHCarouselScorllView *adview = [[YHHCarouselScorllView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    adview.images = imagesArr;
    adview.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    adview.delegate = self;
    adview.backgroundColor = [UIColor blueColor];
    [self.view addSubview:adview];
}

- (void)CarouselScorllView:(UIScrollView *)scrollView didSelectItemAtPage:(NSInteger)page {
    NSLog(@"%ld, %s", page, __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
