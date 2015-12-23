/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：DownLoadManager.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月02日
 */

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASICacheDelegate.h"
#import "ASIProgressDelegate.h"

#define DOWNLOAD_DEFAULT_GROUP                  @"default"      // default download group
#define DOWNLOAD_PERMANENT_GROUP                @"permanent"    // group for permanent save
#define DOWNLOAD_TEMP_GROUP                     @"temp"         // this group will clean up, when exit

typedef enum {
    HttpStatusOK                  = 200,
    HttpStatusNotModified         = 304,
    HttpStatusBadRequest          = 400,
    HttpStatusNotAuthorized       = 401,
    HttpStatusForbidden           = 403,
    HttpStatusNotFound            = 404,
    HttpStatusServerInternalError = 500,
    HttpStatusServiceNotAvailable = 504
} HttpStatus;

typedef enum{
    RetCodeOK            = 0,
    RetCodeFail          = 101,
    RetCodeNotModified   = 102,
    RetCodeNoCacheData   = 103,
    RetCodeUserPassError = 10000,
    RetCodeParamError    = 10001,
    RetCodeFreqLimited   = 10002,
    RetCodeAuthFail      = 10003,
    RetCodeNOPrevilige   = 10004,
    RetCodeIntervalError = 10005,
    RetCodeNoDataReturn  = 10006,
    RetCodeNetworkError  = 10007,
    RetCodeCanceled      = 10008,
    RetCodeNeedVerifyCode = 10009,
    RetCodeVerifyCodeError = 10010,
    RetCodeOtherError    = 10100
} RetCode;


/////////////////////////////////////////////////////////////////////////////////////////////

typedef enum 
{
    eCallbackOldDataIfExist = 0,        // default option. if the data exist, return with callback, if not, try get newest from server and return the new data
    eCallbackOldDataNoFetchNew,         // only read cache data and return the cached data, return fail if not exist, NSVER ask for server
    eCallbackBothOldAndNewData,         // first return the old data, if new data is available, get from server, overwirte the old data and callback with new data again
    eCallbackOldDataFetchNewData,       // if the data exist, return with callback. Try get newest from server, overwirte the old data, and done
    eCallbackNewDataIfExist,            // try fetch the new data, if success, overwrite the old one and callback, else callback with old data if exist
}eDownLoadCallbackOption;


typedef enum
{
    eDownLoadDataNormal = 0,        // default option. will return NSData format
    eDownLoadDataImage,             // will try to convert data into UIImage, if fail, return raw data
}eDownLoadDataType;


@interface DownloadOption : NSObject

@property   BOOL                                            isPost;
@property   eDownLoadCallbackOption                         callbackOption;
@property   eDownLoadDataType                               dataFormat;
@property(nonatomic, weak) id<ASIProgressDelegate>          processDelegate;

@end


static inline DownloadOption * DownloadOptionMakeAll(BOOL isPost, eDownLoadCallbackOption callbackOption, eDownLoadDataType dataFormat, id delegate)
{
    DownloadOption * option = [[DownloadOption alloc] init];
    option.isPost = isPost;
    option.callbackOption = callbackOption;
    option.dataFormat = dataFormat;
    option.processDelegate = delegate;
    return option;
}

static inline DownloadOption * DownloadOptionMake(BOOL isPost, eDownLoadCallbackOption callbackOption, id delegate) {
    return DownloadOptionMakeAll(isPost, callbackOption, eDownLoadDataNormal, delegate);
}

static inline DownloadOption * DownloadOptionMakeImage(BOOL isPost, eDownLoadCallbackOption callbackOption, id delegate) {
    return DownloadOptionMakeAll(isPost, callbackOption, eDownLoadDataImage, delegate);
}

#define DownloadOptionDefault       DownloadOptionMake(NO, eCallbackOldDataIfExist, nil)
#define DownloadOptionPost          DownloadOptionMake(YES, eCallbackOldDataIfExist, nil)
#define DownloadOptionImage         DownloadOptionMakeImage(NO, eCallbackOldDataIfExist, nil)


/////////////////////////////////////////////////////////////////////////////////////////////

typedef enum 
{
    eDownLoadStatNone = 0,
    eDownLoadStatPrecessing,
    eDownLoadStatComplete
}eDownLoadStat;

typedef void (^successDlBlock)(id);
typedef void (^failureDlBlock)(NSError*);
typedef void (^preprocessBlock)(ASIHTTPRequest*);
typedef NSString* (^keyMakersBlock)(NSString*);                // convert url to key for db request key

@class FMDatabase;
@class FMDatabaseQueue;

@interface DownLoadManager : NSObject <ASIHTTPRequestDelegate> {
    
    NSMutableDictionary *                _pendingEntries;
    NSLock *                             _pendingLock;
    
    NSMutableDictionary *                _completeEntries;
    NSMutableDictionary *                _cacheEntries;
    NSLock *                             _cacheLock;
    
    NSString *                           _rootDirectory;
    NSDateFormatter *                    _filenameFormatter;
    
    FMDatabase *                         _db;
    FMDatabaseQueue *                    _dbQueue;
    
}

@property (nonatomic, copy) keyMakersBlock                defaultKeyMaker;
@property (nonatomic) NSUInteger                          memCacheThreshold;

+ (DownLoadManager*) sharedDownLoadManager;

- (NSString *) downloadRootDirectory;

- (void)setMaxConcurrentOperationCountForDownload:(NSUInteger)cnt;

- (eDownLoadStat) urlStat:(NSString*)url withLocalUrl:(NSString**)localUrl;
- (eDownLoadStat) urlStat:(NSString*)url keyMaker:(keyMakersBlock)kBlock withLocalUrl:(NSString**)localUrl;

// return key for further operation, default is url
- (void) downloadWithUrl:(NSString*)url;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock preporcessBlock:(preprocessBlock)pBlock;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock preporcessBlock:(preprocessBlock)pBlock keyMaker:(keyMakersBlock)kBlock;

- (void) downloadWithUrl:(NSString*)url option:(DownloadOption*)option;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group option:(DownloadOption*)option;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option preporcessBlock:(preprocessBlock)pBlock;
- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option preporcessBlock:(preprocessBlock)pBlock keyMaker:(keyMakersBlock)kBlock;

- (void) cancelByUrl:(NSString*)url;
- (void) cancelByUrl:(NSString*)url keyMaker:(keyMakersBlock)kBlock;

- (void) removeByUrl:(NSString*)url;
- (void) removeByUrl:(NSString*)url keyMaker:(keyMakersBlock)kBlock;

- (void) cancelByGroup:(NSString*)group;

- (void) flush;
- (void) cleanAllTemp;
- (void) cleanAllForGroup:(NSString*)group;
- (void) cleanAllGroup;     // except permanent group
- (void) cleanOutOfDate:(NSTimeInterval)maxAge forGroup:(NSString*)group;       // nil for all group
- (void) cleanWildFile;     // this method could be slow
- (void) cleanRestrictToCount:(NSUInteger)count thresholdCnt:(NSUInteger)threshold forGroup:(NSString*)group;   // nil for all group
- (void) cleanRestrictToCount:(NSUInteger)count thresholdCnt:(NSUInteger)threshold forGroups:(NSArray*)groups;  // retrict several group total count

- (void) setBackgroundDownLoadProgressDelegate:(id)delegate;


// helper function

+ (BOOL) isRemoteUrl:(NSString*)url;
+ (NSDictionary*) fileStatForPath:(NSString*)loacalPath;

@end
