//
//  ServiceDetailRelatedServiceCell.h
//  KidsTC
//
//  Created by Altair on 1/21/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceMoreDetailHotSalesItemModel.h"


@interface ServiceDetailRelatedServiceCell : UITableViewCell

- (void)configWithModel:(ServiceMoreDetailHotSalesItemModel *)model;

+ (CGFloat)cellHeight;

@end
