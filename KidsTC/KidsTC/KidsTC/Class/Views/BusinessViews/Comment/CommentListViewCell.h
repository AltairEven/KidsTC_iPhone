//
//  CommentListViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListItemModel.h"

@class CommentListViewCell;

@protocol CommentListViewCellDelegate <NSObject>

- (void)commentListViewCell:(CommentListViewCell *)cell didClickedImageAtIndex:(NSInteger)index;

@end

@interface CommentListViewCell : UITableViewCell

@property (nonatomic, assign) id<CommentListViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithItemModel:(CommentListItemModel *)model;

@end
