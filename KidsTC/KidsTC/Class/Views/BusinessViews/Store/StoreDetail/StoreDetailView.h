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

- (void)didClickedTelephoneOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedAddressOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedActiveOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedAllTuanOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didSelectedTuanAtIndex:(NSUInteger)index;

- (void)didClickedAllServiceOnStoreDetailView:(StoreDetailView *)detailView;

- (void)storeDetailView:(StoreDetailView *)detailView didClickedServiceAtIndex:(NSUInteger)index;

- (void)didClickedMoreDetailOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedMoreBrothersStoreOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedBrotherStoreOnStoreDetailView:(StoreDetailView *)detailView;

- (void)didClickedReviewOnStoreDetailView:(StoreDetailView *)detailView;

@end

@interface StoreDetailView : UIView

@property (nonatomic, assign) id<StoreDetailViewDataSource> dataSource;

@property (nonatomic, assign) id<StoreDetailViewDelegate> delegate;

- (void)reloadData;

@end
