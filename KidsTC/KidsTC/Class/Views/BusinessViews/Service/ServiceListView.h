//
//  ServiceListView.h
//  KidsTC
//
//  Created by 钱烨 on 7/10/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceListView;
@class ServiceListItemModel;

@protocol ServiceListViewDataSource <NSObject>

- (NSUInteger)numberOfServiceInListView:(ServiceListView *)listView;

- (ServiceListItemModel *)itemModelForServiceListView:(ServiceListView *)listView atIndex:(NSUInteger)index;

@end

@protocol ServiceListViewDelegate <NSObject>

- (void)serviceListView:(ServiceListView *)listView didSelectedItemAtIndex:(NSUInteger)index;

@optional

- (void)serviceListViewDidPulledDownToRefresh:(ServiceListView *)listView;

- (void)serviceListViewDidPulledUpToloadMore:(ServiceListView *)listView;

@end

@interface ServiceListView : UIView

@property (nonatomic, assign) id<ServiceListViewDataSource> dataSource;
@property (nonatomic, assign) id<ServiceListViewDelegate> delegate;

@property (nonatomic, assign) BOOL enableUpdate;

@property (nonatomic, assign) BOOL enbaleLoadMore;

- (NSUInteger)pageSize;

- (void)reloadData;

- (void)startRefresh;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreLoad;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
