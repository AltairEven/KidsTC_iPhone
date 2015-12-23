//
//  GMessageView.h
//  iphone51buy
//
//  Created by icson apple on 12-6-14.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface GMessageView : UIView
{
	UILabel *message;
}
- (void)show:(NSTimeInterval)hideTimeout;
- (void)hide;
+(GMessageView *)sharedMessageView;
@end