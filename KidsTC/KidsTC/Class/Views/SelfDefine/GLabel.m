//
//  GLabel.m
//  iphone
//
//  Created by icson apple on 12-3-9.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GLabel.h"

@implementation GLabel
@synthesize insets;

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)_insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = _insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)_insets {
    self = [super init];
    if(self){
        self.insets = _insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

-(void)setInsets:(UIEdgeInsets)_insets
{
	insets = _insets;
	[self layoutIfNeeded];
}
@end