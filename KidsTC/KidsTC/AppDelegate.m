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
#import "XGPush.h"
#import "XGSetting.h"
#import "KTCMapService.h"
#import "UserRoleSelectViewController.h"
#import "WeChatManager.h"
#import "TencentManager.h"
#import "WeiboManager.h"

static BOOL _alreadyLaunched = NO;

static const NSInteger kVersionUpdateAlertViewTag = 31415926;
static const NSInteger kVersionForceUpdateAlertViewTag = 31415627;

@interface AppDelegate () <UIAlertViewDelegate>

+ (void)handleNetworkStatusChange:(IcsonNetworkStatus)status;

- (void)showUserRoleSelectWithFinishController:(UIViewController *)controller;
- (void)showLoading;
- (void)showWelcome;

- (void)handleWebImageLoadingStrategy;

- (void)checkVersionSucceed:(NSDictionary *)respData;

- (void)showUpdateAlertViewWithInfo:(NSDictionary *)info andSource:(int)sourceTag;

- (void)registerXGPushNotificationWithLaunchingOptions:(NSDictionary *)launchOptions;

//flash
@property(nonatomic, strong)NSMutableArray* pic;
@property (nonatomic, copy)  NSString *verify;
@property (nonatomic, weak) ASIHTTPRequest *flashScreenASIRequest;
@property (nonatomic, strong) HttpRequestWrapper *flashScreenRequest;
- (void)requestFlash;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    IcsonNetworkReachabilityManager *manager = [IcsonNetworkReachabilityManager sharedManager];
    [manager startNetworkMonitoringWithStatusChangeBlock:^ (IcsonNetworkStatus status) {
        [AppDelegate handleNetworkStatusChange:status];
        _alreadyLaunched = YES;
    }];
    
    [self getInterfaceList];
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
    [self registerXGPushNotificationWithLaunchingOptions:launchOptions];
    [self checkNotificationInLanching:launchOptions];
    
    //map
    [[KTCMapService sharedService] startService];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[DownLoadManager sharedDownLoadManager] flush];
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
    _ifWakeupFromAli = NO;
    if ([url.scheme isEqualToString:kAliPaySchema])
    {
        _ifWakeupFromAli = YES;
        [self ALIParseURL:url application:application];
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



- (void)internalParseURL:(NSURL *)url application:(UIApplication *)application {
    NSLog(@"Debug QRScan handle (internalParseURL) url = %@", url);
    if ([self.window.rootViewController isKindOfClass:[KTCTabBarController class]])
    {
        NSLog(@"Debug QRScan handle (last) url = %@", url);
        KTCTabBarController * rootVC = (KTCTabBarController *)self.window.rootViewController;
        
        [rootVC allPopToRoot];
    }
    else
    {
        //程序正在启动
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            KTCTabBarController * rootVC = (KTCTabBarController *)self.window.rootViewController;
            [rootVC allPopToRoot];
            [rootVC gotoTabIndex:0];
        });
    }
}



- (void)ALIParseURL:(NSURL *)url application:(UIApplication *)application {
    AlixPay *alixpay = [AlixPay shared];
    AlixPayResult *result = [alixpay handleOpenURL:url];
    if (result) {
        
        if (result.statusCode == 9000) {
            NSString *message = result.statusMessage;
            if ([result.statusMessage length] == 0)
            {
                // no message
                message = @"支付成功";
            }
            [UIAlertView displayAlertWithTitle: @"提示"
                                       message: message
                               leftButtonTitle: @"确定"
                              leftButtonAction:^{
                                  [[NSNotificationCenter defaultCenter] postNotificationName: kPaymentAliSuccessNotification object: result];
                              } rightButtonTitle: nil
                             rightButtonAction: nil];
        }
        else {
            NSString *errMsg = [NSString stringWithFormat:@"ali支付失败，失败原因:%@", result.statusMessage];
            [MTA trackError:errMsg];
            // something error
            [UIAlertView displayAlertWithTitle: @"提示"
                                       message: result.statusMessage
                               leftButtonTitle: @"确定"
                              leftButtonAction: ^{
                                  [[NSNotificationCenter defaultCenter] postNotificationName: kPaymentAliHaltNotification object: nil];
                              }
                              rightButtonTitle: nil
                             rightButtonAction: nil];
        }
    }
}

