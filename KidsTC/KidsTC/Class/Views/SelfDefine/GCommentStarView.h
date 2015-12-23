//
//  GCommentStarView.h
//  iphone
//
//  Created by icson apple on 12-9-5.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GConfig.h"

@class GCommentStarView;

@protocol GCommentStarViewDelegate <NSObject>
@optional
- (void) gCommentstarView:(GCommentStarView *)starView ValueDidChange:(int) value;
@end

@interface GCommentStarView : UIView

@property (nonatomic, strong) UIImageView *star1;
@property (nonatomic, strong) UIImageView *star2;
@property (nonatomic, strong) UIImageView *star3;
@property (nonatomic, strong) UIImageView *star4;
@property (nonatomic, strong) UIImageView *star5;

@property (nonatomic, strong) GLabel *label1;
@property (nonatomic, strong) GLabel *label2;
@property (nonatomic, strong) GLabel *label3;
@property (nonatomic, strong) GLabel *label4;
@property (nonatomic, strong) GLabel *label5;

@property (nonatomic) int starValue;
@property (nonatomic, weak) id <GCommentStarViewDelegate> delegate;

- (id)initWithStarWidth:(CGFloat) starWidth andPadding:(CGFloat) padding;

@end

