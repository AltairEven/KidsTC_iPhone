//
//  OrderListView.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

@class OrderListView;

@protocol OrderListViewDataSource <NSObject>

- (NSArray *)orderListModelsForOrderListView:(OrderListView *)listView;

@end

@protocol OrderListViewDelegate <NSObject>

- (void)orderListViewDidPullDownToRefresh:(OrderListView *)listView;

- (void)orderListViewDidPullUpToLoadMore:(OrderListView *)listView;

- (void)orderListView:(OrderListView *)listView didSelectAtIndex:(NSUInteger)index;

- (void)orderListView:(OrderListView *)listView didClickedPayButtonAtIndex:(NSUInteger)index;

- (void)orderListView:(OrderListView *)listView didClickedCommentButtonAtIndex:(NSUInteger)index;

- (void)orderListView:(OrderListView *)listView didClickedReturnButtonAtIndex:(NSUInteger)index;

@end

@interface OrderListView : UIView

@property (nonatomic, assign) id<OrderListViewDataSource> dataSource;
@property (nonatomic, assign) id<OrderListViewDelegate> delegate;

- (void)reloadData;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
