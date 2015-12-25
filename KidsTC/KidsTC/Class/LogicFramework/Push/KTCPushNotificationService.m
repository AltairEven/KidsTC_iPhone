//
//  KTCPushNotificationService.m
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCPushNotificationService.h"
#import "XGPush.h"
#import "XGSetting.h"

#define kDeviceToken (@"device_token")

uint32_t const kXGPushAppId = 2200143808;
NSString *const kXGPushAppKey = @"IA6953JED6IJ";

NSString *const kRemotePushNeedSegueNotification = @"kRemotePushNeedSegueNotification";

static KTCPushNotificationService *sharedInstance = nil;

@interface KTCPushNotificationService ()

@property (nonatomic, strong) HttpRequestClient *setAccountRequest;

@property (nonatomic, strong) HttpRequestClient *checkUnreadRequest;

@property (nonatomic, strong) HttpRequestClient *readMessageRequest;

- (NSUInteger)checkUnreadMessageSucceed:(NSDictionary *)data;

@end

@implementation KTCPushNotificationService

+ (instancetype)sharedService {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [[KTCPushNotificationService alloc] init];
    });
    return sharedInstance;
}

#pragma mark Register

- (void)launchServiceWithOption:(NSDictionary *)launchOptions {
//    [XGPush startApp:kXGPushAppId appKey:kXGPushAppKey];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
//        if([XGPush isUnRegisterStatus])
//        {
//            [self registerNotification];
//        }
        [self registerNotification];
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        [self dealRemoteNotification:launchOptions appState:UIApplicationStateInactive];
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [self handlePushPayload:userInfo];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"sss" message:[NSString stringWithFormat:@"%@", launchOptions] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
//    [alert show];
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self registerNotification];
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

- (NSString *)registerDevice:(NSData *)deviceToken {
//    void (^successBlock)(void) = ^(void){
//        //成功之后的处理
//        NSLog(@"[XGPush]register successBlock");
//    };
//    
//    void (^errorBlock)(void) = ^(void){
//        //失败之后的处理
//        NSLog(@"[XGPush]register errorBlock");
//    };
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    [[XGSetting getInstance] setGameServer:@"appstore"];
    
    
//    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenStr = [deviceTokenStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceTokenStr forKey:kDeviceToken];
    _token = deviceTokenStr;
    [self bindAccount:YES];
    
    return deviceTokenStr;
}

- (void)handleRegisterDeviceFailure:(NSError *)error {
    NSLog(@"Push Register Error:%@", error.description);
    NSString *errMsg = [NSString stringWithFormat:@"push注册失败，失败原因:%@", error.description];
    [MTA trackError:errMsg];
}

#pragma mark Account

- (void)bindAccount:(BOOL)bind {
    if (!self.setAccountRequest) {
        self.setAccountRequest = [HttpRequestClient clientWithUrlAliasName:@"PUSH_REGISTER_DEVICE"];
    } else {
        [self.setAccountRequest cancel];
    }
    NSUInteger type = 2;//解绑
    if (bind) {
        type = 1;//绑定
        [XGPush setAccount:[KTCUser currentUser].uid];
    } else {
//        [XGPush setAccount:@"*"];
    }
    if ([self.token length] == 0) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceToken];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:type], @"type", self.token, @"deviceId", nil];
    __weak KTCPushNotificationService *weakSelf = self;
    [weakSelf.setAccountRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSLog(@"Push Set Account:%@", responseData);
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSLog(@"Push Set Account:%@", error);
    }];
}

#pragma mark Handle Notification

- (void)handleApplication:(UIApplication *)application withReceivedNotification:(NSDictionary *)userInfo {
    [XGPush handleReceiveNotification:userInfo];
    
    UIApplicationState state = [application applicationState];
    [self dealRemoteNotification:userInfo appState:state];
}

- (void)dealRemoteNotification:(NSDictionary *)payload appState:(UIApplicationState)state{
    NSDictionary * aps = [payload objectForKey:@"aps"];
    
    if (state == UIApplicationStateActive) {
        NSString * title = [payload objectForKey:@"title"] ? [payload objectForKey:@"title"] : @"消息";
        NSString * msg = [aps objectForKey:@"alert"] ? [aps objectForKey:@"alert"] : @"您有新的消息!";
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"立即查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self handlePushPayload:payload];
        }];
        [controller addAction:leftAction];
        [controller addAction:rightAction];
        [[KTCTabBarController shareTabBarController] presentViewController:controller animated:YES completion:nil];
    } else {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if([app.window.rootViewController isKindOfClass:[KTCTabBarController class]]) {
            [self handlePushPayload:payload];
        } else {
            //程序正在启动
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self handlePushPayload:payload];
            });
        }
    }
    
}

- (void)handlePushPayload:(NSDictionary *)payload {
    PushNotificationModel *model = [[PushNotificationModel alloc] initWithRemoteNotificationData:payload];
    if (!model || model.segueModel.destination == HomeSegueDestinationNone) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecievedRemoteNotificationWithModel:)]) {
        [self.delegate didRecievedRemoteNotificationWithModel:model];
    }
}


#pragma mark Read Status

- (void)checkUnreadMessage:(void (^)(NSUInteger))succeed failure:(void (^)(NSError *))failure {
    if (!self.checkUnreadRequest) {
        self.checkUnreadRequest = [HttpRequestClient clientWithUrlAliasName:@"PUSH_IS_UN_READ_MESSAGE"];
    } else {
        [self.checkUnreadRequest cancel];
    }
    
    __weak KTCPushNotificationService *weakSelf = self;
    [weakSelf.checkUnreadRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSUInteger unreadCount = [weakSelf checkUnreadMessageSucceed:responseData];
        if (succeed) {
            succeed(unreadCount);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)readMessageWithIdentifier:(NSString *)identifier {
    if (!self.readMessageRequest) {
        self.readMessageRequest = [HttpRequestClient clientWithUrlAliasName:@"PUSH_USER_READ_MESSAGE"];
    } else {
        [self.readMessageRequest cancel];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:identifier forKey:@"ids"];
    
    [self.readMessageRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSLog(@"Set read status succeed.");
    } failure:^(HttpRequestClient *client, NSError *error) {
        NSLog(@"Set read status failed.");
    }];
}

#pragma mark Private methods

- (NSUInteger)checkUnreadMessageSucceed:(NSDictionary *)data {
    NSDictionary *countDic = [data objectForKey:@"data"];
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    NSUInteger count = [[countDic objectForKey:@"count"] integerValue];
    _unreadCount = count;
    NSUInteger tabCount = [[KTCTabBarController shareTabBarController] tabCount];
    if (count == 0) {
        [[KTCTabBarController shareTabBarController] setBadge:nil forTabIndex:tabCount - 1];
    } else {
//        NSString *badgeString = [NSString stringWithFormat:@"%lu", (unsigned long)count];
        [[KTCTabBarController shareTabBarController] setBadge:@"" forTabIndex:tabCount - 1];
    }
    return count;
}

@end
