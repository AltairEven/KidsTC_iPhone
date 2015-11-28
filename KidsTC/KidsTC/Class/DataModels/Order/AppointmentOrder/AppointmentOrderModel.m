//
//  AppointmentOrderModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppointmentOrderModel.h"

@implementation AppointmentOrderModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"orderId"]) {
            self.orderId = [NSString stringWithFormat:@"%@", [data objectForKey:@"orderId"]];
        }
        self.storeName = [data objectForKey:@"name"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.status = (AppointmentOrderStatus)[[data objectForKey:@"orderState"] integerValue];
        self.statusDescription = [data objectForKey:@"orderStateName"];
        self.appointmentTimeDes = [data objectForKey:@"time"];
        self.appointmentName = [data objectForKey:@"appointmentName"];
        self.phoneNumber = [data objectForKey:@"phone"];
    }
    return self;
}

- (BOOL)canComment {
    BOOL retValue = NO;
    if (self.status == AppointmentOrderStatusHasUsed) {
        retValue = YES;
    }
    return retValue;
}

- (BOOL)canCancel {
    BOOL retValue = NO;
    if (self.status == AppointmentOrderStatusWaitingUse || self.status == AppointmentOrderStatusPhoneConfirmed) {
        retValue = YES;
    }
    return retValue;
}

@end
