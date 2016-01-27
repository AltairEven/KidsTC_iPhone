//
//  CommentDetailViewStrategyHeaderCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextSegueModel.h"

@class ParentingStrategyDetailCellModel;
@class CommentDetailViewStrategyHeaderCell;

@protocol CommentDetailViewStrategyHeaderCellDelegate <NSObject>

- (void)didClickedCommentButtonOnCommentDetailViewStrategyHeaderCell:(CommentDetailViewStrategyHeaderCell *)cell;

- (void)didClickedRelatedInfoButtonOnCommentDetailViewStrategyHeaderCell:(CommentDetailViewStrategyHeaderCell *)cell;

- (void)commentDetailViewStrategyHeaderCell:(CommentDetailViewStrategyHeaderCell *)cell didSelectedLinkWithSegueModel:(HomeSegueModel *)model;

@end

@interface CommentDetailViewStrategyHeaderCell : UITableViewCell

@property (nonatomic, assign) id<CommentDetailViewStrategyHeaderCellDelegate> delegate;

- (void)configWithDetailCellModel:(ParentingStrategyDetailCellModel *)cellModel;

@end
