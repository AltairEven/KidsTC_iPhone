/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：StatisticLogUtil.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月15日
 */

#import "StatisticLogUtil.h"
#import "UIDevice+IdentifierAddition.h"
#import "ASIDataProvider.h"
#import "NSTimer+Blocks.h"
//#import "EasyStatistic.h"
#import "UserWrapper.h"
#import "Constants.h"
#import "NSString+MD5Addition.h"
#import "NSString+ShiftEncode.h"
#import "MTA.h"
#import "HttpProcessHelper.h"


#define STATISTIC_LOG_URL       @"http://app.51buy.com/json.php?mod=aalert&act=upload"

#define POST_DELAY              0.5f
#define I2N(i)                  [NSNumber numberWithInteger:(i)]


@implementation StatisticLogUtil
@synthesize netAvailable = _netAvailable;
@synthesize netType = _netType;
@synthesize netStatus = _netStatus;
@synthesize postFrequence = _postFrequence;  // every 10 min for default

static StatisticLogUtil *sharedInstance = nil;

+ (StatisticLogUtil*) sharedInstance
{
    if (nil == sharedInstance) {
        sharedInstance = [[StatisticLogUtil alloc] init];
    }
	return sharedInstance;
}

+ (NSString*)icsonKey
{
    // 为防止金手指，每次都是计算生成
    
    NSString * str = [NSString stringWithFormat:@"%@", @"icson"];
    NSNumber * h = [NSNumber numberWithDouble:6.6260693];
    NSString * sourceKey = [NSString stringWithFormat:@"%@%@", str, h];
    
    NSMutableArray * shiftArr = [NSMutableArray arrayWithCapacity:sourceKey.length];
    double shift = M_E;
    for (int i = 0; i < sourceKey.length; i++) {
        NSInteger oneShift = shift;
        [shiftArr addObject:I2N(oneShift)];
        shift = (shift - oneShift)*10;
    }

    return [sourceKey shiftEachDigit:shiftArr];
}

