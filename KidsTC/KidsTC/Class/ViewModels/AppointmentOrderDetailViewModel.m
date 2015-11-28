//
//  AppointmentOrderDetailViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderDetailViewModel.h"

@interface AppointmentOrderDetailViewModel () <AppointmentOrderDetailViewDataSource>

@property (nonatomic, weak) AppointmentOrderDetailView *view;

@property (nonatomic, strong) HttpRequestClient *cancelOrderRequest;

- (void)cancelOrderSucceed:(NSDictionary *)data;

- (void)cancelOrderFailed:(NSError *)error;

@end

@implementation AppointmentOrderDetailViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (AppointmentOrderDetailView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark AppointmentOrderDetailViewDataSource

- (AppointmentOrderModel *)orderModelForAppointmentOrderDetailView:(AppointmentOrderDetailView *)detailView {
    return self.orderModel;
}

#pragma mark Private methods

- (void)cancelOrderSucceed:(NSDictionary *)data {
    
}

- (void)cancelOrderFailed:(NSError *)error {
    
}

#pragma mark Public methods

- (void)cancelOrderWithSucceed:(void (^)())succeed failure:(void (^)(NSError *))failure {
    if (!self.cancelOrderRequest) {
        self.cancelOrderRequest = [HttpRequestClient clientWithUrlAliasName:@"ORDER_CANCLE_APPOINTMENTORDER"];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.orderModel.orderId forKey:@"orderId"];
    __weak AppointmentOrderDetailViewModel *weakSelf = self;
    [weakSelf.cancelOrderRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf cancelOrderSucceed:responseData];
        if (succeed) {
            succeed();
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf cancelOrderFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    [self.view reloadData];
}

@end
