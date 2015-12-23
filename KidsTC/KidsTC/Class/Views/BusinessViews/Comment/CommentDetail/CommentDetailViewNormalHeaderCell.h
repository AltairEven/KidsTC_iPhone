//
//  CommentDetailViewNormalHeaderCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListItemModel.h"

@class CommentDetailViewNormalHeaderCell;

@protocol CommentDetailViewNormalHeaderCellDelegate <NSObject>

- (void)headerCell:(CommentDetailViewNormalHeaderCell *)cell didChangedBoundsWithNewHeight:(CGFloat)height;

@end

@interface CommentDetailViewNormalHeaderCell : UITableViewCell

@property (nonatomic, assign) id<CommentDetailViewNormalHeaderCellDelegate> delegate;

- (void)configWithModel:(CommentListItemModel *)model;

@end