- (void)netStatusUpdate:(NetworkStatus)status
{
    _netAvailable = NO;
    switch (status){
        case ReachableViaWWAN:  // 3G
        {
            self.netType = @"3G";
            self.netStatus = @"CONNECTED";
            _netAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            self.netType = @"Wifi";
            self.netStatus = @"CONNECTED";
            _netAvailable = YES;
            break;
        }
        case ReachableVia2G:
        {
            self.netType = @"2G";
            self.netStatus = @"CONNECTED";
            _netAvailable = YES;
            break;
        }
        case NotReachable:
        {
            self.netType = @"NotReachable";
            self.netStatus = @"DISCONNECTED";
            break;
        }
        default:
            self.netType = @"UnKnow";
            self.netStatus = @"UNKNOWN";
    }
    
    if (_netAvailable)
    {
        if (_asyncUserInfoFail) {
            [LogUtilInst asyncUserDeviceInfoWithLoginStat:_lastLoginStat];
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Do not use shared reachablity, OR the network type will be wrong (NotReachable), when the server is down and network is still available.
        _reachability = [Reachability reachabilityForInternetConnection];
        [_reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        [self netStatusUpdate:[_reachability currentReachabilityStatus]];
        
        _postFrequence = 60 * 10;
        _asyncUserInfoFail = NO;
        _lastLoginStat = 0;
    }
    return self;
}

- (void)dealloc
{
    
    [_postTimer invalidate];
    _postTimer = nil;
    [_reachability stopNotifier];
}

- (void)reachabilityChanged:(NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self netStatusUpdate:[curReach currentReachabilityStatus]];
}

+ (void) enableSeperateLevelLoggerForLevel:(NSInteger)level
{
    if (level & LOG_FLAG_FATAL) {
       // SepLevelLoggerCreateWithHeader(LOG_FLAG_FATAL, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_FATAL]);
        // max 10 files, each 1kB max size, roll every 1 min
       // SepLevelLoggerSetup(LOG_FLAG_FATAL, 10, 1024, 60);
    }
    if (level & LOG_FLAG_ERROR) {
      //  SepLevelLoggerCreateWithHeader(LOG_FLAG_ERROR, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_ERROR]);
        // max 10 files, each 4kB max size, roll every 5 min
      //  SepLevelLoggerSetup(LOG_FLAG_ERROR, 10, 1024 * 4, 60 * 5);
    }
    if (level & LOG_FLAG_WARN) {
      //  SepLevelLoggerCreateWithHeader(LOG_FLAG_WARN, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_WARN]);
        // max 10 files, each 16kB max size, roll every 10 min
       // SepLevelLoggerSetup(LOG_FLAG_WARN, 10, 1024 * 16, 60 * 10);
    }
    if (level & LOG_FLAG_NOTICE) {
        //SepLevelLoggerCreateWithHeader(LOG_FLAG_NOTICE, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_NOTICE]);
        // max 10 files, each 16kB max size, roll every 30 min
      //  SepLevelLoggerSetup(LOG_FLAG_NOTICE, 10, 1024 * 16, 60 * 30);
    }
    if (level & LOG_FLAG_INFO) {
       // SepLevelLoggerCreateWithHeader(LOG_FLAG_INFO, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_INFO]);
        // max 10 files, each 16kB max size, roll every 60 min
        //SepLevelLoggerSetup(LOG_FLAG_INFO, 10, 1024 * 16, 60 * 60);
    }
    if (level & LOG_FLAG_DEBUG) {
        //SepLevelLoggerCreateWithHeader(LOG_FLAG_DEBUG, [StatisticLogUtil LogCommonHeaderOfLogFlag:LOG_FLAG_DEBUG]);
        // max 10 files, each 16kB max size, roll every 120 min
       // SepLevelLoggerSetup(LOG_FLAG_DEBUG, 10, 1024 * 16, 60 * 120);
    }
    
   // SepLevelLoggerEnableAll
}

+ (void) showSeperateLevelLogInConsole:(BOOL)ifShow
{
    if (ifShow) {
     //   ConsoleLogEnable
    } else {
      //  ConsoleLogDisable
    }
    //SepLevelLoggerShowInConsole(ifShow);
}

+ (NSString*) LogCommonHeaderOfLogFlag:(NSInteger)flag
{
    // Channel|平台|OS版本|App名字|App版本|Device ID|优先级（log等级）

    static NSString * header = nil;
    
    if (nil == header) {
        NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
        UIDevice * device = [UIDevice currentDevice];
        
        header = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@|%@|%@|%@",
                  @"appStore",
                  [device platformString],                                              // iPhone, iPad
                  device.systemVersion,                                      // 5.0
                  [infoDict objectForKey:@"CFBundleDisplayName"],            // 手机SOSO
                  [infoDict objectForKey:@"CFBundleVersion"],                // 1.0.0
                  device.localizedModel,                                     // iPhone, iPad
                  [device uniqueDeviceIdentifier]];                          // UDID
    }
    
    NSInteger level = 100;
    switch (flag) {
        case LOG_FLAG_FATAL:
            level = 0;
            break;
        case LOG_FLAG_ERROR:
            level = 1;
            break;
        case LOG_FLAG_WARN:
            level = 2;
            break;
        case LOG_FLAG_NOTICE:
            level = 3;
            break;
        case LOG_FLAG_INFO:
            level = 4;
            break;
        case LOG_FLAG_DEBUG:
            level = 5;
            break;
            
        default:
            break;
    }
    
    return [header stringByAppendingFormat:@"|%ld$", (long)level];     // log优先级
}

+ (NSString*) LogBehaviorsWithApi:(NSString*)apiName errCode:(NSInteger)err message:(NSString*)msg timeDuration:(NSTimeInterval)duration
{
    return [self LogBehaviorsWithApi:apiName errCode:err message:msg orderId:@"" timeDuration:duration];
}

+ (NSString*) LogBehaviorsWithApi:(NSString*)apiName errCode:(NSInteger)err message:(NSString*)msg orderId:(NSString*)order timeDuration:(NSTimeInterval)duration
{
    // apiName|networkType|networkState|errorCode|errorMsg| uid|timestampMs|orderId|extra
    // networkState(CONNECTED, CONNECTING, DISCONNECTED, DISCONNECTING, SUSPENDED, UNKNOWN), IOS只需填写CONNECTED、DISCONNECTED,UNKNOWN类型
    
    return [NSString stringWithFormat:@"%@|%@|%@|%ld|%@|%ld|%f|%@|%f|$", apiName, LogUtilInst.netType, LogUtilInst.netStatus, (long)err, (msg ? msg : @""), (long)([UserWrapper shareMasterUser].uid), duration, order, [[NSDate date] timeIntervalSince1970]];
}

