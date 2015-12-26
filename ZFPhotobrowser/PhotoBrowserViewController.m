


//
//  PhotoBrowserViewController.m
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoCollectionViewCell.h"

static NSString *cellIdentifier = @"PhotoCellIdentifier";

@interface PhotoBrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
    UITapGestureRecognizer *pinch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    pinch.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:pinch];
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:self.currenIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - action

- (void)action {
    
    PhotoCollectionViewCell *cell = [[self.collectionView visibleCells] lastObject];
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        if ([self.photoDelegate respondsToSelector:@selector(PhotoBrowserViewControllerDismiss:)]) {
            [self.photoDelegate PhotoBrowserViewControllerDismiss:path];
        }
    }];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArrayM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    cell.imageArrayM = self.imageArrayM;
    cell.currentIndex = indexPath.row;
    
    if (![self.childViewControllers containsObject:(UIViewController *)cell.photoVc]) {
        [self addChildViewController:(UIViewController *)cell.photoVc];
    }
    
    return cell;
}

#pragma mark - lazyLoad

- (UICollectionView *)collectionView {

    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.userInteractionEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {

    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = self.view.bounds.size;
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
@end
