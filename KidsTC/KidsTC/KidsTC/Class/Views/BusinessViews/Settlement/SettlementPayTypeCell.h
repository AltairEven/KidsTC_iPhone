//
//  SettlementPayTypeCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/23/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentTypeModel.h"

@interface SettlementPayTypeCell : UITableViewCell

@property (nonatomic, strong) UIImage *logo;

@property (nonatomic, copy) NSString *paymentName;

+ (CGFloat)cellHeight;

@end