- (void) autoPostArchievedStatisticFile
{
    static BOOL isPosting = NO;
    static BOOL shouldRePosting = NO;
	
    NSString * url = [NSString stringWithFormat:@"%@&appSource=iPhone&appVersion=%@", STATISTIC_LOG_URL, [GConfig getCurrentAppVersionCode]];
	if(url.length == 0)
		return ;
	BOOL b = [GToolUtil filterBlackList:url];
	if(!b)return ;
	
    [_postTimer invalidate];
    _postTimer = nil;
    
    if (!isPosting) 
    {
        shouldRePosting = NO;
        
        NSArray * logArr = nil;
        if ([_netType isEqualToString:@"Wifi"]) {
        //    logArr = SepLevelLoggerArchievedListAll;
        } else if (_netAvailable) {
           // logArr = SepLevelLoggerArchievedList(LOG_FATAL);
        }
        isPosting = logArr.count > 0;
        
        if (!isPosting) {
            AutoPostStatisticFileDelay(_postFrequence)
            return;
        }
        //NSLog(@"log arr = %@", logArr);
        NSTimeInterval delay = 1.0; 
        __block NSUInteger sendCnt = logArr.count;
        for (NSString * logPath in logArr) 
        {
            BOOL isValidLog = NO;
            if (logPath && logPath.length > 0) {
                //NSString * logContent = [NSString stringWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:nil];
                NSData * logData = [NSData dataWithContentsOfFile:logPath];
                if (logData && logData.length > 0) 
                {
                    isValidLog = YES;
                    
                    [NSTimer scheduledTimerWithTimeInterval:(POST_DELAY+delay++) block:^{
                       
                        ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
                        
                        __weak typeof(request) weakReq = request;
                        
                        //[request setPostValue:logContent forKey:@"report"];
                        [request setPostValue:@"datafile" forKey:@"file"];
                        [request setData:logData forKey:@"datafile"];
                        
                        [request setCompletionBlock:^{

                           [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];

                            if (--sendCnt <= 0) {
                                LogDebug(@"Statistic Log all post!!");
                                isPosting = NO;
                                if (shouldRePosting) AutoPostStatisticFileDelay(1)
                                else AutoPostStatisticFileDelay(_postFrequence)
                            }
                        }];
                        
                        [request setFailedBlock:^{
                            LogError(@"Statistic Log post error: %@", [weakReq error]);
                            if (--sendCnt <= 0) {
                                isPosting = NO;
                                if (shouldRePosting) AutoPostStatisticFileDelay(1)
                                else AutoPostStatisticFileDelay(_postFrequence)
                            }
                        }];
                        
                        [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];
                        
                    } repeats:NO];
                }
            }
            
            if (!isValidLog && (--sendCnt <= 0)) {
                LogDebug(@"no send Statistic log at all");
                isPosting = NO;
                if (shouldRePosting) AutoPostStatisticFileDelay(1)
                else AutoPostStatisticFileDelay(_postFrequence)
            }
        }
    } else {
        shouldRePosting = YES;
    }
}

- (void) autoPostArchievedStatisticFileWithDelay:(NSTimeInterval)delay
{
    // disable old timer
    [_postTimer invalidate];
    _postTimer = nil;
    
    // active new timer for post next log file
    _postTimer = [NSTimer scheduledTimerWithTimeInterval:delay block:^{
        AutoPostArchievedStatisticFile
        if (_netAvailable) {
            if (_asyncUserInfoFail) {
                [LogUtilInst asyncUserDeviceInfoWithLoginStat:_lastLoginStat];
            }
        }
    } repeats:NO];
}


