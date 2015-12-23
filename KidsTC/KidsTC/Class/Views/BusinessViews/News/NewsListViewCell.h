//
//  NewsListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsListItemModel.h"

@interface NewsListViewCell : UITableViewCell

- (void)configWithItemModel:(NewsListItemModel *)model;

+ (CGFloat)cellHeight;

@end
