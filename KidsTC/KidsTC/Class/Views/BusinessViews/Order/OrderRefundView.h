//
//  OrderRefundView.h
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderRefundModel.h"

@class OrderRefundView;

@protocol OrderRefundViewDataSource <NSObject>

- (OrderRefundModel *)refundModelForOrderRefundView:(OrderRefundView *)view;

@end

@protocol OrderRefundViewDelegate <NSObject>

- (void)orderRefundView:(OrderRefundView *)view didChangedRefundCountToValue:(NSUInteger)count;

- (void)didClickedReasonButtonOnOrderRefundView:(OrderRefundView *)view;

- (void)didClickedSubmitButtonOnOrderRefundView:(OrderRefundView *)view;

@end

@interface OrderRefundView : UIView

@property (nonatomic, assign) id<OrderRefundViewDataSource> dataSource;

@property (nonatomic, assign) id<OrderRefundViewDelegate> delegate;

- (void)setMinCount:(NSInteger)min andMaxCount:(NSInteger)max;

- (void)reloadData;

@end
