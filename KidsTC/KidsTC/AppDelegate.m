//
//  AppDelegate.m
//  KidsTC
//
//  Created by 钱烨 on 7/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppDelegate.h"
#import "WeChatModel.h"
#import "HttpRequestClient.h"
#import "HttpIcsonCookieManager.h"
#import "KTCTabBarController.h"
#import "CheckFirstInstalDataManager.h"
#import "AddressManager.h"
#import "IcsonCategoryManager.h"
#import "GPayment.h"
#import "RemindManager.h"
#import "UIDevice+IdentifierAddition.h"
#import "MessageItem.h"
#import <sys/utsname.h>
#import "VersionManager.h"
#import "MTA.h"
#import "MTAConfig.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "GuideViewController1.h"
#import "CheckFlashMD5.h"
#import "GuideViewController.h"
#import "InterfaceManager.h"
#import "LoadingViewController.h"
#import "KTCPushNotificationService.h"
#import "KTCMapService.h"
#import "UserRoleSelectViewController.h"
#import "WeChatManager.h"
#import "TencentManager.h"
#import "WeiboManager.h"
#import "AlipayManager.h"

static BOOL _alreadyLaunched = NO;

static const NSInteger kVersionUpdateAlertViewTag = 31415926;
static const NSInteger kVersionForceUpdateAlertViewTag = 31415627;

@interface AppDelegate ()

+ (void)handleNetworkStatusChange:(IcsonNetworkStatus)status;

- (void)showUserRoleSelectWithFinishController:(UIViewController *)controller;
- (void)showLoading;
- (void)showWelcome;

- (void)handleWebImageLoadingStrategy;

- (void)checkVersionSucceed:(NSDictionary *)respData;

- (void)showUpdateAlertViewWithInfo:(NSDictionary *)info andSource:(int)sourceTag;

//flash
@property(nonatomic, strong)NSMutableArray* pic;
@property (nonatomic, copy)  NSString *verify;
@property (nonatomic, weak) ASIHTTPRequest *flashScreenASIRequest;
@property (nonatomic, strong) HttpRequestWrapper *flashScreenRequest;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IcsonNetworkReachabilityManager *manager = [IcsonNetworkReachabilityManager sharedManager];
    [manager startNetworkMonitoringWithStatusChangeBlock:^ (IcsonNetworkStatus status) {
        [AppDelegate handleNetworkStatusChange:status];
        _alreadyLaunched = YES;
    }];
    
    [[InterfaceManager sharedManager] updateInterface];
    [[HttpIcsonCookieManager sharedManager] setupCookies];
    
    // regist WeChat AppID
    [WeChatManager sharedManager];
    
    [[KTCUser currentUser] checkLoginStatusFromServer];     // 这句话执行前的统计log，uid字段都为空
    
    //图片加载策略
    [self handleWebImageLoadingStrategy];
    
    [MTA startWithAppkey:@"IBY24Y7P2AES"];
    [[MTAConfig getInstance] setChannel:@"iphone"];
    [[MTAConfig getInstance] setDebugEnable:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT]; //update mta, edit by Altair, 20141125
    [[MTAConfig getInstance] setSessionTimeoutSecs:60];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //tabbar
    KTCTabBarController *tabbar = [KTCTabBarController shareTabBarController];
    [tabbar  createViewControllers];
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
    //show user role select
    [self showUserRoleSelectWithFinishController:tabbar];
    
    //处理通知
    [[KTCPushNotificationService sharedService] launchServiceWithOption:launchOptions];
    
    //map
    [[KTCMapService sharedService] startService];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[DownLoadManager sharedDownLoadManager] flush];
    [[GAlertLoadingView sharedAlertLoadingView] hide];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[DownLoadManager sharedDownLoadManager] cleanAllTemp];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //把通知的badgeNumber设置为0
    application.applicationIconBadgeNumber = 0;
    
    //版本检查更新
