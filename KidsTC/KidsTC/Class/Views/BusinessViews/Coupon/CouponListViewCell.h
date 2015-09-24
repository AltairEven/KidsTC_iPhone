//
//  CouponListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 9/6/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponFullCutModel.h"

@interface CouponListViewCell : UITableViewCell

- (void)configWithItemModel:(CouponBaseModel *)model;

+ (CGFloat)cellHeight;

@end
