//
//  StoreDetailTuanCell.h
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreTuanModel.h"

@interface StoreDetailTuanCell : UITableViewCell

- (void)configWithModel:(StoreTuanModel *)model;

+ (CGFloat)cellHeight;

@end
