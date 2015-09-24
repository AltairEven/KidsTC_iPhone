//
//  AppointmentOrderListView.h
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentOrderModel.h"

@class AppointmentOrderListView;

@protocol AppointmentOrderListViewDataSource <NSObject>

- (NSArray *)orderModelsForOrderListView:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status;

@end

@protocol AppointmentOrderListViewDelegate <NSObject>

- (void)orderListView:(AppointmentOrderListView *)listView didChangedListStatus:(AppointmentOrderListStatus)status;

- (void)orderListViewDidPullDownToRefresh:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status;

- (void)orderListViewDidPullUpToLoadMore:(AppointmentOrderListView *)listView forListStatus:(AppointmentOrderListStatus)status;

- (void)orderListView:(AppointmentOrderListView *)listView didSelectAtIndex:(NSUInteger)index ofListStatus:(AppointmentOrderListStatus)status;

@end

@interface AppointmentOrderListView : UIView

@property (nonatomic, assign) id<AppointmentOrderListViewDataSource> dataSource;
@property (nonatomic, assign) id<AppointmentOrderListViewDelegate> delegate;

@property (nonatomic, readonly) AppointmentOrderListStatus currentLsitStatus;

- (void)reloadDataforListStatus:(AppointmentOrderListStatus)status;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forListStatus:(AppointmentOrderListStatus)status;

- (void)hideLoadMoreFooter:(BOOL)hidden forListStatus:(AppointmentOrderListStatus)status;

@end
