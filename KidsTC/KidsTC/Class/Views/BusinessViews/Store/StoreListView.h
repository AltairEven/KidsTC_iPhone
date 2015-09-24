//
//  StoreListView.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreListView;
@class StoreListItemModel;

@protocol StoreListViewDataSource <NSObject>

- (NSUInteger)numberOfStoresInListView:(StoreListView *)listView;

- (StoreListItemModel *)itemModelForStoreListView:(StoreListView *)listView atIndex:(NSUInteger)index;

@end

@protocol StoreListViewDelegate <NSObject>

- (void)storeListView:(StoreListView *)listView didSelectedItemAtIndex:(NSUInteger)index;

@optional

- (void)storeListViewDidPulledDownToRefresh:(StoreListView *)listView;

- (void)storeListViewDidPulledUpToloadMore:(StoreListView *)listView;

@end

@interface StoreListView : UIView

@property (nonatomic, assign) id<StoreListViewDataSource> dataSource;
@property (nonatomic, assign) id<StoreListViewDelegate> delegate;

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
