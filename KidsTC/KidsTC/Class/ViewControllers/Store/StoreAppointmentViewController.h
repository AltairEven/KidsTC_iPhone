//
//  StoreAppointmentViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class StoreDetailModel;

@interface StoreAppointmentViewController : GViewController

+ (instancetype)instanceWithStoreDetailModel:(StoreDetailModel *)model;

@end
