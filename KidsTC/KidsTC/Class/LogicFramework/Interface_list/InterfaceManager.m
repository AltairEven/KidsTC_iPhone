//
//  InterfaceManager.m
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "InterfaceManager.h"
#import "CheckFirstInstalDataManager.h"

#define MAIN_GETINTERFACE     @"http://api.kidstc.com/json.php?mod=main&&act=getinterface"

static InterfaceManager *_sharedInstance = nil;

@interface InterfaceManager ()

@property (nonatomic, strong) HttpRequestClient *downloadClient;

- (void)cleanInterfaceInfo;

- (NSString *)getConfigVersion;

- (void)downloadInterfaceListSusseed:(NSDictionary *)respData;

- (void)downloadInterfaceListFailed:(NSError *)error;

@end

@implementation InterfaceManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![CheckFirstInstalDataManager getHasLaunchedValue]) {
            //未启动过
            [self cleanInterfaceInfo];
        }
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[InterfaceManager alloc] init];
    });
    return _sharedInstance;
}

- (void)updateInterface {
    if (!self.downloadClient) {
        if (!self.downloadClient) {
            self.downloadClient = [HttpRequestClient clientWithUrlString:MAIN_GETINTERFACE];
        }
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[self getConfigVersion], @"cfgver", @"1", @"app", [GConfig getCurrentAppVersionCode], @"appVersion", nil];
    
    __weak InterfaceManager *weakSelf = self;
    [weakSelf.downloadClient startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf downloadInterfaceListSusseed:responseData];
        [CheckFirstInstalDataManager setHasLaunchedValue:YES];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf downloadInterfaceListFailed:error];
        [CheckFirstInstalDataManager setHasLaunchedValue:YES];
    }];
}

#pragma mark Private methods

- (NSString *)getConfigVersion {
    NSString *versionLocal = [[NSUserDefaults standardUserDefaults] objectForKey:kidsTCAppSDKVersionKey];
    if (versionLocal == nil)
    {
        versionLocal = kidsTCAppSDKVersion;
    }
    return versionLocal;
}

- (void)downloadInterfaceListSusseed:(NSDictionary *)respData {
    _interfaceData = respData;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
        
        BOOL res = [self.interfaceData writeToFile:FILE_CACHE_PATH(@"interface_list.plist") atomically:NO];
//        BOOL res = [self.interfaceData writeToFile:FILE_FULL_PATH(@"interface_list.plist") atomically:NO];
        if (!res)
        {
            _interfaceData = [self loadBundle];
        }
        else
        {
            NSString *newVersion = [self.interfaceData objectForKey:@"version"];
            [[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:kidsTCAppSDKVersionKey];
            [[NSUserDefaults standardUserDefaults] setObject:[GConfig getCurrentAppVersionCode] forKey:kInterfaceBundleVersion];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
            [[GConfig sharedConfig] refresh:self.interfaceData];
        });
    });
}

- (void)downloadInterfaceListFailed:(NSError *)error {
    
}

- (NSDictionary*)loadBundle
{
    NSDictionary*dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interface_list" ofType:@"plist"]];
    return dic;
}

- (void)cleanInterfaceInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kidsTCAppSDKVersionKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kInterfaceBundleVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
