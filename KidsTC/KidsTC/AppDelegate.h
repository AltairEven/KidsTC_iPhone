//
//  AppDelegate.h
//  KidsTC
//
//  Created by 钱烨 on 7/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "MessageCenterParser.h"
#import "KTCTabBarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>
{
    MessageCenterParser *           _msgParser;
    BOOL  _ifWakeupFromAli;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *yid;//这个值存启动来源。
@property (strong, nonatomic) NSString *loginSource;//这个值存启动来源。
@property (strong, nonatomic) NSString *accessToken; //需要传入支付接口
@property (strong, nonatomic) UIWindow *statusBarOverWindow;
@property (strong, nonatomic) UIWindow *welcomeWindow;
//@property (nonatomic, strong) WloginSdk_v2 * wtLoginSdk;

@property (nonatomic, strong) KTCTabBarController *tabbarController;

- (void)checkVersion;
//- (void)exitApplication;

@end

