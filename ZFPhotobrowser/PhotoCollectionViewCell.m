//
//  PhotoCollectionViewCell.m
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "photoViewController.h"

@interface PhotoCollectionViewCell ()

@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
     
        self.photoVc.view.frame = self.bounds;
        [self addSubview:self.photoVc.view];
    }
    return self;
}

- (void)setImageArrayM:(NSMutableArray *)imageArrayM {

    _imageArrayM = imageArrayM;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {

    _currentIndex = currentIndex;

    self.photoVc.imageView.image = self.imageArrayM[currentIndex];
}

- (photoViewController *)photoVc {

    if (!_photoVc) {
        _photoVc = [[photoViewController alloc] init];
    }
    return _photoVc;
}

@end
