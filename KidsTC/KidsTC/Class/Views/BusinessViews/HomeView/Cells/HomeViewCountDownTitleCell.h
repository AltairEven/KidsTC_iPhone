//
//  HomeViewCountDownTitleCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCountDownTitleCellModel.h"

@interface HomeViewCountDownTitleCell : UITableViewCell

- (void)configWithModel:(HomeCountDownTitleCellModel *)model;

- (void)stopCountDown;

@end
