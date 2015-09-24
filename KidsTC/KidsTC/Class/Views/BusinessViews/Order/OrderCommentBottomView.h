//
//  OrderCommentBottomView.h
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderCommentBottomView;

@protocol OrderCommentBottomViewDelegate <NSObject>

- (void)didClickedSubmitButtonOnOrderCommentBottomView:(OrderCommentBottomView *)bottomView;

@end

@interface OrderCommentBottomView : UIView

@property (nonatomic, assign) id<OrderCommentBottomViewDelegate> delegate;

@property (nonatomic, readonly) BOOL needHideName;

@end
