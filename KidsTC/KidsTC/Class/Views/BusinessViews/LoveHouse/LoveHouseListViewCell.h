//
//  LoveHouseListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoveHouseListItemModel.h"

@class LoveHouseListViewCell;

@protocol LoveHouseListViewCellDelegate <NSObject>

- (void)didClickedGotoButtonOnLoveHouseListViewCell:(LoveHouseListViewCell *)cell;

- (void)didClickedNearbyButtonOnLoveHouseListViewCell:(LoveHouseListViewCell *)cell;

@end

@interface LoveHouseListViewCell : UITableViewCell

@property (nonatomic, assign) id<LoveHouseListViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(LoveHouseListItemModel *)model;

+ (CGFloat)cellHeight;

@end
