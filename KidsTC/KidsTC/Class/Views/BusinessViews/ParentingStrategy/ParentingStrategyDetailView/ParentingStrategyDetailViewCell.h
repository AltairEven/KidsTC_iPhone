//
//  ParentingStrategyDetailViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextSegueModel.h"

@class ParentingStrategyDetailCellModel;
@class ParentingStrategyDetailViewCell;

@protocol ParentingStrategyDetailViewCellDelegate <NSObject>

- (void)didClickedLocationButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell;

- (void)didClickedCommentButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell;

- (void)didClickedRelatedInfoButtonOnParentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell;

- (void)parentingStrategyDetailViewCell:(ParentingStrategyDetailViewCell *)cell didSelectedLinkWithSegueModel:(HomeSegueModel *)model;

@end


@interface ParentingStrategyDetailViewCell : UITableViewCell

@property (nonatomic, assign) id<ParentingStrategyDetailViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithDetailCellModel:(ParentingStrategyDetailCellModel *)cellModel;

@end
