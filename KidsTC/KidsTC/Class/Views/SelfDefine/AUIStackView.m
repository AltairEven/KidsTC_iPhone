//
//  AUIStackView.m
//  KidsTC
//
//  Created by 钱烨 on 7/29/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AUIStackView.h"

@interface AUIStackView ()

- (void)resetSubViews;

- (void)resizeWithSize:(CGSize)size;

@end

@implementation AUIStackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewGap = 10;
    }
    return self;
}


- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    self = [super awakeAfterUsingCoder:aDecoder];
    self.viewGap = 10;
    return self;
}


- (void)setSubViews:(NSArray *)subViews {
    _subViews = [NSArray arrayWithArray:subViews];
    [self resetSubViews];
}


- (void)resetSubViews {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    CGFloat viewWidth = 0;
    CGFloat viewHeight = 0;
    
    CGFloat xPosotion = 0;
    CGFloat yPosition = 0;
    NSUInteger index = 0;
    for (; index < [self.subViews count]; index ++) {
        UIView *view = [self.subViews objectAtIndex:index];
        [view setFrame:CGRectMake(xPosotion, yPosition, view.bounds.size.width, view.bounds.size.height)];
        [self addSubview:view];
        xPosotion += view.bounds.size.width + self.viewGap;
        viewWidth += view.bounds.size.width;
        if (viewHeight < view.bounds.size.height) {
            viewHeight = view.bounds.size.height;
        }
    }
    if (index > 0) {
        viewWidth += self.viewGap * (index - 1);
    }
    
    [self resizeWithSize:CGSizeMake(viewWidth, viewHeight)];
}


- (void)resizeWithSize:(CGSize)size {
    NSArray *starsViewConstraintsArray = [self constraints];
    if (starsViewConstraintsArray && [starsViewConstraintsArray count] > 0) {
        for (NSLayoutConstraint *constraint in starsViewConstraintsArray) {
            if (constraint.firstAttribute == NSLayoutAttributeWidth) {
                constraint.constant = size.width;
            }
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = size.height;
            }
        }
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
