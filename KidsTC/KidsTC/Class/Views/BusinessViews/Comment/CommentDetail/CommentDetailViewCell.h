//
//  CommentDetailViewCell.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentReplyItemModel.h"

@interface CommentDetailViewCell : UITableViewCell

- (void)configWithModel:(CommentReplyItemModel *)model;

@end
