//
//  StoreDetailCommentCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListItemModel.h"

@class StoreDetailCommentCell;

@protocol StoreDetailCommentCellDelegate <NSObject>

- (void)storeDetailCommentCell:(StoreDetailCommentCell *)cell didClickedImageAtIndex:(NSInteger)index;

@end

@interface StoreDetailCommentCell : UITableViewCell

@property (nonatomic, assign) id<StoreDetailCommentCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configWithModel:(CommentListItemModel *)model;

@end
