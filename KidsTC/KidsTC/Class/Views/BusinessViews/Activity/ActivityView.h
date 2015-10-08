//
//  ActivityView.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListItemModel.h"

@class ActivityView;

@protocol ActivityViewDataSource <NSObject>

- (NSArray *)listItemModelsOfActivityView:(ActivityView *)view atCalendarIndex:(NSUInteger)index;

@end

@protocol ActivityViewDelegate <NSObject>

- (void)activityView:(ActivityView *)view didClickedCalendarButtonAtIndex:(NSUInteger)index;

- (void)activityView:(ActivityView *)view DidPullDownToRefreshForCalendarIndex:(NSUInteger)index;

- (void)activityView:(ActivityView *)view DidPullUpToLoadMoreForCalendarIndex:(NSUInteger)index;

- (void)activityView:(ActivityView *)view didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface ActivityView : UIView

@property (nonatomic, assign) id<ActivityViewDataSource> dataSource;
@property (nonatomic, assign) id<ActivityViewDelegate> delegate;

@property (nonatomic, strong) NSArray *calendarTitles;
@property (nonatomic, readonly) NSUInteger currentCalendarIndex;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forCalendarIndex:(NSUInteger)index;

- (void)hideLoadMoreFooter:(BOOL)hidden forCalendarIndex:(NSUInteger)index;

@end
