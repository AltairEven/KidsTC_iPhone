//
//  GButton.m
//  iphone
//
//  Created by icson apple on 12-2-22.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GButton.h"

@implementation GButton

- (id)initWithFrame:(CGRect)frame buttonType:(NSInteger)_buttonType
{
	if (self = [super initWithFrame:frame]) {
        @autoreleasepool {
            customeButtonType = _buttonType;

            [self setTitleColor: BUTTON_DISABLED_TITLE_COLOR forState: UIControlStateDisabled];
            
            if (customeButtonType == GButtonTypeStrong || customeButtonType == GButtonTypeWeak || customeButtonType == GButtonTypeYellow || customeButtonType == GButtonTypeBack || customeButtonType == GButtonTypeAlarm || customeButtonType == GButtonTypeLogin) {
                NSString *bgImgName = @"";
                if (customeButtonType == GButtonTypeStrong) {
                    bgImgName = @"btn_bg_strong";
                } else if(customeButtonType == GButtonTypeWeak){
                    bgImgName = @"btn_bg_weak";
                } else if(customeButtonType == GButtonTypeYellow){
                    bgImgName = @"btn_bg_yellow";
                } else if(customeButtonType == GButtonTypeBack){
                    bgImgName = @"btn_back";
                } else if(customeButtonType == GButtonTypeAlarm){
                    bgImgName = @"btn_bg_alarm";
                }
                else if (customeButtonType == GButtonTypeLogin)
                {
                    bgImgName = @"button_login_1";
                }
                
                UIImage *img = LOADIMAGE(bgImgName, @"png");
				UIImage *imgHighlighted = LOADIMAGE(([NSString stringWithFormat:@"%@_highlight", bgImgName]), @"png");
                UIImage *imgDisabled = LOADIMAGE(@"btn_bg_disabled", @"png");
                
                if (customeButtonType != GButtonTypeBack) {
                    img = [img stretchableImageWithLeftCapWidth: floorf(img.size.width/2) topCapHeight: floorf(img.size.height/2)];
                    imgHighlighted = [imgHighlighted stretchableImageWithLeftCapWidth: floorf(imgHighlighted.size.width/2) topCapHeight: floorf(imgHighlighted.size.height/2)];
                } else {
                    img = [img stretchableImageWithLeftCapWidth: 12.0 topCapHeight: 0.0];
                    imgHighlighted = [imgHighlighted stretchableImageWithLeftCapWidth: 12.0 topCapHeight: 0.0];
                }
                
                imgDisabled = [imgDisabled stretchableImageWithLeftCapWidth: floorf(imgDisabled.size.width/2) topCapHeight: floorf(imgDisabled.size.height/2)];
                [self setBackgroundImage: img forState: UIControlStateNormal];
                [self setBackgroundImage: imgHighlighted forState: UIControlStateHighlighted];
                [self setBackgroundImage: imgDisabled forState: UIControlStateDisabled];
            }
        }
	}

	return self;
}

+ (GButton *) makeSimpleButton:(GButtonType) buttonType frame:(CGRect) rect  withTitle:(NSString *) title target:(id) target clickAction: (SEL)action
{
	GButton *btn;
	if (buttonType == GButtonTypeStrong || buttonType == GButtonTypeWeak || buttonType == GButtonTypeYellow || buttonType == GButtonTypeBack || buttonType == GButtonTypeAlarm || buttonType == GButtonTypeLogin) {
		btn = [[self alloc] initWithFrame: rect buttonType: buttonType];
		[btn setTitle:title forState:UIControlStateNormal];
		[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		return btn;
	} else {
		btn = [GButton buttonWithType: buttonType];
		[btn setFrame: rect];
		[btn setTitle:title forState:UIControlStateNormal];
		[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		return btn;
	}
}
/*
- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
	return bounds;
}
- (CGRect)contentRectForBounds:(CGRect)bounds
{
	return bounds;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
	return CGRectMake(0.0, 0.0, 200.0, 30.0);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
	return contentRect;
}*/
@end
