//
//  GToolbar.m
//  iphone51buy
//
//  Created by benxi on 8/16/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "GToolbar.h"

@implementation UIToolbar (CustomColor)

-(void)drawRect:(CGRect)rect
{
	[NAVBAR_BG_IMG drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

@implementation GToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
            [self setBackgroundImage:NAVBAR_BG_IMG forToolbarPosition:0 barMetrics:0];
		}
	}
	
    return self;
}

@end