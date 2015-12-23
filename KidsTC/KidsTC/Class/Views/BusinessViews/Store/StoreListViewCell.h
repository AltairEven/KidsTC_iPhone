//
//  StoreListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiveStarsView.h"
#import "StoreListItemModel.h"

@interface StoreListViewCell : UITableViewCell

- (void)configWithItemModel:(StoreListItemModel *)model;

@end
