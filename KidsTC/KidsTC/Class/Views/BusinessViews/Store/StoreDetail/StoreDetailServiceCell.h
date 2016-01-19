//
//  StoreDetailServiceCell.h
//  KidsTC
//
//  Created by Altair on 1/16/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreOwnedServiceModel.h"

@interface StoreDetailServiceCell : UITableViewCell

- (void)configWithModel:(StoreOwnedServiceModel *)model;

+ (CGFloat)cellHeight;

@end
