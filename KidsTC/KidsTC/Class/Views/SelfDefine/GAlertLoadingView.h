//
//  GAlertLoadingView.h
//  iphone51buy
//
//  Created by icson apple on 12-6-13.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "GActivityIndicatorView.h"

typedef  void (^CompletitionAfterHideBlock)();

@interface GAlertLoadingView : UIView<GActivityIndicatorViewProtocol>
{
	UIView *bgView;
	UIView *centerView;
	GActivityIndicatorView *indicatorView;
	CompletitionAfterHideBlock _block;
}
- (void)show;
- (void)hide;
- (void)hideWithCompletitionBlock:(CompletitionAfterHideBlock)b;

- (void)showInView:(UIView*)viewTemp;
+(GAlertLoadingView *)sharedAlertLoadingView;
@end
