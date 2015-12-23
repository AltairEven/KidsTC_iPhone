//
//  ActivityView.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListItemModel.h"
#import "ActivityFilterModel.h"

@class ActivityView;

@protocol ActivityViewDataSource <NSObject>

- (NSArray *)listItemModelsOfActivityView:(ActivityView *)view;

@end

@protocol ActivityViewDelegate <NSObject>

- (void)didPullDownToRefreshForActivityView:(ActivityView *)view;

- (void)didPullUpToLoadMoreForactivityView:(ActivityView *)view;

- (void)activityView:(ActivityView *)view didSelectedItemAtIndex:(NSUInteger)index;

@end

@interface ActivityView : UIView

@property (nonatomic, assign) id<ActivityViewDataSource> dataSource;
@property (nonatomic, assign) id<ActivityViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
