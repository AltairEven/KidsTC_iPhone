//
//  GInfoView.m
//  iphone51buy
//
//  Created by CGS on 12-6-26.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GInfoView.h"

@implementation GInfoViewProxy
@synthesize delegate;
- (void)startTimer:(SEL)action
{
    if (delegate && [delegate respondsToSelector: action]) {
        if ( hideSelfTimer ) {
            [hideSelfTimer invalidate];
			hideSelfTimer = nil;
        }
        hideSelfTimer = [NSTimer scheduledTimerWithTimeInterval:2.5 target: delegate selector: action userInfo: nil repeats: NO];
    }
}

- (void)invalidate {
    if ( hideSelfTimer ) {
        [hideSelfTimer invalidate];
		hideSelfTimer = nil;
    }
}

- (void)dealloc {
    [self invalidate];

}
@end

@implementation GInfoView

static GInfoView *_sharedInfoView;
+(GInfoView *)sharedInfoView
{
    @synchronized([self class]){
		if (!_sharedInfoView) {
			_sharedInfoView = [[[self class] alloc] init];
		}
        
		return _sharedInfoView;
	}
    
	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        textLabel = MAKE_LABEL_WITH_INSETS(CGRectZero, UIEdgeInsetsMake(4.0, 10.0, 4.0, 10.0), @"", [UIColor whiteColor], 12.0);
        textLabel.layer.cornerRadius = 4.0;
        textLabel.layer.borderWidth = 1.0;
        textLabel.layer.borderColor = [RGBA(100.0, 100.0, 100.0, 1.0) CGColor];
        textLabel.backgroundColor = COLOR_EBLACK;
        [textLabel setClipsToBounds: YES];
        [self addSubview: textLabel];

        self.layer.cornerRadius = 4.0;
        self.layer.shadowRadius = 4.0;
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self setFrame: CGRectZero];

        proxy = [[GInfoViewProxy alloc] init];
        [proxy setDelegate: self];
    }
    return self;
}

- (void)dealloc
{
    [proxy invalidate];
     proxy = nil;
}

- (void)showMessage:(NSString *)message
{
    [proxy invalidate];
	UIWindow *w = [UIApplication sharedApplication].keyWindow;
	CGSize wSize = w.frame.size;
    [textLabel setText: message];

    CGSize maxSize = CGSizeMake(200.0 - 20.0, 9999.0);
    CGSize size = [textLabel.text sizeWithFont:textLabel.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    
//    CATransition *anim = [CATransition animation];
//    anim.duration = 0.3;
//    anim.type = kCATransitionFade;
//    anim.subtype = kCATransitionFromBottom;
//    [self.layer addAnimation: anim forKey: kCATransition];
    [self setFrame: CGRectMake((wSize.width - size.width - 20.0) / 2.0, wSize.height - 100.0 - size.height - 8.0, size.width + 20.0, size.height + 8.0)];
    [textLabel setFrame: CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];

    if (self.superview != w) {
        [w addSubview: self];
    }
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
        [w bringSubviewToFront: self];
    }];

    [proxy startTimer: @selector(hide)];
}

- (void)hide
{
//    CATransition *anim = [CATransition animation];
//    anim.duration = 0.3;
//    anim.type = kCATransitionFade;
//    anim.subtype = kCATransitionFromBottom;
//    [self.layer addAnimation: anim forKey: kCATransition];
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

@end
