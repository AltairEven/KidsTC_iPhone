//
//  HomeViewNoticeCell.h
//  KidsTC
//
//  Created by Altair on 12/21/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNoticeCellModel.h"

@class HomeViewNoticeCell;

@protocol HomeViewNoticeCellDelegate <NSObject>

- (void)homeNoticeCell:(HomeViewNoticeCell *)cell didClickedAtIndex:(NSUInteger)index;

@end

@interface HomeViewNoticeCell : UITableViewCell

@property (nonatomic, assign) id<HomeViewNoticeCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(HomeNoticeCellModel *)model;

@end
