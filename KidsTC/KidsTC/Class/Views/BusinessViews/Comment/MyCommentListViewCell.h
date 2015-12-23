//
//  MyCommentListViewCell.h
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCommentListItemModel.h"

@class MyCommentListViewCell;

@protocol MyCommentListViewCellDelegate <NSObject>

- (void)myCommentListViewCell:(MyCommentListViewCell *)cell didClickedImageAtIndex:(NSInteger)index;

- (void)didClickedEditButton:(MyCommentListViewCell *)cell;

- (void)didClickedDeleteButton:(MyCommentListViewCell *)cell;

@end

@interface MyCommentListViewCell : UITableViewCell

@property (nonatomic, assign) id<MyCommentListViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithItemModel:(MyCommentListItemModel *)model;

@end
