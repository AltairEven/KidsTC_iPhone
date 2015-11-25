//
//  StoreAppointmentModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/18/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreAppointmentModel.h"

@implementation StoreAppointmentModel

+ (instancetype)appointmentModelFromStroeDetailModel:(StoreDetailModel *)model {
    if (!model) {
        return nil;
    }
    StoreAppointmentModel *appointmentModel = [[StoreAppointmentModel alloc] init];
    appointmentModel.storeId = model.storeId;
    appointmentModel.activities = model.activeModelsArray;
    appointmentModel.appointmentTimeString = @"";
    return appointmentModel;
}

@end
