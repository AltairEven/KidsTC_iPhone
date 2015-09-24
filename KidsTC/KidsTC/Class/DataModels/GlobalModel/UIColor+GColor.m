//
//  UIColor+GColor.m
//  iphone51buy
//
//  Created by icson apple on 12-6-12.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "UIColor+GColor.h"

@implementation UIColor (GColor)
+ (UIColor *)colorWithNSInteger:(NSUInteger)_uinteger
{
	return [UIColor colorWithRed: (0xFF & (_uinteger >> 16)) / 255.0 green: (0xFF & (_uinteger >> 8)) / 255.0 blue: (0xFF & (_uinteger))/255.0 alpha: (0xFF & (_uinteger >> 24)) / 255.0];
}
@end
