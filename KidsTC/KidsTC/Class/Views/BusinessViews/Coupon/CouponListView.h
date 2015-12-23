//
//  CouponListView.h
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponFullCutModel.h"

typedef enum {
    CouponListViewTagUnused,
    CouponListViewTagHasUsed,
    CouponListViewTagHasOverTime
}CouponListViewTag;

@class CouponListView;

@protocol CouponListViewDataSource <NSObject>

- (NSArray *)couponModelsOfCouponListView:(CouponListView *)listView withTag:(CouponListViewTag)tag;

@end

@protocol CouponListViewDelegate <NSObject>

- (void)couponListView:(CouponListView *)listView willShowWithTag:(CouponListViewTag)tag;

- (void)couponListView:(CouponListView *)listView DidPullDownToRefreshforViewTag:(CouponListViewTag)tag;

- (void)couponListView:(CouponListView *)listView DidPullUpToLoadMoreforViewTag:(CouponListViewTag)tag;

@end

@interface CouponListView : UIView

@property (nonatomic, assign) id<CouponListViewDataSource> dataSource;

@property (nonatomic, assign) id<CouponListViewDelegate> delegate;

@property (nonatomic, readonly) CouponListViewTag currentViewTag;

- (void)reloadSegmentHeader;

- (void)reloadDataforViewTag:(CouponListViewTag)tag;

- (void)endRefresh;

- (void)endLoadMore;

- (void)noMoreData:(BOOL)noMore forViewTag:(CouponListViewTag)tag;

- (void)hideLoadMoreFooter:(BOOL)hidden forViewTag:(CouponListViewTag)tag;

@end
