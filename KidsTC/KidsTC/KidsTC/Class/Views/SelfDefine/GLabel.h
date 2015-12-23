//
//  GLabel.h
//  iphone
//
//  Created by icson apple on 12-3-9.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UILabel+Additions.h"

@interface GLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
