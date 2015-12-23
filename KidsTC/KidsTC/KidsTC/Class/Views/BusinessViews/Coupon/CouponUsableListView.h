//
//  CouponUsableListView.h
//  KidsTC
//
//  Created by 钱烨 on 9/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponFullCutModel.h"

@class CouponUsableListView;

@protocol CouponUsableListViewDataSource <NSObject>

- (NSArray *)couponModelsOfCouponUsableListView:(CouponUsableListView *)listView;

@end

@protocol CouponUsableListViewDelegate <NSObject>

- (void)couponUsableListView:(CouponUsableListView *)listView didSelectedCouponAtIndex:(NSUInteger)index;

- (void)couponUsableListView:(CouponUsableListView *)listView didDeselectedCouponAtIndex:(NSUInteger)index;

@end

@interface CouponUsableListView : UIView

@property (nonatomic, assign) id<CouponUsableListViewDataSource> dataSource;

@property (nonatomic, assign) id<CouponUsableListViewDelegate> delegate;

- (void)reloadData;

- (void)setIndex:(NSUInteger)index selected:(BOOL)selected;

@end
