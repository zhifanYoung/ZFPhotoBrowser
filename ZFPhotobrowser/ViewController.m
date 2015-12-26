//
//  ViewController.m
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import "ViewController.h"
#import <SDCycleScrollView.h>
#import "PhotoBrowserViewController.h"
#import "PhotoCollectionViewCell.h"
#import "photoViewController.h"

// 修改SDCycleView的conentMode = SAFill;

@interface ViewController () <SDCycleScrollViewDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, PhotoBrowserViewControllerDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleImageView;

@property (nonatomic, strong) NSArray *urlArray;

@property (nonatomic, assign, getter=isPresent) BOOL present;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) NSMutableArray *imageArrayM;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupUI];
}

- (void)setupData {

    self.urlArray = @[
                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                      @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                      @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"
                      ];
    
    for (int i = 0; i < self.urlArray.count; i++) {
        
        NSURL *url = [NSURL URLWithString:self.urlArray[i]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            
            [self.imageArrayM addObject:image];
        }
    }
    
}

- (void)setupUI {

    [self.view addSubview:self.cycleImageView];
    self.cycleImageView.imageURLStringsGroup = self.urlArray;
}

#pragma mark - delegate 

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

    if (self.imageArrayM.count <= 0) {
        return;
    }
    
    PhotoBrowserViewController *photoVc = [[PhotoBrowserViewController alloc] init];
    photoVc.modalPresentationStyle = UIModalPresentationCustom;
    photoVc.transitioningDelegate = self;
    photoVc.photoDelegate = self;
    photoVc.currenIndex = index;
    photoVc.imageArrayM = self.imageArrayM;
    [self presentViewController:photoVc animated:YES completion:nil];
}

#pragma mark - photoDelegate

- (void)PhotoBrowserViewControllerDismiss:(NSIndexPath *)indexPath {

    // 把SDCycleView的 私有属性mainView，移到头文件中
    [self.cycleImageView.mainView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - animation delegate

// 负责转场
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.present = YES;
    return self;
}

// 负责结束转场
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    self.present = NO;
    return self;
}

// 转场时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5;
}

// 转场动画细节
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    CGFloat duration = [self transitionDuration:transitionContext];
    [self.view insertSubview:self.coverView belowSubview:self.cycleImageView];
    
    if (self.isPresent) {
        
        // 创建转场需要的替身，待会儿移除
        UIView *dummyView = [self.cycleImageView.mainView snapshotViewAfterScreenUpdates:NO];
        
        // 目标视图
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        
        // 添加视图
        [[transitionContext containerView] addSubview:dummyView];
        
        self.cycleImageView.hidden = YES;
        self.coverView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            
            dummyView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - self.cycleImageView.frame.size.height) / 2, self.cycleImageView.frame.size.width, self.cycleImageView.frame.size.height);
        } completion:^(BOOL finished) {
            [dummyView removeFromSuperview];
            
            self.coverView.hidden = YES;
            [[transitionContext containerView] addSubview:toView];
            
            [transitionContext completeTransition:YES];
        }];
    } else {
    
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        PhotoBrowserViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        PhotoCollectionViewCell *photoCell = [[fromVc.collectionView visibleCells] lastObject];
        photoViewController *photoVc = photoCell.photoVc;
        UIImageView *imageView = photoVc.imageView;
        
        UIView *dummy = [imageView snapshotViewAfterScreenUpdates:NO];
        [[transitionContext containerView] addSubview:dummy];

        imageView.hidden = YES;
        dummy.frame = CGRectMake(0, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
            dummy.frame = rect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            fromView.hidden = YES;
            self.cycleImageView.hidden = NO;
        }];
    }
}

#pragma mark - lazyLoad
- (SDCycleScrollView *)cycleImageView {

    if (!_cycleImageView) {
        _cycleImageView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _cycleImageView.delegate = self;
        _cycleImageView.autoScroll = NO;
    }
    return _cycleImageView;
}

- (UIView *)coverView {

    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    
    return _coverView;
}

- (NSMutableArray *)imageArrayM {

    if (!_imageArrayM) {
        _imageArrayM = [NSMutableArray array];
    }
    return _imageArrayM;
}

@end
