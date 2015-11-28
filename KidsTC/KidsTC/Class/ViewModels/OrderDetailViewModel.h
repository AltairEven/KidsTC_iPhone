//
//  OrderDetailViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "OrderDetailView.h"
#import "OrderDetailModel.h"

@interface OrderDetailViewModel : BaseViewModel

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, strong, readonly) OrderDetailModel *detailModel;

- (void)cancelOrder;

- (void)refund;

- (void)getConsumeCodeWithSucceed:(void(^)())succeed failure:(void(^)(NSError *error))failure;

@end
