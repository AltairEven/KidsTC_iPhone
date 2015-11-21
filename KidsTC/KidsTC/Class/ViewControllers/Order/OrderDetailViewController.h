//
//  OrderDetailViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

typedef enum {
    OrderDetailPushSourceOrderList,
    OrderDetailPushSourceSettlement
}OrderDetailPushSource;

@interface OrderDetailViewController : GViewController

- (instancetype)initWithOrderId:(NSString *)orderId pushSource:(OrderDetailPushSource)source;

@end
