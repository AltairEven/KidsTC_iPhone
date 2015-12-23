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

@class OrderDetailViewController;

@protocol OrderDetailViewControllerDelegate  <NSObject>

- (void)orderStatusChanged:(NSString *)orderId  needRefresh:(BOOL)need;

@end

@interface OrderDetailViewController : GViewController

@property (nonatomic, assign) id<OrderDetailViewControllerDelegate> delegate;

- (instancetype)initWithOrderId:(NSString *)orderId pushSource:(OrderDetailPushSource)source;

@end
