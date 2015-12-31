//
//  HomeViewTwoThreeFourCell.h
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTwoThreeFourCellModel.h"

@class HomeViewTwoThreeFourCell;

@protocol HomeViewTwoThreeFourCellDelegate <NSObject>

- (void)homeCell:(HomeViewTwoThreeFourCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewTwoThreeFourCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewTwoThreeFourCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithCellModel:(HomeTwoThreeFourCellModel *)model;

@end
