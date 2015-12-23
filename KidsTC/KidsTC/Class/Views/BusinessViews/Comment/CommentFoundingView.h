//
//  CommentFoundingView.h
//  KidsTC
//
//  Created by Altair on 11/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFoundingModel.h"

#define MINCOMMENTLENGTH (10)

@class CommentFoundingView;

@protocol CommentFoundingViewDelegate <NSObject>

- (void)didClickedAddPhotoButtonOnCommentFoundingView:(CommentFoundingView *)commentView;

- (void)commentFoundingView:(CommentFoundingView *)commentView didClickedThumbImageAtIndex:(NSUInteger)index;

- (void)didClickedSubmitButtonOnCommentFoundingView:(CommentFoundingView *)commentView;

@end

@interface CommentFoundingView : UIView

@property (nonatomic, assign) id<CommentFoundingViewDelegate> delegate;

@property (nonatomic, strong) CommentFoundingModel *commentModel;

- (void)reloadData;

- (void)resetPhotoViewWithImagesArray :(NSArray *)imagesArray;

- (void)endEditing;

@end
