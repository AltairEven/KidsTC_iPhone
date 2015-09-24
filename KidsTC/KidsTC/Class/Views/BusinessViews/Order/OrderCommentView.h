//
//  OrderCommentView.h
//  KidsTC
//
//  Created by 钱烨 on 7/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCommentModel.h"

#define MINCOMMENTLENGTH (10)

@class OrderCommentView;

@protocol OrderCommentViewDelegate <NSObject>

- (void)didClickedAddPhotoButtonOnOrderCommentView:(OrderCommentView *)commentView;

- (void)orderCommentView:(OrderCommentView *)commentView didClickedThumbImageAtIndex:(NSUInteger)index;

- (void)didClickedSubmitButtonOnOrderCommentView:(OrderCommentView *)commentView;

@end

@interface OrderCommentView : UIView

@property (nonatomic, assign) id<OrderCommentViewDelegate> delegate;

@property (nonatomic, strong) OrderCommentModel *commentModel;

- (void)reloadData;

- (void)resetPhotoViewWithImagesArray :(NSArray *)imagesArray;

- (void)endEditing;

@end
