//
//  GView.m
//  iphone51buy
//
//  Created by icson apple on 12-5-28.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "UIView+GViewExtension.h"

const char * const GViewExtensionObjKey = "iphone51buy.view.GViewExtension";

@implementation GViewExtensionObj
@synthesize loadingView, failedView, textLabel, activityIndicatorView, status, infoView;


@end

@implementation GExtFailedView
@synthesize failedTextLabel, retryButton, bgImgView;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame: frame]) {
        /* Background */
        UIImage *bgImg = LOADIMAGE(@"network_useless", @"png");
        bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, bgImg.size.width, bgImg.size.height)];
        bgImgView.center = self.center;
        bgImgView.image = bgImg;
        [self addSubview:bgImgView];
        
        failedTextLabel = MAKE_LABEL(CGRectMake(0.0, 0.0, self.frame.size.width - 20.0, 0.0), @"", COLOR_EBLACK, 13.0);
        [self addSubview: failedTextLabel];
		
		retryButton = [GButton makeSimpleButton: GButtonTypeWeak frame: CGRectMake(0.0, 0.0, 70.0, 30.0) withTitle: @"重试" target: nil clickAction: nil];
		[self addSubview: retryButton];
	}
	
	return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];

    bgImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/ 3);
	[failedTextLabel setFrame: CGRectMake(0.0, 0.0, self.frame.size.width > 120.0 ? (self.frame.size.width - 60.0) : self.frame.size.width, 0.0)];
	[failedTextLabel sizeToFit];
	[failedTextLabel setCenter: CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];

	[retryButton setCenter: CGPointMake(self.frame.size.width / 2.0, failedTextLabel.frame.origin.y + failedTextLabel.frame.size.height + 5.0 + self.retryButton.frame.size.height / 2.0)];
}

@end

@implementation GExtInfoView
@synthesize infoTextLabel;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame: frame]) {
		UILabel *label = MAKE_LABEL(CGRectZero, @"", COLOR_EBLACK, 13.0);
		[label setNumberOfLines: 0];
		[self addSubview: label];
		infoTextLabel = label;
	}

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[infoTextLabel setFrame: CGRectMake(0.0, 0.0, self.frame.size.width > 120.0 ? (self.frame.size.width - 60.0) : self.frame.size.width, 0.0)];
	[infoTextLabel sizeToFit];
	[infoTextLabel setCenter: CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0)];
}

@end

@implementation UIView(GViewExtension)

- (GViewExtensionObj *)getGViewExtensionObj
{
	GViewExtensionObj *obj = objc_getAssociatedObject(self, GViewExtensionObjKey);
	if (!obj) {
        GViewExtensionObj *extObj = [[GViewExtensionObj alloc] init];
		obj = extObj;
        //[extObj release];
		objc_setAssociatedObject(self, GViewExtensionObjKey, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC); 
	}

	return obj;
}

