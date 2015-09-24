//
//  GCheckBox.m
//  iphone51buy
//
//  Created by icson apple on 12-6-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GCheckBox.h"



@implementation GCheckBox
@synthesize checked, delegate, touchEnable;

- (void)internalInit
{
    self.touchEnable = YES;
    [self setBackgroundColor: [UIColor clearColor]];
    [self addTarget: self action: @selector(toggleChecked) forControlEvents: UIControlEventTouchUpInside];
    [self setChecked: YES];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self internalInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder]) {
        [self internalInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andType:(NSInteger)newType
{
	if (self = [super initWithFrame: frame]) {
        self.type = newType;
		[self internalInit];
    }
    return self;
}

- (void)toggleChecked
{
    //add by Altair, 20141124
    if (!self.touchEnable) {
        return;
    }
	[self setChecked: !checked];
	if (delegate) {
		[delegate gCheckBox: self checked: checked];
	}
}

- (void)setType:(NSInteger)type
{
    if (_type != type) {
        _type = type;
        [self setChecked:checked];
    }
}

- (void)setChecked:(BOOL)_checked
{
    //add by Altair, 20141124
    if (!self.touchEnable) {
        return;
    }
	UIImage *image = nil;
	if(self.type == GCheckBoxSelect)
	{
		image= [ UIImage imageNamed: _checked ? @"check_2.png" : @"check.png" ];
	}
	else if(self.type == GCheckBoxPromo)
	{
		image = [UIImage imageNamed:_checked? @"cart_checked" : @"cart_check"];
	}
    else if(self.type == GCheckBoxLogin)
    {
        image = [UIImage imageNamed:_checked? @"log_checkbox" : @"log_checkbox_nor"];
    }
	else
	{
		image= [ UIImage imageNamed: _checked ? @"filter_check_2.png" : @"filter_check_1.png" ];
	}
	[image stretchableImageWithLeftCapWidth: 1.0 topCapHeight: 1.0];
	[self setBackgroundImage:image forState:UIControlStateNormal];
	[self setBackgroundImage:image forState:UIControlStateHighlighted];
	checked = _checked;

//	if (delegate) {
//		[delegate gCheckBox: self checked: checked];
//	}
}

@end
