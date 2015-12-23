//
//  FavouriteViewStoreCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteStoreItemModel.h"

@interface FavouriteViewStoreCell : UITableViewCell

- (void)configWithItemModel:(FavouriteStoreItemModel *)model;

+ (CGFloat)cellHeight;

@end
