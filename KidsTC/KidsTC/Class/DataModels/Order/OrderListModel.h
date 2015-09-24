//
//  OrderListModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "OrderModel.h"

typedef enum {
    OrderListTypeAll = 1,
    OrderListTypeWaitingPayment,
    OrderListTypeWaitingUser,
    OrderListTypeWaitingComment,
    OrderListTypeHasCommented
}OrderListType;

@interface OrderListModel : OrderModel

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
