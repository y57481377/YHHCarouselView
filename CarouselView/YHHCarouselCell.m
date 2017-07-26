//
//  YHHCarouselCell.m
//  CarouselView
//
//  Created by Yang on 2017/7/26.
//  Copyright © 2017年 YHH. All rights reserved.
//

#import "YHHCarouselCell.h"

@implementation YHHCarouselCell {
    UIImageView *_imagev;
}

- (void)setImage:(UIImage *)image {
    if (!_image) {
        _imagev = [[UIImageView alloc] init];
    }
    _image = image;
    _imagev.image = image;
}

- (void)layoutSubviews {
    _imagev.frame = self.bounds;
    [self.contentView addSubview:_imagev];
}
@end
