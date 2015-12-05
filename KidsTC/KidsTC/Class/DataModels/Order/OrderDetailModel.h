//
//  OrderDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderModel.h"

@interface OrderDetailModel : OrderModel

@property (nonatomic, assign) CGFloat servicePrice;

@property (nonatomic, assign) NSUInteger serviceCount;

@property (nonatomic, strong) NSArray *supportedInsurances;

@property (nonatomic, assign) CGFloat originalAmount;

@property (nonatomic, assign) NSUInteger usedPointNumber;

@property (nonatomic, assign) CGFloat discountAmount;

@property (nonatomic, copy) NSString *orderDetailDescription;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, assign) BOOL canRefund;

@property (nonatomic, assign) BOOL canContactCS;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)canGetCode;

@end
