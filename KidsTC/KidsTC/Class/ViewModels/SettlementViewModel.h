//
//  SettlementViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/19/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "SettlementView.h"
#import "KTCPaymentService.h"

@interface SettlementViewModel : BaseViewModel

@property (nonatomic, strong, readonly) SettlementModel *dataModel;

@property (nonatomic, strong, readonly) NSString *orderId;

@property (nonatomic, strong, readonly) KTCPaymentInfo *paymentInfo;

- (void)resetWithUsedCoupon:(CouponBaseModel *)coupon succeed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)resetWithUsedScore:(NSUInteger)score succeed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)resetWithSelectedPaymentIndex:(NSUInteger)index;

- (void)submitOrderWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

@end
