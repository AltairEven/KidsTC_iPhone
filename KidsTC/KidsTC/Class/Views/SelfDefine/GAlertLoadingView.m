//
//  GAlertLoadingView.m
//  iphone51buy
//
//  Created by icson apple on 12-6-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GAlertLoadingView.h"

@interface GAlertLoadingView()
@property(nonatomic,copy)CompletitionAfterHideBlock block;
@end

@implementation GAlertLoadingView

static GAlertLoadingView *_sharedAlertLoadingView;
+(GAlertLoadingView *)sharedAlertLoadingView
{
    @synchronized([GAlertLoadingView class]){
		if (!_sharedAlertLoadingView) {
			_sharedAlertLoadingView = [[GAlertLoadingView alloc] init];
		}

		return _sharedAlertLoadingView;
	}

	return nil;
}

- (id)init
{
    self = [super init];
    if (self) {
		bgView = [[UIView alloc] initWithFrame: CGRectZero];
		[bgView setBackgroundColor: [UIColor blackColor]];
        bgView.layer.opaque = NO;
		bgView.layer.opacity = 0.2;
		[self addSubview: bgView];
		[self sendSubviewToBack: bgView];

		centerView = [[UIView alloc] initWithFrame: CGRectMake(0.0, 0.0, 100.0, 100.0)];
        centerView.layer.cornerRadius = 5.0;
        [self addSubview: centerView];
    }
    return self;
}

- (void)show
{
	[self setBackgroundColor: [UIColor clearColor]];
	UIWindow *w = [UIApplication sharedApplication].keyWindow;

	CGSize wSize = w.frame.size;
	self.frame = CGRectMake(0.0, 0.0, wSize.width, wSize.height);
	bgView.frame = CGRectMake(0.0, 0.0, wSize.width, wSize.height);
	[w addSubview: self];
    [w bringSubviewToFront: self];
    
    indicatorView = [[GActivityIndicatorView alloc] initWithFrame: CGRectMake(0.0, 0.0, 100.0, 100.0)];
    indicatorView.delegate = self;
    [indicatorView setCenter: CGPointMake(50.0, 50.0)];
    [centerView addSubview: indicatorView];

    [centerView setCenter: CGPointMake(wSize.width / 2.0, wSize.height / 2.0)];
	[indicatorView startAnimating];
}

- (void)showInView:(UIView*)viewTemp
{
	[self setBackgroundColor: [UIColor clearColor]];
    
	CGSize wSize = viewTemp.frame.size;
	self.frame = CGRectMake(0.0, 0.0, wSize.width, wSize.height);
	bgView.frame = CGRectMake(0.0, 0.0, wSize.width, wSize.height);
	[viewTemp addSubview: self];
    [viewTemp bringSubviewToFront: self];
    
    indicatorView = [[GActivityIndicatorView alloc] initWithFrame: CGRectMake(0.0, 0.0, 100.0, 100.0)];
    indicatorView.delegate = self;
    [indicatorView setCenter: CGPointMake(50.0, 50.0)];
    [centerView addSubview: indicatorView];
    
	[centerView setCenter: CGPointMake(wSize.width / 2.0, wSize.height / 2.0)];
	[indicatorView startAnimating];
}

- (void)hide
{
	[indicatorView stopAnimating];
	[self removeFromSuperview];
    [indicatorView removeFromSuperview];
    indicatorView = nil;
}

- (void)hideWithCompletitionBlock:(CompletitionAfterHideBlock)b
{
	LOG_METHOD
	self.block = [b copy];
}

#pragma mark- GActivityIndicatorViewProtocol methods
- (void)animationCompleted
{
	LOG_METHOD
	if(_block)
	{
		_block();
		_block = nil;
	}
	//[self removeFromSuperview];
}
@end
