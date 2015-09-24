//
//  NewsRecommendListView.h
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsRecommendListModel.h"

@class NewsRecommendListView;

@protocol NewsRecommendListViewDataSource <NSObject>

- (NSArray *)newsRecommendListModelsForNewsRecommendListView:(NewsRecommendListView *)listView;

@end

@protocol NewsRecommendListViewDelegate <NSObject>

- (void)newsRecommendListView:(NewsRecommendListView *)listView didSelectedCellItem:(NewsListItemModel *)item;

@optional

- (void)newsRecommendListViewDidPulledToloadMore:(NewsRecommendListView *)listView;

@end

@interface NewsRecommendListView : UIView

@property (nonatomic, assign) id<NewsRecommendListViewDataSource> dataSource;
@property (nonatomic, assign) id<NewsRecommendListViewDelegate> delegate;

- (NSUInteger)pageSize;

- (void)reloadData;

- (void)startLoadMore;

- (void)endLoadMore;

@end