#pragma mark Notification
- (void)checkNotificationInLanching:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    NSDictionary *localPayLoad = localNotification.userInfo;
    if ([[localPayLoad objectForKey:@"kIcsonAppRemindType"] intValue] == 1)
    {
        if ([self.window.rootViewController isKindOfClass:[KTCTabBarController class]])
        {
            [self handleRemindPayload:localPayLoad];
        }
        else
        {
            double delayInSeconds = .3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self handleRemindPayload:localPayLoad];
            });
        }
        
        return;
    }
    
    NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([payload count] > 0)
    {
        if ([self.window.rootViewController isKindOfClass:[KTCTabBarController class]])
        {
            [self handlePushPayload:payload];
        }
        else
        {
            //程序正在启动
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self handlePushPayload:payload];
            });
        }
    }
}

- (void)handlePushPayload:(NSDictionary *)payload
{
    BOOL needLogin = [[payload objectForKey:@"login"] boolValue];
    NSInteger msgId = [[payload objectForKey:@"msgId"] integerValue];
    if (nil == _msgParser) {
        _msgParser = [[MessageCenterParser alloc] init];
    }
    
    NSString * finger = [payload objectForKey:@"fp"];
    if (nil == finger) finger = @"";
    if (needLogin) {
        [GToolUtil checkLogin:^(NSString *uid) {
            //            if (msgId > 0) {
            [_msgParser setMessageStatusWithParams:@{@"fromPush":[NSNumber numberWithInt:1], @"uid":uid, @"deviceId":[[UIDevice currentDevice] uniqueDeviceIdentifier], @"msgId":[NSNumber numberWithInteger:msgId], @"status":@"1", @"fingerprint":finger}];
            //            }
            
            [self realHandlePushPayload:payload];
        } target:self.window.rootViewController];
    } else {
        //        if ([[UserWrapper shareMasterUser] isLogin] && msgId > 0) {
        [_msgParser setMessageStatusWithParams:@{@"fromPush":[NSNumber numberWithInt:1], @"uid":[NSNumber numberWithInteger:[UserWrapper shareMasterUser].uid], @"deviceId":[[UIDevice currentDevice] uniqueDeviceIdentifier], @"msgId":[NSNumber numberWithInteger:msgId], @"status":@"1", @"fingerprint":finger}];
        //        }
        
        [self realHandlePushPayload:payload];
    }
}

