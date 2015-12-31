//
//  AppDelegate.m
//  KidsTC
//
//  Created by 钱烨 on 7/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpRequestClient.h"
#import "HttpIcsonCookieManager.h"
#import "KTCTabBarController.h"
#import "CheckFirstInstalDataManager.h"
#import "AddressManager.h"
#import "IcsonCategoryManager.h"
#import "VersionManager.h"
#import "MTA.h"
#import "MTAConfig.h"
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
#import "KTCSegueMaster.h"
#import "KTCAdvertisementManager.h"
#import "BigAdvertisementViewController.h"

static BOOL _alreadyLaunched = NO;

static const NSInteger kVersionUpdateAlertViewTag = 31415926;
static const NSInteger kVersionForceUpdateAlertViewTag = 31415627;

@interface AppDelegate () <KTCPushNotificationServiceDelegate>

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
@property (nonatomic, assign) BOOL canShowAdvertisement;

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
    
    [MTA startWithAppkey:@"IGILB3C2N33P"];
    [[MTAConfig getInstance] setChannel:@"iphone"];
#ifdef KIDSTC_DEBUG
    [[MTAConfig getInstance] setDebugEnable:YES];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_INSTANT];
#else
    [[MTAConfig getInstance] setDebugEnable:NO];
    [[MTAConfig getInstance] setReportStrategy:MTA_STRATEGY_BATCH];
    [[MTAConfig getInstance] setMinBatchReportCount:10];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //tabbar
    KTCTabBarController *tabbar = [KTCTabBarController shareTabBarController];
    [tabbar  createViewControllers];
    self.window.rootViewController = tabbar;
    //show user role select
    [self showUserRoleSelectWithFinishController:tabbar];
    //处理通知
    [KTCPushNotificationService sharedService].delegate = self;
    [[KTCPushNotificationService sharedService] launchServiceWithOption:launchOptions];
    
    [self.window makeKeyAndVisible];
    
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
    [self checkVersion];
    //搜索热词
    [[KTCSearchService sharedService] synchronizeHotSearchKeysWithSuccess:nil failure:nil];
    //广告
    [self showAdvertisement];
    [[KTCAdvertisementManager sharedManager] synchronizeAdvertisement];
    //主题
    [[KTCThemeManager manager] loadLocalTheme];
    [[KTCThemeManager manager] synchronizeTheme];
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

#pragma mark KTCPushNotificationServiceDelegate

- (void)didRecievedRemoteNotificationWithModel:(PushNotificationModel *)model {
    if (!model) {
        return;
    }
    self.canShowAdvertisement = NO;
    //获取当前VC
    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
    UINavigationController *controller = [KTCTabBarController shareTabBarController].selectedViewController;
    
    //展示消息跳转页面
    [KTCSegueMaster makeSegueWithModel:model.segueModel fromController:controller.topViewController];
}


#pragma mark Private Methods ------------------------------------------------------------------------------------

#pragma mark Version

- (void)checkVersionSucceed:(NSDictionary *)respData {
    if (!respData || ![respData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //    launchingFlag = YES;
    BOOL _bNeedUpdate = [[respData objectForKey:@"isUpdate"] boolValue];
    BOOL _bMustUpdate = NO;
    if (_bNeedUpdate)
    {
        _bMustUpdate = [[respData objectForKey:@"isForceUpdate"] boolValue];
        if (_bMustUpdate)
        {
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
    NSString *newVersionName = [info objectForKey:@"newVersion"];
    NSString *descStr = [info objectForKey:@"description"];
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
    [self.window.rootViewController presentViewController:controller animated:YES completion:nil];
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
    NSNumber *userSexValue = [[NSUserDefaults standardUserDefaults] objectForKey:UserSexDefaultKey];
    if (userRoleValue) {
        UserRole role = (UserRole)[userRoleValue integerValue];
        if (role != UserRoleUnknown) {
            self.canShowAdvertisement = YES;
            [[KTCUser currentUser] setUserRole:[KTCUserRole instanceWithRole:role sex:(KTCSex)[userSexValue integerValue]]];
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
    self.welcomeWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.welcomeWindow setBackgroundColor:[UIColor clearColor]];
    self.welcomeWindow.rootViewController = loadingVC;
    self.welcomeWindow.windowLevel = UIWindowLevelAlert + 1;
//    [self.window setHidden:YES];
//    [self.window setAlpha:0.7];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.welcomeWindow makeKeyAndVisible];
    
    [loadingVC setLoad_complete:^(){
        //显示欢迎或广告页面
        [self showWelcome];
    }];
}


- (void)showAdvertisement {
    if (!self.canShowAdvertisement) {
        return;
    }
    NSArray *adItems = [[KTCAdvertisementManager sharedManager] advertisementImages];
    if ([adItems count] > 0) {
        BigAdvertisementViewController *adVC = [[BigAdvertisementViewController alloc] initWithAdvertisementItems:adItems];
        if (!self.welcomeWindow) {
            self.welcomeWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self.welcomeWindow setBackgroundColor:[UIColor clearColor]];
            self.welcomeWindow.windowLevel = UIWindowLevelAlert + 1;
        }
        self.welcomeWindow.rootViewController = adVC;
        [UIApplication sharedApplication].statusBarHidden = YES;
        if (![self.welcomeWindow isKeyWindow]) {
            [self.welcomeWindow makeKeyAndVisible];
        }
//        [self.window setHidden:YES];
//        [self.window setAlpha:0.7];
        __weak AppDelegate *weakSelf = self;
        
        [adVC setCompletionBlock:^(HomeSegueModel *segueModel){
            [weakSelf showRealWindow];
            if (segueModel) {
                UINavigationController *controller = [KTCTabBarController shareTabBarController].selectedViewController;
                
                //展示消息跳转页面
                [KTCSegueMaster makeSegueWithModel:segueModel fromController:controller.topViewController];
            }
        }];
        [[KTCAdvertisementManager sharedManager] setAlreadyShowed];
    } else {
        [self showRealWindow];
    }
}


- (void)showWelcome {
    //检查是否第一次安装，弹出引导图
    if ([CheckFirstInstalDataManager getIsFirstTimeValue]) {//第一次安装
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.welcomeWindow.rootViewController = guideVC;
        
        __weak AppDelegate *weakSelf = self;
        [guideVC setGuide_complete:^(){
            [weakSelf showRealWindow];
            [CheckFirstInstalDataManager setIsFirstTimeValue:NO];
        }];
    } else {
        [self showRealWindow];
    }
}

- (void)showRealWindow {
    __weak UIWindow *weakWelcome = self.welcomeWindow;
    __weak UIWindow *weakWindow = self.window;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [weakWelcome setAlpha:0];
        [weakWindow setHidden:NO];
        [weakWindow setAlpha:1];
    } completion:^(BOOL finished) {
        [weakWelcome setHidden:YES];
        [weakWelcome setAlpha:1];
        weakWelcome.rootViewController = nil;
    }];
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

- (void)checkVersion {
    __weak AppDelegate *weakSelf = self;
    [[VersionManager sharedManager] checkAppVersionWithSuccess:^(NSDictionary *result) {
        [weakSelf checkVersionSucceed:[result objectForKey:@"data"]];
    } failure:^(NSError *error) {
        
    }];
}

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
