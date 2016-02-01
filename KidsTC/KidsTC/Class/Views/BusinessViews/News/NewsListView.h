//
//  NewsListView.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsListView;
@class NewsListItemModel;

@protocol NewsListViewDataSource <NSObject>

- (NSArray *)newsTagItemModelsForNewsListView:(NewsListView *)listView;

- (NSArray *)newsListItemModelsForNewsListView:(NewsListView *)listView ofNewsTagIndex:(NSUInteger)index;

@end

@protocol NewsListViewDelegate <NSObject>

- (void)newsListView:(NewsListView *)listView didSelectedNewsTagIndex:(NSUInteger)index;

- (void)newsListView:(NewsListView *)listView didSelectedItem:(NewsListItemModel *)item atNewsTagIndex:(NSUInteger)index;

@optional

- (void)newsListViewDidPulledDownToRefresh:(NewsListView *)listView atNewsTagIndex:(NSUInteger)index;

- (void)newsListViewDidPulledUpToloadMore:(NewsListView *)listView atNewsTagIndex:(NSUInteger)index;

@end

@interface NewsListView : UIView

@property (nonatomic, assign) id<NewsListViewDataSource> dataSource;
@property (nonatomic, assign) id<NewsListViewDelegate> delegate;
@property (nonatomic, readonly) NSUInteger itemCount;
@property (nonatomic, assign) NSUInteger currentNewsTagIndex;

- (void)selectNewsTagAtIndex:(NSUInteger)index;

- (void)reloadNewsTag;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forNewsTagIndex:(NSUInteger)index;

- (void)hideLoadMoreFooter:(BOOL)hidden forNewsTagIndex:(NSUInteger)index;

@end
