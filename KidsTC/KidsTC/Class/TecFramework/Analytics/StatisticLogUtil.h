/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：StatisticLogUtil.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月15日
 */

#import <Foundation/Foundation.h>
#import "LogDefine.h"
#import "Reachability.h"
//#import "SepLevelLogger.h"
#import "MTA.h"

#define LogUtilInst                                     [StatisticLogUtil sharedInstance]

#define NetWorkConnected                                (LogUtilInst.netAvailable)

// Fatal 类型需要即时发送
#define ILogFatal(api, time, code, frmt, ...)           do{LogSFatal([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__); \
                                                        SepLevelLoggerForceRoll(LOG_FLAG_FATAL); \
                                                        AutoPostStatisticFileDelay(1)}while(false);
#define ILogError(api, time, code, frmt, ...)           LogSError([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__)
#define ILogWarn(api, time, code, frmt, ...)            LogSWarn([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__)
#define ILogNotice(api, time, code, frmt, ...)          LogSNotice([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__)
#define ILogInfo(api, time, code, frmt, ...)            LogSInfo([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__)
#define ILogDebug(api, time, code, frmt, ...)           LogSDebug([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) timeDuration:(time)], ##__VA_ARGS__)

#define IOrderFatal(api, time, order, code, frmt, ...)  do{LogSFatal([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__); \
                                                        SepLevelLoggerForceRoll(LOG_FLAG_FATAL); \
                                                        AutoPostStatisticFileDelay(1)}while(false);
#define IOrderError(api, time, order, code, frmt, ...)  LogSError([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__)
#define IOrderWarn(api, time, order, code, frmt, ...)   LogSWarn([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__)
#define IOrderNotice(api, time, order, code, frmt, ...) LogSNotice([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__)
#define IOrderInfo(api, time, order, code, frmt, ...)   LogSInfo([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__)
#define IOrderDebug(api, time, order, code, frmt, ...)  LogSDebug([StatisticLogUtil LogBehaviorsWithApi:(api) errCode:(code) message:(frmt) orderId:(order) timeDuration:(time)], ##__VA_ARGS__)


#define EnableStatLogLevel(level)                       [StatisticLogUtil enableSeperateLevelLoggerForLevel:(level)];
#define ShowSeperateLevelLogInConsole(ifshow)           [StatisticLogUtil showSeperateLevelLogInConsole:(ifshow)];

#define AutoPostStatisticFileSetInterval(intival)       [LogUtilInst setPostFrequence:(MAX((intival), 30))];

#define AutoPostArchievedStatisticFile                  [LogUtilInst autoPostArchievedStatisticFile];
#define AutoPostStatisticFileDelay(delay)               [LogUtilInst autoPostArchievedStatisticFileWithDelay:(delay)];

#define AsyncUserDeviceInfo                             [LogUtilInst asyncUserDeviceInfoWithLoginStat:0];
#define AsyncUserDeviceInfoLogin                        [LogUtilInst asyncUserDeviceInfoWithLoginStat:1];
#define AsyncUserDeviceInfoLogout                       [LogUtilInst asyncUserDeviceInfoWithLoginStat:2];
#define AsyncGetPushNotification(block)                 [LogUtilInst asyncPushNotificationWithBlock:(block)];


@interface StatisticLogUtil : NSObject {
    
    Reachability *          _reachability;
    NSTimer *               _postTimer;
    
    BOOL                    _asyncUserInfoFail;
    NSInteger               _lastLoginStat;
    MTAAppMonitorStat *mtaUserInfoUpdate;
    
   
}

@property BOOL                              netAvailable;
@property (nonatomic, strong) NSString *    netType;
@property (nonatomic, strong) NSString *    netStatus;
@property NSTimeInterval                    postFrequence;  // every 10 min for default

+ (StatisticLogUtil*) sharedInstance;

+ (void) enableSeperateLevelLoggerForLevel:(NSInteger)level;
+ (void) showSeperateLevelLogInConsole:(BOOL)ifShow;

+ (NSString*) LogCommonHeaderOfLogFlag:(NSInteger)flag;

+ (NSString*) LogBehaviorsWithApi:(NSString*)apiName errCode:(NSInteger)err message:(NSString*)msg timeDuration:(NSTimeInterval)duration;
+ (NSString*) LogBehaviorsWithApi:(NSString*)apiName errCode:(NSInteger)err message:(NSString*)msg orderId:(NSString*)order timeDuration:(NSTimeInterval)duration;

- (void) autoPostArchievedStatisticFile;
- (void) autoPostArchievedStatisticFileWithDelay:(NSTimeInterval)delay;


// 信息统计接口
- (void) asyncUserDeviceInfoWithLoginStat:(NSInteger)stat; // 0=none, 1=login, 2=logout
- (void) asyncPushNotificationWithBlock:(void (^)(id, int))block;    // data dict and err code

@end


