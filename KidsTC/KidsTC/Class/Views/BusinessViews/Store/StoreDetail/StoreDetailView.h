//
//  StoreDetailView.h
//  KidsTC
//
//  Created by 钱烨 on 7/16/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreDetailModel.h"

@class StoreDetailView;
@class StoreListItemModel;

@protocol StoreDetailViewDataSource <NSObject>

- (StoreDetailModel *)detailModelForStoreDetailView:(StoreDetailView *)detailView;

@end

@protocol StoreDetailViewDelegate <NSObject>

- (void)didClickedCouponButtonOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedAddressOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedActiveOnStoreDetailView:(StoreDetailView *)detailView atIndex:(NSUInteger)index;

- (void)didClickedAllServiceOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didClickedServiceAtIndex:(NSUInteger)index;

- (void)didClickedAllHotRecommendOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didSelectedHotRecommendAtIndex:(NSUInteger)index;

- (void)didClickedAllStrategyOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didSelectedSteategyAtIndex:(NSUInteger)index;

- (void)didClickedMoreDetailOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedMoreReviewOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didClickedReviewAtIndex:(NSUInteger)index;

- (void)storeDetailView:(StoreDetailView *)detailView didSelectedLinkWithSegueModel:(HomeSegueModel *)model;

@end

@interface StoreDetailView : UIView

@property (nonatomic, assign) id<StoreDetailViewDataSource> dataSource;

@property (nonatomic, assign) id<StoreDetailViewDelegate> delegate;

- (void)reloadData;

@end
