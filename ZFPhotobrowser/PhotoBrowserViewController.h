//
//  PhotoBrowserViewController.h
//  ZFPhotobrowser
//
//  Created by Young on 15/12/25.
//  Copyright © 2015年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserViewControllerDelegate <NSObject>

- (void)PhotoBrowserViewControllerDismiss:(NSIndexPath *)indexPath;

@end

@interface PhotoBrowserViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, weak) id <PhotoBrowserViewControllerDelegate> photoDelegate;

@property (nonatomic, assign) NSInteger currenIndex;

@property (nonatomic, strong) NSMutableArray *imageArrayM;
@end
