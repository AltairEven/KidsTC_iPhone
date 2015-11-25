//
//  StoreAppointmentModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreDetailModel.h"
#import "ActivityLogoItem.h"

@interface StoreAppointmentModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray<ActivityLogoItem *> *activities;

@property (nonatomic, copy) NSString *appointmentTimeString;

@property (nonatomic, copy) NSString *appointmentPhoneNumber;

+ (instancetype)appointmentModelFromStroeDetailModel:(StoreDetailModel *)model;

@end
