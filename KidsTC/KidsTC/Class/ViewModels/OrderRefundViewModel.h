//
//  OrderRefundViewModel.h
//  KidsTC
//
//  Created by Altair on 11/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderRefundView.h"

@interface OrderRefundViewModel : BaseViewModel

@property (nonatomic, strong) OrderRefundModel *refundModel;

- (void)createOrderRefundWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

@end
