//
//  CommentEditViewController.h
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "GViewController.h"

@class MyCommentListItemModel;
@class CommentEditViewController;

@protocol CommentEditViewControllerDelegate <NSObject>

- (void)commentEditViewControllerDidFinishSubmitComment:(CommentEditViewController *)vc;

@end

@interface CommentEditViewController : GViewController

@property (nonatomic, assign) id<CommentEditViewControllerDelegate> delegate;

- (instancetype)initWithMyCommentItem:(MyCommentListItemModel *)item;

@end