- (void)realHandlePushPayload:(NSDictionary *)payload
{
//    KTCTabBarController *rootVc = [KTCTabBarController shareTabBarController];
//    UIViewController *presentedVc = nil;
//    presentedVc = [rootVc presentedViewController];
//    
//    if ([presentedVc isKindOfClass:[UINavigationController class]] /*&& [[(UINavigationController *)presentedVc topViewController] isKindOfClass:[GLoginController class]]*/)
//    {
//        [presentedVc dismissViewControllerAnimated:NO completion:nil];
//    }
//    
//    //    if (![[UserWrapper shareMasterUser] isLogin]) {
//    [rootVc allPopToRoot];
//    [rootVc setButtonSelected:KTCTabHome];
//    //    }
//    //    [rootVc allPopToRoot];
//    //    [rootVc gotoTabIndex:0];
//    
//    UIViewController *currentSelectedVc = rootVc.selectedViewController;
//    int sbid = (int)[[payload objectForKey:@"sbid"] integerValue];
//    NSString *productId = IDTOSTRING(payload[@"productId"]);
//    switch (sbid)
//    {
//        case BizArrived://这个也是商详
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]] && productId.length > 0)
//            {
//                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                ProductDetailViewController *productVc = [[ProductDetailViewController alloc] initWithProductID:productId];
//                [navVc pushViewController:productVc animated:YES];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizHomepage://跳转到主页
//        {
//            [rootVc setButtonSelected:KTCTabHome];
//            break;
//        }
//        case BizCharge://充值页-已作废
//        {
//            //            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            //            {
//            //                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//            //                GPhoneChargeController *phoneChargeController = [[GPhoneChargeController alloc] init];
//            //                //TODO REMOVE PVCHANGE
//            //                //                [UserTracker trackPVPageChange:GPushBizCharge from:navVc.topViewController to:phoneChargeController];
//            //                [navVc pushViewController:phoneChargeController animated:YES];
//            //            }
//            //            else
//            //            {
//            //                [rootVc setButtonSelected:HomeTabHome];
//            //                [UserTracker trackPVaction:GPushBizCharge viewCtrl:rootVc.homePageVC];
//            //            }
//            [rootVc setButtonSelected:KTCTabHome];
//            
//            break;
//        }
//        case BizCoupon: //领券页-已作废
//        {
//            //            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            //            {
//            //                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//            //                GReceiveCouponController *couponCtrl = [[GReceiveCouponController alloc] initWithNibName:@"GReceiveCouponController" bundle:[NSBundle mainBundle]];
//            //                //                [UserTracker trackPVPageChange:GPushBizCommentDeadline+(sbid-BizCoupon) from:navVc.topViewController to:couponCtrl];
//            //                [navVc pushViewController:couponCtrl animated:YES];
//            //                break;
//            //            }
//            //            else
//            //            {
//            //                [rootVc setButtonSelected:HomeTabHome];
//            //            }
//            [rootVc setButtonSelected:KTCTabHome];
//            
//            break;
//        }
//        case BizChannelEvent: //跳转到活动页-已作废
//        {
//            //            NSInteger extra = [[payload objectForKey:@"extra"] integerValue];
//            //            if (extra > 0) {
//            //                [UserTracker trackPVaction:GPushBizChannelEvent viewCtrl:rootVc.homePageVC];
//            //
//            //                [[NewTabBarViewController shareTabBarController] presentIcsonEventControllerWithEventId:extra];
//            //                //tom fix it later, (but later is never)
//            //                //[[NewTabBarViewController shareTabBarController] setButtonSelected:HomeEasyQiang];
//            //
//            //                //[[NewTabBarViewController shareTabBarController].icsonContentCtrl selectedItemByEventID:extra];
//            //                //[[EasyQiangTabView sharedEasyQiangTabView] EQSwitchButtonPressed:nil];
//            //
//            //                // track UVPV logic
//            //                //                id moreVc = [[[NewTabBarViewController shareTabBarController] viewControllers] lastObject];
//            //                //                if ([moreVc respondsToSelector:@selector(topViewController)])
//            //                //                {
//            //                //                    id icsonVc = [(UINavigationController *)moreVc topViewController];
//            //                //                    if ([icsonVc isKindOfClass:[IcsonEventsViewController class]] && [[(IcsonEventsViewController *)icsonVc viewCtrls] count] > 0)
//            //                //                    {
//            //                //                        UIViewController *willSelectedController = [icsonVc currentViewCtrl];
//            //                //                        [UserTracker trackPVPageChange:GPushBizChannelEvent from:rootVc.homePageVC to:willSelectedController];
//            //                //                    }
//            //                // }
//            //            }
//            [rootVc setButtonSelected:KTCTabHome];
//            
//            break;
//        }
//        case BizCommentReminder://评论提醒：订单详情页
//        case BizCommentDeadline://评论过期提醒：订单详情页
//        case BizOrderApproach://物流轨迹提醒：订单详情页
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid) {
//                    UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                    GUOneOrderNewController *oneOrderController = [[GUOneOrderNewController alloc] initWithOrderId:[payload objectForKey:@"orderId"]];
//                    
//                    [navVc setNavigationBarHidden:YES animated:NO];
//                    [navVc pushViewController:oneOrderController animated: YES];
//                } target: self.window.rootViewController fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizPriceGuardAccepted://积分到账-积分流水页
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid)
//                 {
//                     UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                     TOIntegralViewController *integralVc = [[TOIntegralViewController alloc] init];
//                     [navVc pushViewController:integralVc animated:YES];
//                 } target: self.window.rootViewController fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizProductDetail://跳转到商详
//        {
//            NSString *productId = IDTOSTRING(payload[@"productId"]);
//            NSInteger channelId = [[payload objectForKey:@"extra"] integerValue];
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]] && productId.length > 0)
//            {
//                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                ProductDetailViewController *productVc = [[ProductDetailViewController alloc] initWithProductID:productId andChannelID:[NSString stringWithFormat:@"%ld", (long)channelId] andmPrice:nil];
//                [navVc pushViewController:productVc animated:YES];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizMessageCenter://运营消息-消息中心页
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid)
//                 {
//                     UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                     MessageCenterController *messageCenterVc = [[MessageCenterController alloc] init];
//                     [navVc pushViewController:messageCenterVc animated:YES];
//                 } target: self  fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizRoll://摇一摇-已作废
//        {
//            //            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            //            {
//            //                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//            //                RollViewController *rollVc = [[RollViewController alloc] init];
//            //                [navVc pushViewController:rollVc animated:YES];
//            //                //TODO REMOVE PVCHANGE
//            //                //                [UserTracker trackPVPageChange:GPushBizRoll from:navVc.topViewController to:rollVc];
//            //            }
//            //            else
//            //            {
//            //                [UserTracker trackPVaction:GPushBizRoll viewCtrl:rootVc.homePageVC];
//            //                [rootVc setButtonSelected:HomeTabHome];
//            //            }
//            
//            [rootVc setButtonSelected:KTCTabHome];
//            break;
//        }
//        case BizWebpage://运营-h5活动页 1005
//        case BizGuijiupeiAccepted://贵就陪规则介绍页-审核通过 3001
//        case BizGuijiupeiRefuse://贵就陪规则介绍页-审核不通过 3002
//        case BizPriceGuardMatch://价格保护介绍页-符合规则    3003
//        case BizPriceGuardRefuse://价格保护介绍页-积分取消   3005
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                // to web page
//                NSString *ytagStr = [NSString stringWithFormat:@"1.%d%05ld", GPageIDLaunchFromMessage, (long)sbid];
//                GWebViewController *newCtrl = [[GWebViewController alloc] initWithNibName:@"GWebViewController" bundle:[NSBundle mainBundle]];
//                newCtrl.title = [payload objectForKey:@"title"];
//                [newCtrl setWebUrl:[GToolUtil addQueryStringToUrl:[payload objectForKey:@"url"] params:@{@"YTAG":ytagStr}]];
//                
//                //TODO REMOVE PVCHANGE
//                //                [UserTracker trackPVPageChange:GPushBizBizGuijiupeiRefuse+(sbid-BizGuijiupeiRefuse) from:navVc.topViewController to:newCtrl];
//                [navVc pushViewController:newCtrl animated:YES];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizFreshManCoupon://优惠券列表
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid)
//                 {
//                     UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                     CouponListController *couponListController = [[CouponListController alloc] initWithSOurce:CouponFromUserCenter andDelegate:nil];
//                     [navVc pushViewController:couponListController animated:YES];
//                 } target: self.window.rootViewController fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizFeedbackHistory://意见反馈列表
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid)
//                 {
//                     UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                     FBHistoryController *fbHistoryVc = [[FBHistoryController alloc] init];
//                     [navVc pushViewController:fbHistoryVc animated:YES];
//                     //TODO REMOVE PVCHANGE
//                     //                     [UserTracker trackPVPageChange:GPushFeedbak from:navVc.topViewController to:fbHistoryVc];
//                 } target: self  fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            
//            break;
//        }
//        case BizReturnAndChangeDetail://退换货某一个的详情，非列表
//        {
//            if ([currentSelectedVc isKindOfClass:[UINavigationController class]])
//            {
//                [GToolUtil checkLogin:^(NSInteger uid)
//                 {
//                     if (uid == [payload[@"uid"] integerValue]) {
//                         UINavigationController *navVc = (UINavigationController *)currentSelectedVc;
//                         ReturnAndChangeDetailInfoViewController *returnAndChangeDetailVC = [[ReturnAndChangeDetailInfoViewController alloc] initWithApplyId:[payload[@"applyId"] integerValue]];
//                         [navVc pushViewController:returnAndChangeDetailVC animated:YES];
//                     }
//                     else {
//                         [[iToast makeText:@"您更换了登录账号，无法查看上次账号的消息通知"] show];
//                     }
//                 } target: self  fromMyIcson:NO];
//            }
//            else
//            {
//                [rootVc setButtonSelected:KTCTabHome];
//            }
//            break;
//        }
//        default:
//        {
//            NSString *errMsg = [NSString stringWithFormat:@"push消息无法处理，内容:%@", payload];
//            [MTA trackError:errMsg];
//        }
//            break;
//    }
//    
//    [[GShoppingcart sharedShoppingcart] addBuyPathPointWithPageID:GPageIDLaunchFromMessage touchEventID:sbid andPageLevel:0];
}

