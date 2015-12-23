//
//  NotificationCenterView.h
//  KidsTC
//
//  Created by 钱烨 on 8/26/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationCenterView;
@class PushNotificationModel;

@protocol NotificationCenterViewDataSource <NSObject>

- (NSArray<PushNotificationModel *> *)notificationModelsForNotificationCenterView:(NotificationCenterView *)view;

@end

@protocol NotificationCenterViewDelegate <NSObject>

- (void)didPullDownToRefreshForNotificationCenterView:(NotificationCenterView *)view;

- (void)didPullUpToLoadMoreForNotificationCenterView:(NotificationCenterView *)view;

- (void)notificationCenterView:(NotificationCenterView *)view didClickedAtIndex:(NSUInteger)index;

@end

@interface NotificationCenterView : UIView

@property (nonatomic, assign) id<NotificationCenterViewDataSource> dataSource;

@property (nonatomic, assign) id<NotificationCenterViewDelegate> delegate;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
