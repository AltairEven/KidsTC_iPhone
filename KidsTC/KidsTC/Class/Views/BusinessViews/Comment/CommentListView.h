//
//  CommentListView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListItemModel.h"

@class CommentListView;

@protocol CommentListViewDataSource <NSObject>

- (NSUInteger)numberOfCommentsOnCommentListView:(CommentListView *)list withTag:(CommentListType)tag;

- (NSArray *)commentListItemModelsOfCommentListView:(CommentListView *)listView withTag:(CommentListType)tag;

@end

@protocol CommentListViewDelegate <NSObject>

- (void)commentListView:(CommentListView *)listView willShowWithTag:(CommentListType)tag;

- (void)commentListView:(CommentListView *)listView DidPullDownToRefreshforViewTag:(CommentListType)tag;

- (void)commentListView:(CommentListView *)listView DidPullUpToLoadMoreforViewTag:(CommentListType)tag;

@optional

- (void)commentListView:(CommentListView *)listView didClickedImageAtCellIndex:(NSUInteger)cellIndex andImageIndex:(NSUInteger)imageIndex;

@end

@interface CommentListView : UIView

@property (nonatomic, assign) id<CommentListViewDataSource> dataSource;

@property (nonatomic, assign) id<CommentListViewDelegate> delegate;

@property (nonatomic, readonly) CommentListType currentViewTag;

- (void)reloadSegmentHeader;

- (void)reloadDataforViewTag:(CommentListType)tag;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forViewTag:(CommentListType)tag;

- (void)hideLoadMoreFooter:(BOOL)hidden forViewTag:(CommentListType)tag;

@end
