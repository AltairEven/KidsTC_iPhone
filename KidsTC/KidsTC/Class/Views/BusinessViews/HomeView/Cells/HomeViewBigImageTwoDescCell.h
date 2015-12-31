//
//  HomeViewBigImageTwoDescCell.h
//  KidsTC
//
//  Created by Altair on 12/28/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBigImageTwoDescCellModel.h"

@class HomeViewBigImageTwoDescCell;

@protocol HomeViewBigImageTwoDescCellDelegate <NSObject>

- (void)bigImageTwoDescCell:(HomeViewBigImageTwoDescCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewBigImageTwoDescCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewBigImageTwoDescCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithCellModel:(HomeBigImageTwoDescCellModel *)model;

@end
