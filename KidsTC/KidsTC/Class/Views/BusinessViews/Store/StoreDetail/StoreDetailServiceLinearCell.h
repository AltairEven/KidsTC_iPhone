//
//  StoreDetailServiceLinearCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreOwnedServiceModel.h"

@interface StoreDetailServiceLinearCell : UITableViewCell

- (void)configWithModel:(StoreOwnedServiceModel *)model;

+ (CGFloat)cellHeight;

@end
