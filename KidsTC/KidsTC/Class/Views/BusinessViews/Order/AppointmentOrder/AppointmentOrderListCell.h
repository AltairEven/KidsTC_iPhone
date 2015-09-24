//
//  AppointmentOrderListCell.h
//  KidsTC
//
//  Created by 钱烨 on 8/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentOrderModel.h"

@interface AppointmentOrderListCell : UITableViewCell

- (void)configWithOrderModel:(AppointmentOrderModel *)model;

+ (CGFloat)cellHeight;

@end
