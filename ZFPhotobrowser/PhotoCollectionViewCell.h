//
//  PhotoCollectionViewCell.h
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@class photoViewController;

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) photoViewController *photoVc;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *imageArrayM;
@end
