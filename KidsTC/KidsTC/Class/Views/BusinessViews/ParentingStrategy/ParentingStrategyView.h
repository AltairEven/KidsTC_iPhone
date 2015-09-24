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

- (NSArray *)listItemModelsOfParentingStrategyView:(ParentingStrategyView *)strategyView atCalendarIndex:(NSUInteger)index;

@end

@protocol ParentingStrategyViewDelegate <NSObject>

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView didClickedCalendarButtonAtIndex:(NSUInteger)index;

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView DidPullDownToRefreshForCalendarIndex:(NSUInteger)index;

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView DidPullUpToLoadMoreForCalendarIndex:(NSUInteger)index;

- (void)parentingStrategyView:(ParentingStrategyView *)strategyView didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface ParentingStrategyView : UIView

@property (nonatomic, assign) id<ParentingStrategyViewDataSource> dataSource;
@property (nonatomic, assign) id<ParentingStrategyViewDelegate> delegate;

@property (nonatomic, strong) NSArray *calendarTitles;
@property (nonatomic, readonly) NSUInteger currentCalendarIndex;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forCalendarIndex:(NSUInteger)index;

- (void)hideLoadMoreFooter:(BOOL)hidden forCalendarIndex:(NSUInteger)index;

@end