- (void) asyncUserDeviceInfoWithLoginStat:(NSInteger)stat
{
    NSString * url = [NSString stringWithFormat:@"%@&appSource=iPhone&appVersion=%@", URL_USERINFO_UPDATE, [GConfig getCurrentAppVersionCode]];
    mtaUserInfoUpdate = [[MTAAppMonitorStat alloc] init];
    [mtaUserInfoUpdate setInterface:@"URL_USERINFO_UPDATE"];
    
	if(url == nil)
		return;
	
	BOOL b = [GToolUtil filterBlackList:url];
	if(!b)return ;
	
    _lastLoginStat = stat;
    
    if (!_netAvailable) {
        _asyncUserInfoFail = YES;
        return;
    }
    _asyncUserInfoFail = NO;
    
    UserWrapper *user = [UserWrapper shareMasterUser];
    UIDevice * device = [UIDevice currentDevice];
    
    NSString * oldUdid = @"";
    NSString * udid = [device vendorIdentifier:&oldUdid];
    
    NSString* deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceToken];
    double lat = [[NSUserDefaults standardUserDefaults] doubleForKey:kLantitude];
    double lon = [[NSUserDefaults standardUserDefaults] doubleForKey:kLongitude];
    NSDictionary * plistDict = [[NSBundle mainBundle] infoDictionary];

	
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [request setStringEncoding: CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 )];
    
    [request setPostValue:udid forKey:@"udid"];
    [request setPostValue:[[NSString stringWithFormat:@"%@&%@", udid, [StatisticLogUtil icsonKey]] stringFromMD5] forKey:@"verify_key"];
    
    [request setPostValue:I2N(200) forKey:@"device_type"];       // 200 for iphone
    //edit by Altair, 20141125, use CFBundleShortVersionString istead of CFBundleVersion
    [request setPostValue:[plistDict objectForKey:@"CFBundleShortVersionString"] forKey:@"app_version"];
    [request setPostValue:device.systemVersion forKey:@"os_version"];

	[request setPostValue:[[UserWrapper shareMasterUser] provinceId] forKey:@"geo_graphic"];
    [request setPostValue:[[UserWrapper shareMasterUser] provinceId] forKey:@"zone"];

    
    [request setPostValue:@"开发" forKey:@"app_src"];
    
    if (lat != 0 || lon != 0) {
        [request setPostValue:[NSNumber numberWithDouble:lat] forKey:@"lat"];
        [request setPostValue:[NSNumber numberWithDouble:lon] forKey:@"lon"];
    }
    if (user.uid > 0) [request setPostValue:I2N(user.uid) forKey:@"uid"];
    if (stat > 0) [request setPostValue:I2N(stat) forKey:@"status"];
    if (deviceToken) [request setPostValue:deviceToken forKey:@"device_token"];
    if (oldUdid) [request setPostValue:oldUdid forKey:@"oldUdid"];
    
    //NSLog(@"uid = %d, udid = %@, token = %@, oldUdid = %@", user.uid, udid, deviceToken, oldUdid);
    
    __weak typeof(request) weakReq = request;
    
    [request setCompletionBlock:^{
        [mtaUserInfoUpdate setResultType:MTA_SUCCESS];
        [MTA reportAppMonitorStat:mtaUserInfoUpdate];
        _asyncUserInfoFail = NO;
        NSLog(@"asyncUserDeviceInfo return = %@", weakReq.responseString);
    }];
    [request setFailedBlock:^{
        [mtaUserInfoUpdate setResultType:MTA_FAILURE];
        [MTA reportAppMonitorStat:mtaUserInfoUpdate];
        _asyncUserInfoFail = YES;
        NSString *errMsg = [NSString stringWithFormat:@"更新用户设备信息失败，失败码：%@", weakReq.error];
        [MTA trackError:errMsg];
        NSLog(@"asyncUserDeviceInfo error = %@", weakReq.error);
    }];
    
    [HttpProcessHelper getIcsonCookie:request];
    
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];

}


- (void) asyncPushNotificationWithBlock:(void (^)(id, int))block
{
    UserWrapper *user = [UserWrapper shareMasterUser];
    NSString * url = [NSString stringWithFormat:@"%@&appSource=iPhone&appVersion=%@", URL_PUSHNOTIFY_GET, [GConfig getCurrentAppVersionCode]];
    
    
	if(url == nil)
	{
		return;
	}
	BOOL b = [GToolUtil filterBlackList:url];
	if(!b)return ;
	
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setStringEncoding: CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 )];
    
    if (user.uid > 0) {
        [request setPostValue:I2N(user.uid) forKey:@"uid"];
    } else {
        NSString* deviceToken = [[NSUserDefaults standardUserDefaults] stringForKey:kDeviceToken];
        if (deviceToken) [request setPostValue:deviceToken forKey:@"token"];
    }

    if (block)
    {
        __weak typeof(request) weakReq = request;
        
        [request setCompletionBlock:^{
            MTAAppMonitorStat *mtaPushNotifyGetStat;
            mtaPushNotifyGetStat = [[MTAAppMonitorStat alloc] init];
            [mtaPushNotifyGetStat setInterface:@"URL_PUSHNOTIFY_GET"];
            [mtaPushNotifyGetStat setResultType:MTA_SUCCESS];
            [MTA reportAppMonitorStat:mtaPushNotifyGetStat];
            NSDictionary * allDict = [weakReq.responseData toJSONObjectFO];
            if (allDict) {
                int errNo = [[allDict objectForKey: @"errno"] intValue];
                block([allDict objectForKey: @"data"], errNo);
            } else {
                block(nil, -1);
            }
        }];
        [request setFailedBlock:^{
            MTAAppMonitorStat *mtaPushNotifyGetStat;
            mtaPushNotifyGetStat = [[MTAAppMonitorStat alloc] init];
            [mtaPushNotifyGetStat setInterface:@"URL_PUSHNOTIFY_GET"];
            [mtaPushNotifyGetStat setResultType:MTA_FAILURE];
            [MTA reportAppMonitorStat:mtaPushNotifyGetStat];

            NSString *errMsg = [NSString stringWithFormat:@"获取push消息接口失败"];
            [MTA trackError:errMsg];
            block(nil, weakReq.responseStatusCode);
        }];
    }
    
    [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];
}

@end

