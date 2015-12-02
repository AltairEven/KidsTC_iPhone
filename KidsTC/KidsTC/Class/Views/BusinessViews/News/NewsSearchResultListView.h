//
//  NewsSearchResultListView.h
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsSearchResultListView;
@class NewsListItemModel;

@protocol NewsSearchResultListViewDataSource <NSObject>

- (NSArray<NewsListItemModel *> *)itemModelsForNewsSearchResultListView:(NewsSearchResultListView *)view;

@end

@protocol NewsSearchResultListViewDelegate <NSObject>

- (void)didPullDownToRefreshForNewsSearchResultListView:(NewsSearchResultListView *)view;

- (void)didPullUpToLoadMoreForNewsSearchResultListView:(NewsSearchResultListView *)view;

- (void)newsSearchResultListView:(NewsSearchResultListView *)view didClickedAtIndex:(NSUInteger)index;

@end

@interface NewsSearchResultListView : UIView

@property (nonatomic, assign) id<NewsSearchResultListViewDataSource> dataSource;

@property (nonatomic, assign) id<NewsSearchResultListViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
