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

#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    [self.view reloadData];
}

@end
