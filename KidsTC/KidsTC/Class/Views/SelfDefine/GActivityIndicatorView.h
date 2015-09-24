//
//  GActivityIndicatorView.h
//  iphone51buy
//
//  Created by icson apple on 12-5-29.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GActivityIndicatorViewProtocol <NSObject>
- (void)animationCompleted;
@end

@interface GActivityIndicatorView : UIView
{
	UIImageView *loadingImageView;

	BOOL isAnimating;
}
@property(nonatomic,weak)id<GActivityIndicatorViewProtocol>delegate;
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
