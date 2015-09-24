/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：LogDefine.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月08日
 */

#import "DDLog.h"

// general define

#define LogContextLog                            1000
#define LogContextStatistic                      1001

#define LogContextCustomBase                     10000


// First undefine the default stuff we don't want to use.

#undef LOG_FLAG_ERROR
#undef LOG_FLAG_WARN 
#undef LOG_FLAG_INFO
#undef LOG_FLAG_DEBUG
#undef LOG_FLAG_VERBOSE

#undef LOG_LEVEL_ERROR
#undef LOG_LEVEL_WARN
#undef LOG_LEVEL_INFO
#undef LOG_LEVEL_DEBUG
#undef LOG_LEVEL_VERBOSE

#undef LOG_ERROR
#undef LOG_WARN
#undef LOG_INFO
#undef LOG_DEBUG
#undef LOG_VERBOSE

#undef DDLogError
#undef DDLogWarn
#undef DDLogInfo
#undef DDLogVerbose

#undef DDLogCError
#undef DDLogCWarn
#undef DDLogCInfo
#undef DDLogCVerbose


// Now define everything how we want it

#define LOG_FLAG_FATAL      (1 << 0)  // 0...0000001
#define LOG_FLAG_ERROR      (1 << 1)  // 0...0000010
#define LOG_FLAG_WARN       (1 << 2)  // 0...0000100
#define LOG_FLAG_NOTICE     (1 << 3)  // 0...0001000
#define LOG_FLAG_INFO       (1 << 4)  // 0...0010000
#define LOG_FLAG_DEBUG      (1 << 5)  // 0...0100000
#define LOG_FLAG_VERBOSE    (1 << 6)  // 0...1000000

#define LOG_LEVEL_FATAL   (LOG_FLAG_FATAL)                         // 0...0000001
#define LOG_LEVEL_ERROR   (LOG_FLAG_ERROR      | LOG_LEVEL_FATAL ) // 0...0000011
#define LOG_LEVEL_WARN    (LOG_FLAG_WARN       | LOG_LEVEL_ERROR ) // 0...0000111
#define LOG_LEVEL_NOTICE  (LOG_FLAG_NOTICE     | LOG_LEVEL_WARN  ) // 0...0001111
#define LOG_LEVEL_INFO    (LOG_FLAG_INFO       | LOG_LEVEL_NOTICE) // 0...0011111
#define LOG_LEVEL_DEBUG   (LOG_FLAG_DEBUG      | LOG_LEVEL_INFO  ) // 0...0111111
#define LOG_LEVEL_VERBOSE (LOG_FLAG_VERBOSE   | LOG_LEVEL_DEBUG )  // 0...1111111

#define LOG_FATAL   (ddLogLevel & LOG_FLAG_FATAL )
#define LOG_ERROR   (ddLogLevel & LOG_FLAG_ERROR )
#define LOG_WARN    (ddLogLevel & LOG_FLAG_WARN  )
#define LOG_NOTICE  (ddLogLevel & LOG_FLAG_NOTICE)
#define LOG_INFO    (ddLogLevel & LOG_FLAG_INFO  )
#define LOG_DEBUG   (ddLogLevel & LOG_FLAG_DEBUG )
#define LOG_VERBOSE (ddLogLevel & LOG_DEBUG )

#define LogFatal(frmt, ...)    SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_FATAL,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogError(frmt, ...)   ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_ERROR,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogWarn(frmt, ...)    ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_WARN,   LogContextLog, frmt, ##__VA_ARGS__)
#define LogNotice(frmt, ...)  ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_NOTICE, LogContextLog, frmt, ##__VA_ARGS__)
#define LogInfo(frmt, ...)    ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_INFO,   LogContextLog, frmt, ##__VA_ARGS__)
#define LogDebug(frmt, ...)   ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_DEBUG,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogVerbose(frmt, ...) ASYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_DEBUG,  LogContextLog, frmt, ##__VA_ARGS__)

#define LogCFatal(frmt, ...)   SYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_FATAL,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogCError(frmt, ...)  ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_ERROR,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogCWarn(frmt, ...)   ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_WARN,   LogContextLog, frmt, ##__VA_ARGS__)
#define LogCNotice(frmt, ...) ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_NOTICE, LogContextLog, frmt, ##__VA_ARGS__)
#define LogCInfo(frmt, ...)   ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_INFO,   LogContextLog, frmt, ##__VA_ARGS__)
#define LogCDebug(frmt, ...)  ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_DEBUG,  LogContextLog, frmt, ##__VA_ARGS__)
#define LogCVerbose(frmt, ...)  ASYNC_LOG_C_MAYBE(ddLogLevel, LOG_FLAG_VERBOSE,  LogContextLog, frmt, ##__VA_ARGS__)

// log statistic
#define LogSFatal(frmt, ...)   SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_FATAL,  LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSError(frmt, ...)   SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_ERROR,  LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSWarn(frmt, ...)    SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_WARN,   LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSNotice(frmt, ...)  SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_NOTICE, LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSInfo(frmt, ...)    SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_INFO,   LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSDebug(frmt, ...)   SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_DEBUG,  LogContextStatistic, frmt, ##__VA_ARGS__)
#define LogSVerbose(frmt, ...) SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_VERBOSE,  LogContextStatistic, frmt, ##__VA_ARGS__)

// custom log
#define LogCustom(ctx, frmt, ...)    SYNC_LOG_OBJC_MAYBE(ddLogLevel, LOG_FLAG_INFO,  ctx, frmt, ##__VA_ARGS__)


// Debug levels: off, fatal, error, warn, notice, info, debug
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


