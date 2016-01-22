//
//  StrategyDetailRelatedServiceCell.h
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrategyDetailServiceItemModel.h"

@interface StrategyDetailRelatedServiceCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(StrategyDetailServiceItemModel *)model;

+ (CGFloat)cellHeight;

@end