- (void)showLoading:(NSString *)loadingWords size:(GViewLoadingSize)_size
{
	GViewExtensionObj *obj = [self getGViewExtensionObj];
	if (!obj) {
		return;
	}

	[self resetStatus];
	if (!obj.loadingView) {
        UIView *view =[[UIView alloc] init];
		obj.loadingView = view;
		
        GActivityIndicatorView *gView = [[GActivityIndicatorView alloc] initWithFrame: CGRectZero];
		obj.activityIndicatorView = gView;
		[obj.loadingView addSubview: obj.activityIndicatorView];
		[obj.loadingView setBackgroundColor: RGBA(255.0, 255.0, 255.0, 1.0)];
		UILabel *label = MAKE_LABEL(CGRectZero, @"", [UIColor grayColor], 0.0);
		obj.textLabel = label;
        [obj.loadingView addSubview: obj.textLabel];
	}

	[obj.loadingView setFrame: self.frame];
	[obj.textLabel setText: loadingWords];

	if (_size == GViewLoadingSizeBig) {
		[obj.activityIndicatorView setFrame: CGRectMake(0.0, 0.0, 33.0, 62.0)];
		[obj.textLabel setFont: [UIFont systemFontOfSize: 15.0]];
		[obj.textLabel sizeToFit];

		[obj.activityIndicatorView setCenter: CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0 - obj.textLabel.frame.size.height / 2.0 - 1.0)];
		[obj.textLabel setCenter: CGPointMake(obj.loadingView.frame.size.width / 2.0, self.frame.size.height / 2.0 + obj.activityIndicatorView.frame.size.height / 2.0 + 1.0)];
	} else if (_size == GViewLoadingSizeSmall) {
		[obj.activityIndicatorView setFrame: CGRectMake(0.0, 0.0, 8.0, 16.0)];
		[obj.textLabel setFont: [UIFont systemFontOfSize: 12.0]];
		[obj.textLabel sizeToFit];

		[obj.activityIndicatorView setCenter: CGPointMake(self.frame.size.width / 2.0 - obj.textLabel.frame.size.width / 2.0 - 2.0, self.frame.size.height / 2.0)];
		[obj.textLabel setCenter: CGPointMake(self.frame.size.width / 2.0 + obj.activityIndicatorView.frame.size.width / 2.0 + 2.0, self.frame.size.height / 2.0)];
	} else if (_size == GViewLoadingSizeDefault) {
		[obj.activityIndicatorView setFrame: CGRectMake(0.0, 0.0, 17.0, 31.0)];
		[obj.textLabel setFont: [UIFont systemFontOfSize: 14.0]];
		[obj.textLabel sizeToFit];

		[obj.activityIndicatorView setCenter: CGPointMake(self.frame.size.width / 2.0 - obj.textLabel.frame.size.width / 2.0 - 2.0, self.frame.size.height / 2.0)];
		[obj.textLabel setCenter: CGPointMake(self.frame.size.width / 2.0 + obj.activityIndicatorView.frame.size.width / 2.0 + 2.0, self.frame.size.height / 2.0)];
	}

	if (self.superview) {
		[self.superview insertSubview: obj.loadingView aboveSubview: self];
	}

	[obj.activityIndicatorView startAnimating];
	obj.status = GViewStatusLoading;
}

- (void)showLoading:(NSString *)loadingWords
{
	[self showLoading: loadingWords size: GViewLoadingSizeDefault];
}

- (void)showFailed:(NSError *)error retryTarget:(id)_target retryAction:(SEL)_action
{
	GViewExtensionObj *obj = [self getGViewExtensionObj];
	if (!obj) {
		return;
	}

	[self resetStatus];
	if (!obj.failedView) {
		GExtFailedView *fView = [[GExtFailedView alloc] initWithFrame: CGRectZero];
		obj.failedView = fView;
		[obj.failedView setBackgroundColor: [UIColor whiteColor]];
	}
    
    NSString * msg = @"操作失败";
    if (error.userInfo) {
        if ([error.userInfo objectForKey:@"message"]) {
            msg = [error.userInfo objectForKey:@"message"];
        } else if ([error.userInfo objectForKey:@"returnData"]) {
            msg = [error.userInfo objectForKey:@"returnData"];
        }
    }
	
	[obj.failedView setFrame: self.frame];
    [obj.failedView.failedTextLabel setText:msg];
	if (_target && [_target respondsToSelector: _action]) {
		[obj.failedView.retryButton setHidden: NO];
		[obj.failedView.retryButton addTarget: _target action: _action forControlEvents: UIControlEventTouchUpInside];
	} else {
		[obj.failedView.retryButton setHidden: YES];
	}
    
	if (self.superview) {
		[self.superview insertSubview: obj.failedView aboveSubview: self];
	}
	
	obj.status = GViewStatusFailed;
}

