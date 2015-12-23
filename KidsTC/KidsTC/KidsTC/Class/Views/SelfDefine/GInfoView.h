//
//  GInfoView.h
//  iphone51buy
//
//  Created by CGS on 12-6-26.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface GInfoViewProxy : NSObject
{
    NSTimer *hideSelfTimer;
}
@property (weak, nonatomic) id delegate;
@end

@interface GInfoView : UIView
{
    UILabel *textLabel;
    GInfoViewProxy *proxy;
}
- (void)showMessage:(NSString *)message;
- (void)hide;

+(GInfoView *)sharedInfoView;
@end
