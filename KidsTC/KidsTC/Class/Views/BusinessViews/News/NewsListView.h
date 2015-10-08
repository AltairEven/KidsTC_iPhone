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

- (NSArray *)newsListItemModelsForNewsListView:(NewsListView *)listView;

@end

@protocol NewsListViewDelegate <NSObject>

- (void)newsListView:(NewsListView *)listView didSelectedItem:(NewsListItemModel *)item;

@optional

- (void)newsListViewDidPulledDownToRefresh:(NewsListView *)listView;

- (void)newsListViewDidPulledUpToloadMore:(NewsListView *)listView;

@end

@interface NewsListView : UIView

@property (nonatomic, assign) id<NewsListViewDataSource> dataSource;
@property (nonatomic, assign) id<NewsListViewDelegate> delegate;

@property (nonatomic, readonly) NSUInteger itemCount;;

- (NSUInteger)pageSize;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreLoad;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
