//
//  ParentingStrategyView.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentingStrategyView;

@protocol ParentingStrategyViewDataSource <NSObject>

- (NSArray *)listItemModelsOfParentingStrategyView:(ParentingStrategyView *)strategyView;

@end

@protocol ParentingStrategyViewDelegate <NSObject>

- (void)didPullDownToRefreshForParentingStrategyView:(ParentingStrategyView *)strategyView;

- (void)didPullUpToLoadMoreForParentingStrategyView:(ParentingStrategyView *)strategyView;

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface ParentingStrategyView : UIView

@property (nonatomic, assign) id<ParentingStrategyViewDataSource> dataSource;
@property (nonatomic, assign) id<ParentingStrategyViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