//    __weak AppDelegate *weakSelf = self;
//    [[VersionManager sharedManager] checkAppVersionWithSuccess:^(NSDictionary *result) {
//        [weakSelf checkVersionSucceed:result];
//    } failure:^(NSError *error) {
//        
//    }];
//    
//    //更新三级地址信息
//    [[AddressManager sharedManager] validateADListDataWithSuccess:^(AddressManager *manager) {
//        if ([[AddressManager sharedManager] hasValidData]) {
//            //设置默认用户地址
//            NSString *countyIdDefault = [[UserWrapper shareMasterUser] countyId];
//            if (countyIdDefault && ![countyIdDefault isEqualToString:@""]) {
//                AdministrativeDivision *adDefault = [[AddressManager sharedManager] getADInfoWithMatchType:MatchTypeUniqueId matchData:countyIdDefault andError:nil];
//                [[UserWrapper shareMasterUser] setCurrentDivision:adDefault];
//            }
//        }
//    } andFailure:^(NSError *error) {
//        if ([[AddressManager sharedManager] hasValidData]) {
//            //设置默认用户地址
//            NSString *districtIdDefault = [[UserWrapper shareMasterUser] districtId];
//            if (districtIdDefault && ![districtIdDefault isEqualToString:@""]) {
//                AdministrativeDivision *adDefault = [[AddressManager sharedManager] getADInfoWithMatchType:MatchTypeUniqueId matchData:districtIdDefault andError:nil];
//                [[UserWrapper shareMasterUser] setCurrentDivision:adDefault];
//            }
//        }
//    }];
    //区域
    [[KTCArea area] synchronizeArea];
    //分类请求
    [[IcsonCategoryManager sharedManager] loadIcsonCategoriesWithLastUpdatetime:@"" success:^(IcsonCategories *categories) {} andFailure:^( NSError *error) {}];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark OpenUrl

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:kAlipayFromScheme])
    {
        return [[AlipayManager sharedManager] handleOpenUrl:url];
    }
    else if ([url.scheme isEqualToString:kWeChatUrlScheme])
    {
        return [[WeChatManager sharedManager] handleOpenURL:url];
    }
    else if ([url.scheme isEqualToString:kTencentUrlScheme])
    {
        return [[TencentManager sharedManager] handleOpenURL:url];
    } else if ([url.scheme isEqualToString:kWeiboUrlScheme]) {
        return [[WeiboManager sharedManager] handleOpenURL:url];
    }
    
    return YES;
}


#pragma mark Notification ---------------------------------------------------------------------------------------


#pragma mark Local Notification

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif
{
    application.applicationIconBadgeNumber = 0;
}

#pragma mark Remote Notification

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[KTCPushNotificationService sharedService] handleApplication:application withReceivedNotification:userInfo];
}

#pragma mark Register Remote Notification

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

// Receive deviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[KTCPushNotificationService sharedService] registerDevice:deviceToken];
}

// Get deviceToken Error
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [[KTCPushNotificationService sharedService] handleRegisterDeviceFailure:err];
}

#pragma mark Private Methods ------------------------------------------------------------------------------------

#pragma mark Version

- (void)checkVersionSucceed:(NSDictionary *)respData {
    
    //    launchingFlag = YES;
    BOOL _bNeedUpdate = [[respData objectForKey:@"needUpdate"] boolValue];
    BOOL _bMustUpdate = NO;
    if (_bNeedUpdate)
    {
        _bMustUpdate = [[respData objectForKey:@"mustUpdate"] boolValue];
        if (_bMustUpdate)
        {
            //            [GConfig setForceUpdateInfo:result];
            [self showUpdateAlertViewWithInfo:respData andSource:kVersionForceUpdateAlertViewTag];
        }
        else
        {
            if ([GConfig isInUpdateImmunePeriod:[NSDate date]])
            {
                return;
            }
            else
            {
                [self showUpdateAlertViewWithInfo:respData andSource:kVersionUpdateAlertViewTag];
            }
        }
    }
}


- (void)showUpdateAlertViewWithInfo:(NSDictionary *)info andSource:(int)sourceTag
{
    BOOL _bMustUpdate = NO;
    NSString *newVersionName = [info objectForKey:@"versionName"];
    NSArray *descArr = [info objectForKey:@"desc"];
    NSString *descStr = [descArr componentsJoinedByString:@"\n"];
    _bMustUpdate = [[info objectForKey:@"mustUpdate"] intValue];
    NSString *cancelStr = sourceTag == kVersionForceUpdateAlertViewTag ? @"退出" : @"稍后再说";
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"发现新版本 %@", newVersionName] message:descStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (sourceTag == kVersionForceUpdateAlertViewTag) {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] exitApplication];
        }
    }];
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"立即去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sourceTag == kVersionUpdateAlertViewTag) {
            [[VersionManager sharedManager] goToUpdateViaItunes];
            [GConfig restartUpdateImmunePeriod];
        } else if (sourceTag == kVersionForceUpdateAlertViewTag) {
            [[VersionManager sharedManager] goToUpdateViaItunes];
        }
    }];
    [controller addAction:leftAction];
    [controller addAction:rightAction];
    [self.tabbarController presentViewController:controller animated:YES completion:nil];
}


#pragma mark Web Image

