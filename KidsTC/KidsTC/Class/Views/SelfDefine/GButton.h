//
//  GButton.h
//  iphone
//
//  Created by icson apple on 12-2-22.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GToolUtil.h"

enum{
	GButtonTypeStrong = 0x1000,
	GButtonTypeWeak,
	GButtonTypeYellow,
	GButtonTypeBack,
	GButtonTypeAlarm,
    GButtonTypeLogin,
};

typedef NSUInteger GButtonType;

@interface GButton : UIButton
{
	NSInteger customeButtonType;
	UIImageView *_bgImgView;
}

+ (GButton *) makeSimpleButton:(GButtonType) buttonType frame:(CGRect) rect  withTitle:(NSString *) title target:(id) target clickAction: (SEL)action;
@end
