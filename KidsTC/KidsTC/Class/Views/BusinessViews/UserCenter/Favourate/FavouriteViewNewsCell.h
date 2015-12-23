//
//  FavouriteViewNewsCell.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteNewsItemModel.h"

@interface FavouriteViewNewsCell : UITableViewCell

- (void)configWithItemModel:(FavouriteNewsItemModel *)model;

+ (CGFloat)cellHeight;

@end
