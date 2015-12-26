
//
//  photoViewController.m
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import "photoViewController.h"
#import <UIImageView+WebCache.h>

@interface photoViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation photoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupUI];
}

- (void)setupUI {

    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    self.imageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 200) / 2, [UIScreen mainScreen].bounds.size.width, 200);
    
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.imageView;
}

#pragma mark - lazyLoad

- (UIScrollView *)scrollView {

    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {

    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end

