//
//  FavouriteViewStrategyCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteStrategyItemModel.h"

@interface FavouriteViewStrategyCell : UITableViewCell

- (void)configWithItemModel:(FavouriteStrategyItemModel *)model;

+ (CGFloat)cellHeight;

@end