- (void)handleRemindPayload:(NSDictionary *)payload
{
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif
{
    application.applicationIconBadgeNumber = 0;
}

-(void) dealRemoteNotification:(NSDictionary *)payload appState:(UIApplicationState)state{
    NSDictionary * aps = [payload objectForKey:@"aps"];
    
    if (state == UIApplicationStateActive) {
        NSString * title = [payload objectForKey:@"title"] ? [payload objectForKey:@"title"] : @"消息";
        NSString * msg = [aps objectForKey:@"alert"] ? [aps objectForKey:@"alert"] : @"您有新的消息!";
        [UIAlertView displayAlertWithTitle:title message:msg leftButtonTitle:@"忽略" leftButtonAction:nil rightButtonTitle:@"立即查看" rightButtonAction:^{
            [self handlePushPayload:payload];
        }];
    } else {
        if([self.window.rootViewController isKindOfClass:[KTCTabBarController class]])
        {
            [self handlePushPayload:payload];
        }
        else
        {
            //程序正在启动
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self handlePushPayload:payload];
            });
        }
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [XGPush handleReceiveNotification:userInfo];
    // Receive Notification when running or backgroud
    UIApplicationState state = [application applicationState];
    [self dealRemoteNotification:userInfo appState:state];
}

- (void)registerXGPushNotificationWithLaunchingOptions:(NSDictionary *)launchOptions {
    [XGPush startApp:2200143808 appKey:@"IA6953JED6IJ"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            [self registerNotification];
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

- (void)registerNotification
{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// Receive deviceToken
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"appstore"];
    
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
    
    NSString * dt = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@, len:%lu", dt, (unsigned long)(dt.length));
    
    [[NSUserDefaults standardUserDefaults] setValue:dt forKey:kDeviceToken];
    AsyncUserDeviceInfo
}

// Get deviceToken Error
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Push Register Error:%@", err.description);
    NSString *errMsg = [NSString stringWithFormat:@"push注册失败，失败原因:%@", err.description];
    [MTA trackError:errMsg];
}

