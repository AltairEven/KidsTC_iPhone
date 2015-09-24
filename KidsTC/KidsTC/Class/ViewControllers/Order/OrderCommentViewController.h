//
//  OrderCommentViewController.h
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCommentModel.h"

@class OrderCommentViewController;

@protocol OrderCommentViewControllerDelegate <NSObject>

- (void)orderCommentVCDidFinishSubmitComment:(OrderCommentViewController *)vc;

@end

@interface OrderCommentViewController : GViewController

@property (nonatomic, assign) id<OrderCommentViewControllerDelegate> delegate;

- (instancetype)initWithOrderCommentModel:(OrderCommentModel *)model;

@end
