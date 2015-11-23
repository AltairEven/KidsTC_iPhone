//
//  SettlementModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentTypeModel.h"
#import "CouponFullCutModel.h"
#import "PromotionFullCutModel.h"

#define ScoreCoefficient (0.1)

@interface SettlementModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) NSArray *supportedPaymentTypes;

@property (nonatomic, assign) PaymentTypeModel *currentPaymentType;

@property (nonatomic, copy) NSString *soleId;

@property (nonatomic, strong) NSArray *usableCoupons;

@property (nonatomic, strong) PromotionFullCutModel *promotionModel;

@property (nonatomic, assign) NSUInteger score;

@property (nonatomic, strong) CouponFullCutModel *usedCoupon;

@property (nonatomic, assign) NSUInteger usedScore;

@property (nonatomic, readonly) CGFloat totalPrice;

@property (nonatomic, readonly) BOOL needPay;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