#pragma mark Wechat Delegate


-(void) onReq:(BaseReq*)req {
    
    [WeChatModel onWeChatReq:req];
}

-(void) onResp:(BaseResp*)resp {
    
    [WeChatModel onWeChatResponse:resp];
}


#pragma mark Self Methods

- (void)getInterfaceList
{
    [[InterfaceManager sharedManager] updateInterface];
}



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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 %@", newVersionName] message:descStr delegate:self cancelButtonTitle:cancelStr otherButtonTitles:@"立即去更新", nil];
    alertView.tag = sourceTag;
    alertView.delegate = self;
    NSArray *subViewArray = alertView.subviews;
    
    for(int i=0; i<[subViewArray count]; i++)
    {
        if([[[subViewArray objectAtIndex:i] class] isSubclassOfClass:[UILabel class]])
        {
            UILabel *label = [subViewArray objectAtIndex:i];
            if ([[label text] isEqualToString:[NSString stringWithFormat:@"发现新版本 %@", newVersionName]])
            {
                // title label
                label.textAlignment = NSTextAlignmentCenter;
            }
            else
            {
                label.textAlignment = NSTextAlignmentLeft;
            }
        }
    }
    
    [alertView show];
}


- (void)handleWebImageLoadingStrategy {
    BOOL isSet = [[NSUserDefaults standardUserDefaults] boolForKey:kIsWebImageLoadingStratrgySet];
    if (isSet) {
        BOOL bLoad = ![[[NSUserDefaults standardUserDefaults] objectForKey:kIsDownloadImageOrNotWhenWifi] boolValue];
        [[GConfig sharedConfig] setLoadWebImage:bLoad];
    }
}


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
- (void)showFlash {
    GuideViewController1 *guideVC = [[GuideViewController1 alloc] init];
    self.welcomeWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.welcomeWindow setBackgroundColor:[UIColor whiteColor]];
    self.welcomeWindow.rootViewController = guideVC;
    self.welcomeWindow.windowLevel = UIWindowLevelAlert + 1;
    [self.window setHidden:YES];
    [self.window setAlpha:0.5];
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
            [weakWelcome setHidden:YES];
        } completion:^(BOOL finished) {
            //[weakWelcome setHidden:YES];
            weakWelcome.rootViewController = nil;
        }];
    }];
    
}
- (void)requestFlash {
    _flashScreenRequest = [[HttpRequestWrapper alloc] initWithUrl:@"http://mb.51buy.com/json.php?mod=home&act=getscreen"
                                                           method:HttpRequestMethodPOST
                                                     urlAliasName:@"URL_TX_LOGIN"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    self.verify = nil;
    if (self.verify) {
        [params setObject:self.verify forKey:@"verify"];
    }
    [self.flashScreenRequest setUrl:@"http://mb.51buy.com/json.php?mod=home&act=getscreen"];
    self.flashScreenASIRequest = [self.flashScreenRequest startProcess:params target:self onSuccess:@selector(success:) onFailed:nil onLoading:nil autoStart:NO];
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:self.flashScreenASIRequest];
}
- (void)success:(NSDictionary *)data
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        NSInteger errorNo = [[data objectForKey:@"errno"] integerValue];
        if (errorNo == 0) {
            NSArray * dataArr = [data objectForKey:@"data"];
            self.verify = [CheckFlashMD5 getMD5Value];
            if ([self.verify isEqualToString:[data objectForKey:@"md5"]]) {
                return;
            }
            [CheckFlashMD5 setMD5Value:[data objectForKey:@"md5"]];
            //NSLog(@"%@ %ld", dataArr, time(NULL));
            
            time_t t = time(NULL);
            self.pic = [[NSMutableArray alloc]init];
            [self.pic removeAllObjects];
            
            NSString *cachesPath =NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            for (int i=0; i<=2; ++i) {
                NSString *testPath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",i,@".png"]];
                if ([fileManager fileExistsAtPath:testPath]) {
                    [fileManager removeItemAtPath:testPath error:nil];
                }
            }
            //删除目录下的所有图片
            //(void) initDir;
            for(int i = 0; i < dataArr.count; ++i)
            {
                if ([[[dataArr objectAtIndex:i] objectForKey:@"EndTime"] integerValue] > t) {
                    [self.pic addObject:[[dataArr objectAtIndex:i] objectForKey:@"pic"]];
                    NSLog(@"url=%@", self.pic[self.pic.count-1]);
                    NSURL  *imageUrl = [NSURL URLWithString:self.pic[self.pic.count-1]];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                    //[self.images addObject:[UIImage imageWithData:imageData]];
                    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"png"];
                    //NSData *data1 = [NSData dataWithContentsOfURL:imageUrl];
                    NSString *newFilePath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d%@",i,@".png"]];
                    [imageData writeToFile:newFilePath atomically:YES];
                }
            }
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
        });
        
    });
    
}
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
            [[[iToast makeText:@"当前为WIFI网络，祝您购物愉快"] setDuration:1500] show];
        }
            break;
        default:
            break;
    }
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

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kVersionUpdateAlertViewTag)
    {
        if (buttonIndex == 1)
        {
            [[VersionManager sharedManager] goToUpdateViaItunes];
        }
        
        [GConfig restartUpdateImmunePeriod];
    }
    else if (alertView.tag == kVersionForceUpdateAlertViewTag)
    {
        if (buttonIndex == 0)
        {
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] exitApplication];
        }
        else
        {
            [[VersionManager sharedManager] goToUpdateViaItunes];
        }
    }
}

#pragma mark - qqopenapi

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

@end
