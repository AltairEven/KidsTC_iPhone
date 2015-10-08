//
//  ActivityViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityListItemModel;

@interface ActivityViewCell : UITableViewCell

- (void)configWithItemModel:(ActivityListItemModel *)itemModel;

@end
