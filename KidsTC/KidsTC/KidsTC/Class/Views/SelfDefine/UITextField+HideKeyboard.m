//
//  UITextField+HideKeyboard.m
//  iphone51buy
//
//  Created by benxi on 7/19/12.
//  Copyright (c) 2012 icson. All rights reserved.
//

#import "UITextField+HideKeyboard.h"

@implementation UITextField(HideKeyboard)

- (void)hideKeyboard:(UIView *)view {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doHideKeyboard)];
	
	tap.numberOfTapsRequired = 1;
	[view addGestureRecognizer:tap];
	[tap setCancelsTouchesInView:NO];
}

- (void)doHideKeyboard {
	[self resignFirstResponder];
}

@end
