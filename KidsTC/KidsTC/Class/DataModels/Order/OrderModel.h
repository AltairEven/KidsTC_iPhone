//
//  OrderModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentTypeModel.h"

typedef enum {
    OrderStatusWaitingPayment = 1,
    OrderStatusHasPayed,
    OrderStatusPartialUsed,
    OrderStatusAllUsed,
    OrderStatusHasCanceled,
    OrderStatusRefunding,
    OrderStatusRefundSucceed,
    OrderStatusRefundFailed,
    OrderStatusHasComment
}OrderStatus;

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *orderName;

@property (nonatomic, assign) NSUInteger productType;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, copy) NSString *orderDate;

@property (nonatomic, assign) OrderStatus status;

@property (nonatomic, copy) NSString *statusDescription;

@property (nonatomic, strong) PaymentTypeModel *pamentType;

@end
