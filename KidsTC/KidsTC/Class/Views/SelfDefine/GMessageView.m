//
//  GMessageView.m
//  iphone51buy
//
//  Created by icson apple on 12-6-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GMessageView.h"

@implementation GMessageView

static GMessageView *_sharedMessageView;
+(GMessageView *)sharedMessageView
{
    @synchronized([GMessageView class]){
		if (!_sharedMessageView) {
			_sharedMessageView = [[GMessageView alloc] init];
		}
		
		return _sharedMessageView;
	}
	
	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {		
		message = MAKE_LABEL(CGRectMake(0.0, 0.0, 20.0, 200.0), @"xxx", COLOR_BLUE, 14.0);
		[message setBackgroundColor: [UIColor whiteColor]];
		message.layer.cornerRadius = 5.0;

		[self addSubview: message];
    }
    return self;
}


- (void)show:(NSTimeInterval)hideTimeout
{
	[self setBackgroundColor: [UIColor clearColor]];
	UIWindow *w = [UIApplication sharedApplication].keyWindow;
	
	CGSize wSize = w.frame.size;
	self.frame = CGRectMake(0.0, 0.0, wSize.width, wSize.height);
	[w addSubview: self];
	[w bringSubviewToFront: self];
	
	[message setCenter: CGPointMake(wSize.width / 2.0, wSize.height / 2.0)];
}

- (void)hide
{
	[self removeFromSuperview];
}
@end
