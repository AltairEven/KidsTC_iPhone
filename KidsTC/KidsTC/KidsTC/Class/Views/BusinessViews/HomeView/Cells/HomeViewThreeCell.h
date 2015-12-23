//
//  HomeViewThreeCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeThreeCellModel.h"

@class HomeViewThreeCell;

@protocol HomeViewThreeCellDelegate <NSObject>

- (void)homeViewThreeCell:(HomeViewThreeCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewThreeCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewThreeCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeThreeCellModel *)model;

@end
