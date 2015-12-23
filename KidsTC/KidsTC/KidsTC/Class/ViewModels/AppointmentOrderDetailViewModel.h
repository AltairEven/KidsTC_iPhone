//
//  AppointmentOrderDetailViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "AppointmentOrderDetailView.h"

@interface AppointmentOrderDetailViewModel : BaseViewModel

@property (nonatomic, strong) AppointmentOrderModel *orderModel;

- (void)cancelOrderWithSucceed:(void(^)())succeed failure:(void(^)(NSError *error))failure;

@end
