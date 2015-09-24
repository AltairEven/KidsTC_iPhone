//
//  StoreAppointmentModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreAppointmentModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *appointmentName;

@property (nonatomic, copy) NSString *appointmentTimeString;

@property (nonatomic, copy) NSString *appointmentPhoneNumber;

@end
