//
//  GBarButtonItem.m
//  iphone51buy
//
//  Created by CGS on 12-6-18.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GBarButtonItem.h"

@implementation GBarButtonItem

@synthesize _insideBtn;

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (self = [super init]) {
		_insideBtn = [GButton makeSimpleButton: GButtonTypeStrong frame: CGRectMake(0.0, 0.0, 0.0, 0.0) withTitle: title target: target clickAction: action];
		[_insideBtn setContentEdgeInsets: UIEdgeInsetsMake(6.0, 12.0, 6.0, 12.0)];

		[_insideBtn.titleLabel setFont: [UIFont systemFontOfSize: 14.0]];
		[_insideBtn sizeToFit];

		self.customView = _insideBtn;
    }

    return self;
}

- (id) initWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    if (self = [super init])
    {
        CGSize imageSize = [image size];
		_insideBtn = [GButton makeSimpleButton: GButtonTypeStrong frame: CGRectMake(0.0, 0.0, imageSize.width + 20, 30.0f) withTitle: @"" target: target clickAction: action];
        [_insideBtn setImage:image forState:UIControlStateNormal];
//		[_insideBtn sizeToFit];
        
		self.customView = _insideBtn;
    }
    
    return self;
}

- (id)initBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (self = [super init]) {
        _insideBtn = [GButton makeSimpleButton: GButtonTypeBack frame: CGRectMake(0.0, 0.0, 60.0, 30.0) withTitle: title target: target clickAction: action];
        [_insideBtn setContentEdgeInsets: UIEdgeInsetsMake(6.0, 17.0, 6.0, 12.0)];
        [_insideBtn.titleLabel setFont: [UIFont systemFontOfSize: 14.0]];
        [_insideBtn sizeToFit];
        
        self.customView = _insideBtn;
    }
    
    return self;
}

- (void)setNormalTitle:(NSString *)title {
	[_insideBtn setTitle:title forState:UIControlStateNormal];
}

- (void) setNormalImage:(UIImage *) image
{
    [_insideBtn setImage:image forState:UIControlStateNormal];
}

@end
