//
//  MyCommentListView.h
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyCommentListView;
@class MyCommentListItemModel;

@protocol MyCommentListViewDataSource <NSObject>

- (NSArray<MyCommentListItemModel *> *)itemModelsForCommentListView:(MyCommentListView *)view;

@end

@protocol MyCommentListViewDelegate <NSObject>

- (void)didPullDownToRefreshForCommentListView:(MyCommentListView *)view;

- (void)didPullUpToLoadMoreForCommentListView:(MyCommentListView *)view;

- (void)commentListView:(MyCommentListView *)view didClickedAtIndex:(NSUInteger)index;

- (void)commentListView:(MyCommentListView *)view didClickedImageAtCellIndex:(NSUInteger)cellIndex andImageIndex:(NSUInteger)imageIndex;

- (void)commentListView:(MyCommentListView *)view didClickedEditAtIndex:(NSUInteger)index;

- (void)commentListView:(MyCommentListView *)view didClickedDeleteAtIndex:(NSUInteger)index;

@end


@interface MyCommentListView : UIView

@property (nonatomic, assign) id<MyCommentListViewDataSource> dataSource;

@property (nonatomic, assign) id<MyCommentListViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
