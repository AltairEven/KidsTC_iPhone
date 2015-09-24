//
//  PlaceHolderTextView.m
//  iPhone51Buy
//
//  Created by Bai Haoquan on 13-4-23.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setText:self.placeHolderStr];
        [self setTextColor:self.placeHolderColor];
        [self setFont:self.placeHolderFont];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setText:self.placeHolderStr];
        [self setTextColor:OC_TEXT_COLOR];
        [self setFont:[UIFont systemFontOfSize:15.0f]];
    }
    
    return self;
}

//- (void)setDelegate:(id<UITextViewDelegate>)delegate
//{
//    // disable self.delegate, use newDelegate instead
//    return;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setIsPlaceHolderState:(BOOL)isPlaceHolderState
{
    if (_isPlaceHolderState != isPlaceHolderState)
    {
        _isPlaceHolderState = isPlaceHolderState;
        if (isPlaceHolderState)
        {
            [self setText:self.placeHolderStr];
            [self setTextColor:self.placeHolderColor];
            [self setFont:self.placeHolderFont];
        }
        else
        {
            [self setTextColor:self.contentColor];
            [self setFont:self.contentFont];
        }
    }
}

@end
