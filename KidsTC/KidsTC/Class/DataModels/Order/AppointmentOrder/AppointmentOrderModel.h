//
//  AppointmentOrderModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/12/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

typedef enum {
    AppointmentOrderStatusWaitingUse,
    AppointmentOrderStatusHasUsed,
    AppointmentOrderStatusUserCanceled,
    AppointmentOrderStatusHasOverDate,
    AppointmentOrderStatusPhoneConfirmed,
    AppointmentOrderStatusPhoneCanceled,
    AppointmentOrderStatusHasCommented
}AppointmentOrderStatus;

typedef enum {
    AppointmentOrderListStatusAll = 0,
    AppointmentOrderListStatusWaitingUse = 1,
    AppointmentOrderListStatusWaitingComment = 6,
    AppointmentOrderListStatusHasOverDate = 3
}AppointmentOrderListStatus;

#import <Foundation/Foundation.h>

@interface AppointmentOrderModel : NSObject

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) AppointmentOrderStatus status;

@property (nonatomic, copy) NSString *statusDescription;

@property (nonatomic, copy) NSString *appointmentTimeDes;

@property (nonatomic, copy) NSString *appointmentName;

@property (nonatomic, copy) NSString *phoneNumber;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)canComment;

- (BOOL)canCancel;

@end
