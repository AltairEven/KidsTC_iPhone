//
//  NewsRecommendListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRecommendListModel.h"

@class NewsRecommendListViewCell;

@protocol NewsRecommendListViewCellDelegate <NSObject>

- (void)newsRecommendListViewCell:(NewsRecommendListViewCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface NewsRecommendListViewCell : UITableViewCell

@property (nonatomic, assign) id<NewsRecommendListViewCellDelegate> delegate;

@property (nonatomic, strong) NewsRecommendListModel *listItemModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
