//
//  HospitalListView.h
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HospitalListView;

@protocol HospitalListViewDataSource <NSObject>

- (NSArray *)itemModelsOfHospitalListView:(HospitalListView *)listView;

@end

@protocol HospitalListViewDelegate <NSObject>

- (void)didPullUpToLoadMoreForHospitalListView:(HospitalListView *)listView;

- (void)hospitalListView:(HospitalListView *)listView didClickedPhoneButtonAtIndex:(NSUInteger)index;

- (void)hospitalListView:(HospitalListView *)listView didClickedGotoButtonAtIndex:(NSUInteger)index;

- (void)hospitalListView:(HospitalListView *)listView didClickedNearbyButtonAtIndex:(NSUInteger)index;

@end

@interface HospitalListView : UIView

@property (nonatomic, assign) id<HospitalListViewDataSource> dataSource;

@property (nonatomic, assign) id<HospitalListViewDelegate> delegate;

- (void)reloadData;

- (void)startLoadMore;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore;

- (void)hideLoadMoreFooter:(BOOL)hidden;

@end
