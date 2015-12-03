//
//  FavouriteViewServiceCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteServiceItemModel.h"

@interface FavouriteViewServiceCell : UITableViewCell

- (void)configWithItemModel:(FavouriteServiceItemModel *)model;

+ (CGFloat)cellHeight;

@end