- (void)handleWebImageLoadingStrategy {
    BOOL isSet = [[NSUserDefaults standardUserDefaults] boolForKey:kIsWebImageLoadingStratrgySet];
    if (isSet) {
        BOOL bLoad = ![[[NSUserDefaults standardUserDefaults] objectForKey:kIsDownloadImageOrNotWhenWifi] boolValue];
        [[GConfig sharedConfig] setLoadWebImage:bLoad];
    }
}


#pragma mark User Role

- (void)showUserRoleSelectWithFinishController:(UIViewController *)controller {
    NSNumber *userRoleValue = [[NSUserDefaults standardUserDefaults] objectForKey:UserRoleDefaultKey];
    if (userRoleValue) {
        UserRole role = (UserRole)[userRoleValue integerValue];
        if (role != UserRoleUnknown) {
            [[KTCUser currentUser] setUserRole:[KTCUserRole instanceWithRole:role sex:KTCSexUnknown]];
            //show loading
            [self showLoading];
            return;
        }
    }
    //显示选择页面
    UserRoleSelectViewController *selectVC = [[UserRoleSelectViewController alloc] initWithNibName:@"UserRoleSelectViewController" bundle:nil];
    self.window.rootViewController = selectVC;
    [selectVC setCompleteBlock:^(UserRole selectedRole, KTCSex selectedSex){
        [[KTCUser currentUser] setUserRole:[KTCUserRole instanceWithRole:selectedRole sex:selectedSex]];
        self.window.rootViewController = controller;
    }];
}

#pragma mark Loading & Welcome

- (void)showLoading {
    LoadingViewController *loadingVC = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    UIWindow *loadingWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [loadingWindow setBackgroundColor:[UIColor clearColor]];
    loadingWindow.rootViewController = loadingVC;
    loadingWindow.windowLevel = UIWindowLevelStatusBar - 1;
    [self.window setHidden:YES];
    [self.window setAlpha:0.7];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [loadingWindow makeKeyAndVisible];
    
    [loadingVC setLoad_complete:^(){
        //显示欢迎页面
        [self showWelcome];
        [loadingWindow setHidden:YES];
        loadingWindow.rootViewController = nil;
    }];
}


- (void)showWelcome {
    //检查是否第一次安装，弹出引导图
    if ([CheckFirstInstalDataManager getIsFirstTimeValue]) {//第一次安装
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.welcomeWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.welcomeWindow setBackgroundColor:[UIColor whiteColor]];
        self.welcomeWindow.rootViewController = guideVC;
        self.welcomeWindow.windowLevel = UIWindowLevelAlert + 1;
        [self.window setHidden:YES];
        [self.window setAlpha:0.7];
        [self.welcomeWindow makeKeyAndVisible];
        
        
        __weak UIApplication *weakApp = [UIApplication sharedApplication];
        weakApp.statusBarHidden = YES;
        
        __weak UIWindow *weakWelcome = self.welcomeWindow;
        __weak UIWindow *weakWindow = self.window;
        
        [guideVC setGuide_complete:^(){
            weakApp.statusBarHidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                [weakWindow setHidden:NO];
                [weakWindow setAlpha:1];
            } completion:^(BOOL finished) {
                [weakWelcome setHidden:YES];
                weakWelcome.rootViewController = nil;
            }];
            [CheckFirstInstalDataManager setIsFirstTimeValue:NO];
        }];
    }else{
        [UIApplication sharedApplication].statusBarHidden = NO;
        __weak UIWindow *weakWindow = self.window;
        [UIView animateWithDuration:0.5 animations:^{
            [weakWindow setHidden:NO];
            [weakWindow setAlpha:1];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark Network Status

+ (void)handleNetworkStatusChange:(IcsonNetworkStatus)status {
    switch (status) {
        case IcsonNetworkStatusUnknown:
        case IcsonNetworkStatusNotReachable:
        {
            [[GAlertLoadingView sharedAlertLoadingView] hide];
            [[[iToast makeText:@"您当前网络不可用，请检查网络设置"] setDuration:1500] show];
        }
            break;
        case IcsonNetworkStatusReachableViaWWAN:
        {
            [[[iToast makeText:@"当前为蜂窝移动网络，请注意流量消耗"] setDuration:1500] show];
        }
            break;
        case IcsonNetworkStatusReachableViaWiFi:
        {
            if (!_alreadyLaunched) {
                return;
            }
            [[[iToast makeText:@"当前为WIFI网络，祝您使用愉快"] setDuration:1500] show];
        }
            break;
        default:
            break;
    }
}

#pragma mark Exit

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.window.alpha = 0;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

@end
