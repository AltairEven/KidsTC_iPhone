//
//  CommentListView.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListItemModel.h"

typedef enum {
    CommentListViewTagAll,
    CommentListViewTagGood,
    CommentListViewTagNormal,
    CommentListViewTagBad,
    CommentListViewTagPicture
}CommentListViewTag;

@class CommentListView;

@protocol CommentListViewDataSource <NSObject>

- (NSUInteger)numberOfCommentsOnCommentListView:(CommentListView *)list withTag:(CommentListViewTag)tag;

- (NSArray *)commentListItemModelsOfCommentListView:(CommentListView *)listView withTag:(CommentListViewTag)tag;

@end

@protocol CommentListViewDelegate <NSObject>

- (void)commentListView:(CommentListView *)listView willShowWithTag:(CommentListViewTag)tag;

- (void)commentListView:(CommentListView *)listView DidPullDownToRefreshforViewTag:(CommentListViewTag)tag;

- (void)commentListView:(CommentListView *)listView DidPullUpToLoadMoreforViewTag:(CommentListViewTag)tag;

@optional

- (void)commentListView:(CommentListView *)listView didClickedImageAtCellIndex:(NSUInteger)cellIndex andImageIndex:(NSUInteger)imageIndex;

@end

@interface CommentListView : UIView

@property (nonatomic, assign) id<CommentListViewDataSource> dataSource;

@property (nonatomic, assign) id<CommentListViewDelegate> delegate;

@property (nonatomic, readonly) CommentListViewTag currentViewTag;

- (void)reloadSegmentHeader;

- (void)reloadDataforViewTag:(CommentListViewTag)tag;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forViewTag:(CommentListViewTag)tag;

- (void)hideLoadMoreFooter:(BOOL)hidden forViewTag:(CommentListViewTag)tag;

@end
