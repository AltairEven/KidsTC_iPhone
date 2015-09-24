//
//  GBarButtonItem.h
//  iphone51buy
//
//  Created by CGS on 12-6-18.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GButton.h"

@interface GBarButtonItem : UIBarButtonItem
- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (id) initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (id)initBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setNormalTitle:(NSString *)title;
- (void) setNormalImage:(UIImage *) image;

@property (nonatomic, strong) GButton *_insideBtn;
@end
