//
//  CommentDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDetailModel.h"

@class CommentDetailView;

@protocol CommentDetailViewDataSource <NSObject>

- (CommentDetailModel *)detailModelForCommentDetailView:(CommentDetailView *)detailView;

@end

@protocol CommentDetailViewDelegate <NSObject>

- (void)commentDetailView:(CommentDetailView *)detailView didSelectedReplyAtIndex:(NSUInteger)index;

- (void)didTappedOnCommentDetailView:(CommentDetailView *)detailView;

@optional

- (void)commentDetailViewDidPulledDownToRefresh:(CommentDetailView *)detailView;

- (void)commentDetailViewDidPulledUpToloadMore:(CommentDetailView *)detailView;

@end

@interface CommentDetailView : UIView

@property (nonatomic, assign) id<CommentDetailViewDataSource> dataSource;

@property (nonatomic, assign) id<CommentDetailViewDelegate> delegate;

@property (nonatomic, assign) BOOL enableUpdate;

@property (nonatomic, assign) BOOL enbaleLoadMore;

- (NSUInteger)pageSize;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
