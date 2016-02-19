//
//  SettlementView.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettlementModel.h"

@class SettlementView;
@class PaymentTypeModel;

@protocol SettlementViewDataSource <NSObject>

- (SettlementModel *)settlementModelForSettlementView:(SettlementView *)settlementView;

@end

@protocol SettlementViewDelegate <NSObject>

- (void)didClickedServiceOnSettlementView:(SettlementView *)settlementView;

- (void)didClickedCouponOnSettlementView:(SettlementView *)settlementView;

- (void)didClickedScoreEditOnSettlementView:(SettlementView *)settlementView;

- (void)settlementView:(SettlementView *)settlementView didEndEditWithScore:(NSUInteger)score;

- (void)settlementView:(SettlementView *)settlementView didSelectedPaymentAtIndex:(NSUInteger)index;

@end

@interface SettlementView : UIView

@property (nonatomic, assign) id<SettlementViewDataSource> dataSource;

@property (nonatomic, assign) id<SettlementViewDelegate> delegate;

- (void)reloadData;

@end
