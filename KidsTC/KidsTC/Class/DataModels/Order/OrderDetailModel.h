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

@property (nonatomic, copy) NSString *phone;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)supportRefund;

- (BOOL)canGetCode;

@end
