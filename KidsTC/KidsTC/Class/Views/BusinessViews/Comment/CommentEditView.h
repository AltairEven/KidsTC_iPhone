//
//  CommentEditView.h
//  KidsTC
//
//  Created by Altair on 12/2/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentEditingModel.h"

#define MINCOMMENTLENGTH (10)

@class CommentEditView;

@protocol CommentEditViewDelegate <NSObject>

- (void)didClickedAddPhotoButtonOnCommentEditView:(CommentEditView *)editView;

- (void)commentEditView:(CommentEditView *)editView didClickedThumbImageAtIndex:(NSUInteger)index;

- (void)didClickedSubmitButtonOnCommentEditView:(CommentEditView *)editView;

@end

@interface CommentEditView : UIView

@property (nonatomic, assign) id<CommentEditViewDelegate> delegate;

@property (nonatomic, strong) CommentEditingModel *commentModel;

- (void)reloadData;

- (void)resetPhotoViewWithImagesArray :(NSArray *)imagesArray;

- (void)endEditing;

@end