- (void)showMsgWithAction:(NSString *)msg actionTarget:(id)target doAction:(SEL)action actionTitle:(NSString *)actTitile {
	GViewExtensionObj *obj = [self getGViewExtensionObj];
	if ( !obj ) {
		return;
	}
	
	[self resetStatus];
	if ( !obj.failedView ) {
        GExtFailedView *fView = [[GExtFailedView alloc] initWithFrame: CGRectZero];
		obj.failedView = fView;
		[obj.failedView setBackgroundColor: [UIColor whiteColor]];
	}
	
	[obj.failedView setFrame: self.frame];
	[obj.failedView.failedTextLabel setText:msg];
	
	if ( target && [target respondsToSelector: action]) {
		[obj.failedView.retryButton setTitle:actTitile forState:UIControlStateNormal];
		[obj.failedView.retryButton addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
		[obj.failedView.retryButton setHidden: NO];
	} else {
		[obj.failedView.retryButton setHidden: YES];
	}
    
	if ( self.superview ) {
		[self.superview insertSubview: obj.failedView aboveSubview: self];
	}
	
	obj.status = GViewStatusFailed;
}

- (void)showInfo:(NSString *)infoStr
{
	GViewExtensionObj *obj = [self getGViewExtensionObj];
	if (!obj) {
		return;
	}
	
	[self resetStatus];
	if (!obj.infoView) {
        GExtInfoView *iView = [[GExtInfoView alloc] initWithFrame: CGRectZero];
		obj.infoView = iView;
		[obj.infoView setBackgroundColor: [UIColor whiteColor]];
	}

	[obj.infoView setFrame: self.frame];
	[obj.infoView.infoTextLabel setText: infoStr ? infoStr : @""];
	
	if (self.superview) {
		[self.superview insertSubview: obj.infoView aboveSubview: self];
	}
	
	obj.status = GViewStatusInfo;
}

- (void)showFailed:(NSError *)error
{
	[self showFailed: error retryTarget: nil retryAction: nil];
}

- (void)resetStatus
{
	GViewExtensionObj *obj = [self getGViewExtensionObj];
	if (!obj) {
		return;
	}

	if (obj.loadingView) {
		[obj.activityIndicatorView stopAnimating];
		[obj.loadingView removeFromSuperview];
	}
	if (obj.failedView) {
		[obj.failedView removeFromSuperview];
	}

	if (obj.infoView) {
		[obj.infoView removeFromSuperview];
	}
	obj.status = GViewStatusNormal;
}

// adjust frame 

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x + horizontal, origionRect.origin.y + vertical, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}

- (void)moveHorizontal:(CGFloat)horizontal vertical:(CGFloat)vertical addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x + horizontal,
                                origionRect.origin.y + vertical,
                                origionRect.size.width + widthAdded,
                                origionRect.size.height + heightAdded);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(horizontal, vertical, origionRect.size.width, origionRect.size.height);
    self.frame = newRect;
}

- (void)moveToHorizontal:(CGFloat)horizontal toVertical:(CGFloat)vertical setWidth:(CGFloat)width setHeight:(CGFloat)height
{
    CGRect newRect = CGRectMake(horizontal, vertical, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width height:(CGFloat)height
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, height);
    self.frame = newRect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, width, origionRect.size.height);
    self.frame = newRect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect origionRect = self.frame;
    CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, origionRect.size.width, height);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded addHeight:(CGFloat)heightAdded
{
    CGRect originRect = self.frame;
    CGFloat newWidth = originRect.size.width + widthAdded;
    CGFloat newHeight = originRect.size.height + heightAdded;
    CGRect newRect = CGRectMake(originRect.origin.x, originRect.origin.y, newWidth, newHeight);
    self.frame = newRect;
}

- (void)addWidth:(CGFloat)widthAdded
{
    [self addWidth:widthAdded addHeight:0];
}

- (void)addHeight:(CGFloat)heightAdded
{
    [self addWidth:0 addHeight:heightAdded];
}

- (void)setCornerRadius:(CGFloat)radius
{
    [self setCornerRadius:radius borderColor:[UIColor grayColor]];
}

- (void)setCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor
{
    [self.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor:[borderColor CGColor]];
    [self.layer setBorderWidth:BORDER_WIDTH];
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
    self.clipsToBounds = YES;
}

- (CGRect)frameInWindow
{
    CGRect frameInWindow = [self.superview convertRect:self.frame
                                                toView:self.window];
    return frameInWindow;
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder)
    {
        [self resignFirstResponder];
        return YES;
    }
    
    for (UIView *subView in self.subviews)
    {
        if ([subView findAndResignFirstResponder])
        {
             return YES;
        }
    }
    
    return NO;
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder)
    {
        return self;
    }
    
    for (UIView *subView in self.subviews)
    {
        UIView *responder = [subView findFirstResponder];
        if (responder)
        {
            return responder;
        }
    }
    
    return nil;
}

@end
