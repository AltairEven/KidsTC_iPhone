//
//  HomeViewBannerCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewBannerCell;

@protocol HomeViewBannerCellDelegate <NSObject>

- (void)homeViewBannerCell:(HomeViewBannerCell *)bannerCell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewBannerCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewBannerCellDelegate> delegate;

@property (nonatomic, strong) NSArray *imageUrlsArray;

@property (nonatomic, assign) CGFloat ratio;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
