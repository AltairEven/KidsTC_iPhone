//
//  StoreDetailStrategyCell.h
//  KidsTC
//
//  Created by Altair on 1/20/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentingStrategyListItemModel.h"

@interface StoreDetailStrategyCell : UITableViewCell

- (void)configWithItemModel:(ParentingStrategyListItemModel *)model;


+ (CGFloat)cellHeight;

@end
