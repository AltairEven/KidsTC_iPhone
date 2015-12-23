/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：CustomBadge.h
 * 文件标识：
 * 摘 要：显示一个类似于系统budge数字的自定义控件，高度可自定制化。
 * CustomBadge *_cartBadge;
 *  _cartBadge = [CustomBadge customBadgeWithString:@"123"];
 *  _cartBadge.needShadow = YES;
 *  _cartBadge.badgeShining = NO;
 *
 *  [someView addSubview:_cartBadge];
 *  [_cartBadge setFrame:CGRectMake(228.0, -12.0, _cartBadge.frame.size.width, _cartBadge.frame.size.height)];
 *  [_cartBadge setNeedsLayout];
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-18-2012
 */


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomBadge : UIView {
	
	NSString *badgeText;
	UIColor *badgeTextColor;
	UIColor *badgeInsetColor;
	UIColor *badgeFrameColor;
	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
    BOOL needShadow;
}

@property(nonatomic,strong) NSString *badgeText;
@property(nonatomic,strong) UIColor *badgeTextColor;
@property(nonatomic,strong) UIColor *badgeInsetColor;
@property(nonatomic,strong) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;
@property(nonatomic,readwrite) BOOL needShadow;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString;
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;

@end
