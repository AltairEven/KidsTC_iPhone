/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：DownLoadManager.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年12月02日
 */

#import <sys/attr.h>
#import <sys/xattr.h>
#import "DownLoadManager.h"
#import "ASIDataProvider.h"
#import "NSError+Ext.h"
#import "NSTimer+Blocks.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "NSDate+HttpDate.h"
//#import "NSString+MD5Addition.h"

//#define ENABLE_LOG_TIME

#define DOWNLOAD_FILE_EXTENSION                 @"dl"
#define DOWNLOAD_REAL_KEY                       @"dlKey"
#define DOWNLOAD_BG_GROUP                       @"downloadBg"   // default download queue group

#define SAVE_THRESHOLD                          5               // over 5 logs to save
#define TIME_THRESHOLD                          (5 * 60)        // 5 min to save

#define MEMCACHE_THRESHOLD                      1200
#define MEMCACHE_THRESHOLD_MIN                  100

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DownloadOption
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DownloadDataEntry : NSObject {
    
    NSString *                  _subPath;
    NSString *                  _fileName;
	NSDate   *                  _timestamp;
    
    ASIHTTPRequest *            _request;
    
    NSMutableArray *            _sBlocks;
    NSMutableArray *            _fBlocks;
    
    NSLock *                    _blockLock;
    eDownLoadCallbackOption     _callbackOption;

}

- (BOOL) isBlocksEmpty;
- (BOOL) isSuccessBlocksEmpty;
- (BOOL) isFailureBlocksEmpty;
- (void) addSuccessBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock;
- (void) performSuscessBlocks:(id)data;
- (void) performFailureBlocks:(NSError*)error;

@property (nonatomic, retain) NSString *            subPath;
@property (nonatomic, retain) NSString *            fileName;
@property (nonatomic, retain) NSDate *              timestamp;
@property (nonatomic, retain) ASIHTTPRequest *      request;
@property (nonatomic, retain) NSMutableArray *      sBlocks;
@property (nonatomic, retain) NSMutableArray *      fBlocks;
@property (nonatomic) eDownLoadCallbackOption       callbackOption;
@property (nonatomic) eDownLoadDataType             dataFormat;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DownloadDataEntry
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DownloadDataEntry

-(id) init
{
    self = [super init];
    if ( nil != self ) 
    {
        _blockLock = [[NSLock alloc] init];
        _sBlocks = [[NSMutableArray alloc] init];
        _fBlocks = [[NSMutableArray alloc] init];
        _callbackOption = eCallbackOldDataIfExist;
        _dataFormat = eDownLoadDataNormal;
    }
    
    return self;
}

- (BOOL) isBlocksEmpty {
    [_blockLock lock];
    BOOL isEmpty = ([_sBlocks count] + [_fBlocks count]) > 0 ? NO : YES;
    [_blockLock unlock];
    return isEmpty;
}

- (BOOL) isSuccessBlocksEmpty {
    [_blockLock lock];
    BOOL isEmpty = [_sBlocks count] > 0 ? NO : YES;
    [_blockLock unlock];
    return isEmpty;
}

- (BOOL) isFailureBlocksEmpty {
    [_blockLock lock];
    BOOL isEmpty = [_fBlocks count] > 0 ? NO : YES;
    [_blockLock unlock];
    return isEmpty;
}

- (void) addSuccessBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock
{
    [_blockLock lock];
    if (sBlock) {
        [_sBlocks addObject:[sBlock copy]];
    }
    if (fBlock) {
        [_fBlocks addObject:[fBlock copy]];
    }
    [_blockLock unlock];
}

- (void) performSuscessBlocks:(id)data
{
    // do not need lock, the block list will not be added at this time
    for (successDlBlock sBlock in _sBlocks) {
        if (sBlock) {
            sBlock(data);
        }
    }
}

- (void) performFailureBlocks:(NSError*)error
{
    // do not need lock, the block list will not be added at this time
    for (failureDlBlock fBlock in _fBlocks) {
        if (fBlock) {
            fBlock(error);
        }
    }
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SqlEntry : NSObject <NSCoding, NSCopying> {
    
    NSString *          _url;
    NSString *          _subPath;
    NSString *          _fileName;
	NSDate   *          _timestamp;
    NSString *          _lastModifyGMT;
    
}

@property (nonatomic, retain) NSString *        url;
@property (nonatomic, retain) NSString *        subPath;
@property (nonatomic, retain) NSString *        fileName;
@property (nonatomic, retain) NSDate *          timestamp;
@property (nonatomic, retain) NSString *        lastModifyGMT;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SqlEntry
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define STRING_OBJECT(x, y)                 [SqlEntry safeStringObject:(x) withDefault:(y)]
#define RETAIN_UTF8STRING_OBJECT(x, y)      [[STRING_OBJECT((x), (y)) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] retain]

#define NUMBER_OBJECT(x, y)                 [SqlEntry safeNumberObject:(x) withDefault:(y)]
#define RETAIN_NUMBER_OBJECT(x, y)          [NUMBER_OBJECT((x), (y)) retain]

@implementation SqlEntry

@synthesize url = _url;
@synthesize subPath = _subPath;
@synthesize fileName = _fileName;
@synthesize timestamp = _timestamp;
@synthesize lastModifyGMT = _lastModifyGMT;

+ (NSString*) safeStringObject:(id)obj withDefault:(NSString*)defaultStr {
    if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)obj description];
    }
    return defaultStr;
}

+ (NSNumber*) safeNumberObject:(id)obj withDefault:(NSNumber*)defaultNum {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithInteger:[(NSString*)obj integerValue]];
    }
    return defaultNum;
}

- (id)initWithFMResultSet:(FMResultSet*)rs
{
    self = [super init];
    if ( nil != self ) 
    {
        _url = [rs objectForColumnName:@"url"];
        _subPath   = [rs objectForColumnName:@"subpath"];
		_fileName   = [rs objectForColumnName:@"filename"];
        _timestamp   = [NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"timestamp"]];
        _lastModifyGMT   = STRING_OBJECT([rs objectForColumnName:@"lastgmt"] , nil);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)decoder 
{
    self = [super init];
    if ( nil != self ) 
    {
        self.url = [decoder decodeObjectForKey:@"url"];
        self.subPath = [decoder decodeObjectForKey:@"subPath"];
        self.fileName = [decoder decodeObjectForKey:@"fileName"];
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.lastModifyGMT = [decoder decodeObjectForKey:@"lastModifyGMT"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder 
{
    [encoder encodeObject:_url forKey:@"url"];
    [encoder encodeObject:_subPath forKey:@"subPath"];
    [encoder encodeObject:_fileName forKey:@"fileName"];
    [encoder encodeObject:_timestamp forKey:@"timestamp"];
    [encoder encodeObject:_lastModifyGMT forKey:@"lastModifyGMT"];
}

- (id)copyWithZone:(NSZone *)zone
{
    SqlEntry *entry = [[[self class] allocWithZone:zone] init];
    entry.url = [_url copy];
    entry.subPath = [_subPath copy];
    entry.fileName = [_fileName copy];
    entry.timestamp = [_timestamp copy];
    entry.lastModifyGMT = [_lastModifyGMT copy];
    return entry;
}

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - DownLoadManager
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface DownLoadManager (private)

- (NSString *)directoryByGroup:(NSString*)group;
- (BOOL) createDirctory:(NSString*)dirctory;
- (NSString*) nonreqeatFilename:(NSDate*)date;

@end


@interface DownLoadManager (db)

- (void)validateDBDirectory;
- (void)openDatabase;
- (void)checkDatabaseValidation:(FMDatabase*)db;

- (SqlEntry*)dbDataForUrl:(NSString*)url dbInst:(FMDatabase*)db;
- (void)dbDataInsertComplete:(BOOL)force;
- (void)dbDataRemoveForUrl:(NSString*)url;
- (SqlEntry*)dbDataForFileName:(NSString*)name dbInst:(FMDatabase*)db;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation DownLoadManager

static DownLoadManager * _instanceDownLoadManager = nil;

+ (DownLoadManager*) sharedDownLoadManager
{
    if (_instanceDownLoadManager == nil) {
        _instanceDownLoadManager = [[DownLoadManager alloc] init];
    }
	return _instanceDownLoadManager;
}

+ (id)contentsAtPath:(NSString*)path forType:(eDownLoadDataType)format
{
    id content = nil;
    if (eDownLoadDataImage == format) {
        content = [UIImage imageWithContentsOfFile:path];
    }
    if (nil == content) {
        content = [NSData dataWithContentsOfFile:path];
    }
    return content;
}

- (id) init
{
    self = [super init];
    if (self) 
    {
        self.memCacheThreshold = MEMCACHE_THRESHOLD;
        
        _pendingEntries = [[NSMutableDictionary alloc] initWithCapacity:20];
        _pendingLock = [[NSLock alloc] init];
        
        _completeEntries = [[NSMutableDictionary alloc] initWithCapacity:20];
        _cacheEntries = [[NSMutableDictionary alloc] initWithCapacity:20];
        _cacheLock = [[NSLock alloc] init];
        
        [[ASIDataProvider sharedASIDataProvider] setMaxConcurrentOperationCount:20 forGroup:DOWNLOAD_BG_GROUP];
        
        _filenameFormatter = [[NSDateFormatter alloc] init];
        [_filenameFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [_filenameFormatter setDateFormat:@"yyyyMMddHHmmss"];
        
        [NSTimer scheduledTimerWithTimeInterval:TIME_THRESHOLD block:^{
            [self dbDataInsertComplete:YES];
        } repeats:YES];
        
        [self validateDBDirectory];
		[self openDatabase];
        
//        self.defaultKeyMaker = ^(NSString * url) {
//            return [url stringFromMD5];
//        };
    }
    
    return self;
}

- (void) dealloc 
{
    [self dbDataInsertComplete:YES];
    [_db close];
    [_dbQueue close];
}

- (void)setMemCacheThreshold:(NSUInteger)memCacheThreshold
{
    if (memCacheThreshold < MEMCACHE_THRESHOLD_MIN) {
        _memCacheThreshold = MEMCACHE_THRESHOLD_MIN;
    } else {
        _memCacheThreshold = memCacheThreshold;
    }
}

+ (NSString*)trimString:(NSString*)str
{
    if (str) {
        NSMutableString * mutableStr = [NSMutableString stringWithString:str];
        CFStringTrimWhitespace((__bridge CFMutableStringRef) mutableStr);
        return mutableStr;
    }
    return @"";
}

- (void) appendKey:(NSString*)key toRequest:(ASIHTTPRequest*)request
{
    if (key) {
        NSMutableDictionary * info = (NSMutableDictionary*)request.userInfo;
        if (info) {
            if (![info isKindOfClass:[NSMutableDictionary class]]) {
                info = [request.userInfo mutableCopy];
            }
            [info setObject:key forKey:DOWNLOAD_REAL_KEY];
        } else {
            info = [NSMutableDictionary dictionaryWithObject:key forKey:DOWNLOAD_REAL_KEY];
        }

        request.userInfo = info;
    }
}

- (eDownLoadStat) urlStat:(NSString*)url withLocalUrl:(NSString**)localUrl
{
    return [self urlStat:url keyMaker:nil withLocalUrl:localUrl];
}

- (eDownLoadStat) urlStat:(NSString*)url keyMaker:(keyMakersBlock)kBlock withLocalUrl:(NSString**)localUrl
{
    url = [DownLoadManager trimString:url];
    
    NSString * key = url;
    if (kBlock) key = kBlock(url);
    else if (_defaultKeyMaker) key = _defaultKeyMaker(url);
    if (nil == key || key.length == 0) key = url;
    
    eDownLoadStat stat = eDownLoadStatNone;
    
    [_pendingLock lock];
    if ([_pendingEntries objectForKey:key]) {
        stat = eDownLoadStatPrecessing;
    }
    [_pendingLock unlock];
    
    if (eDownLoadStatNone == stat) 
    {
        SqlEntry * sqlEntry = nil;
        [_cacheLock lock];
        sqlEntry = [_cacheEntries objectForKey:key];
        [_cacheLock unlock];
        
        if (nil == sqlEntry) {
            sqlEntry = [self dbDataForUrl:key dbInst:_db];
        }
        
        if (sqlEntry) {
            stat = eDownLoadStatComplete;
            if (localUrl) {
                *localUrl = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], sqlEntry.subPath, sqlEntry.fileName];
            }
        }
    }

    return stat;
}

- (void)setMaxConcurrentOperationCountForDownload:(NSUInteger)cnt {
    [[ASIDataProvider sharedASIDataProvider] setMaxConcurrentOperationCount:cnt forGroup:DOWNLOAD_BG_GROUP];
}

- (void) downloadWithUrl:(NSString*)url {
    [self downloadWithUrl:url group:nil option:DownloadOptionDefault];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group {
    [self downloadWithUrl:url group:group successBlock:nil failureBlock:nil option:DownloadOptionDefault];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock
{
    [self downloadWithUrl:url group:group successBlock:sBlock failureBlock:fBlock option:DownloadOptionDefault];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock preporcessBlock:(preprocessBlock)pBlock
{
    [self downloadWithUrl:url group:group successBlock:sBlock failureBlock:fBlock option:DownloadOptionDefault preporcessBlock:pBlock];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock preporcessBlock:(preprocessBlock)pBlock keyMaker:(keyMakersBlock)kBlock
{
    [self downloadWithUrl:url group:group successBlock:sBlock failureBlock:fBlock option:DownloadOptionDefault preporcessBlock:pBlock keyMaker:kBlock];
}

- (void) downloadWithUrl:(NSString*)url option:(DownloadOption*)option {
    [self downloadWithUrl:url group:nil option:option];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group option:(DownloadOption*)option {
    [self downloadWithUrl:url group:group successBlock:nil failureBlock:nil option:option];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option
{
    [self downloadWithUrl:url group:group successBlock:sBlock failureBlock:fBlock option:option preporcessBlock:nil];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option preporcessBlock:(preprocessBlock)pBlock
{
    [self downloadWithUrl:url group:group successBlock:sBlock failureBlock:fBlock option:option preporcessBlock:pBlock keyMaker:nil];
}

- (void) downloadWithUrl:(NSString*)url group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option preporcessBlock:(preprocessBlock)pBlock keyMaker:(keyMakersBlock)kBlock
{
    if (nil == url || url.length == 0) {
        return;
    }
    
    url = [DownLoadManager trimString:url];

    BOOL b = [GToolUtil filterBlackList:url];
	if(!b)return ;
	
    NSString * key = url;
    if (kBlock) key = kBlock(url);
    else if (_defaultKeyMaker) key = _defaultKeyMaker(url);
    if (nil == key || key.length == 0) key = url;
    //if (kBlock) NSLog(@"key = %@", key);
    
    // check url
    NSURL * tmpUrl = [NSURL URLWithString:url];
    if (!tmpUrl || ![tmpUrl scheme]) {
        // not a remote url
        NSURL * aUrl = [NSURL fileURLWithPath:url];
        if (aUrl) {
            // local url
            if (sBlock) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    id data = [DownLoadManager contentsAtPath:url forType:option.dataFormat];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            sBlock(data);
                        } else if (fBlock) {
                            fBlock([NSError ErrorWithCode:RetCodeFail description:@"file broken"]);
                        }
                    });
                });
            } else if (fBlock) {
                fBlock([NSError ErrorWithCode:RetCodeNotModified description:url]);
            }
        } else if (fBlock) {
            // not a url
            fBlock([NSError ErrorWithCode:RetCodeFail description:url]);
        }
        return;
    }
    
    DownloadDataEntry * downEntry = nil;
    [_pendingLock lock];
    downEntry = [_pendingEntries objectForKey:key];
    [_pendingLock unlock];
    
    // request pending
    BOOL isPendding = NO;
    if (downEntry) 
    {
        isPendding = YES;
        
        if (option.processDelegate) {
            downEntry.request.downloadProgressDelegate = option.processDelegate;
        }
        
        if (sBlock || fBlock) 
        {
            if ([downEntry isBlocksEmpty]) 
            {
                [downEntry addSuccessBlock:sBlock failureBlock:fBlock];
                if (!downEntry.request.isFinished && !downEntry.request.isExecuting)
                {
                    // should change to faster queue
                    [downEntry.request clearDelegatesAndCancel];
                    downEntry.request = nil;
                    downEntry.callbackOption = option.callbackOption;       // last request do not even need a callback, so just overwrite it
                    downEntry.dataFormat = option.dataFormat;
					
					downEntry.timestamp = [NSDate date];
					if (nil == downEntry.subPath || nil == downEntry.fileName) {
						downEntry.subPath = group;
						downEntry.fileName = [self nonreqeatFilename:downEntry.timestamp];
					}
                    
                    ASIHTTPRequest * request = nil;
                    if (option.isPost) {
                        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
                    } else {
                        request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
                    }
                    request.shouldAttemptPersistentConnection = NO;
                    request.delegate = self;
                    request.downloadProgressDelegate = option.processDelegate;
                    request.downloadDestinationPath = [NSString stringWithFormat:@"%@/%@/%@.tmp", [self downloadRootDirectory], downEntry.subPath, downEntry.fileName];
                    if (pBlock) {
                        pBlock(request);
                    }
                    [self appendKey:key toRequest:request];
                    downEntry.request = request;
                    
                    [[ASIDataProvider sharedASIDataProvider] addASIRequest:downEntry.request withGroup:DOWNLOAD_BG_GROUP];
                }
            } else {
                [downEntry addSuccessBlock:sBlock failureBlock:fBlock];
            }
        }
        
        if (eCallbackNewDataIfExist == downEntry.callbackOption) {
            // the new data is in processing, so do not check old data in this option
            downEntry = nil;
            return;
        }
    } else {
        // add an empty downEntry
        DownloadDataEntry * newEntry = [[DownloadDataEntry alloc] init];
        newEntry.timestamp = [NSDate date];
        newEntry.subPath = group;
        newEntry.fileName = [self nonreqeatFilename:newEntry.timestamp];
        newEntry.callbackOption = option.callbackOption;       // last request do not even need a callback, so just overwrite it
        newEntry.dataFormat = option.dataFormat;
        if (key) {
            [_pendingLock lock];
            [_pendingEntries setObject:newEntry forKey:key];
            [_pendingLock unlock];
        }
    }
    
    downEntry = nil;

    // check if complete
    [_cacheLock lock];
    SqlEntry * sqlEntry = [_cacheEntries objectForKey:key];
    [_cacheLock unlock];

    BOOL (^quaryEntryBlock)(SqlEntry *) = ^(SqlEntry *quaryEntry)
    {
        if (quaryEntry)
        {
            BOOL getSuccess = NO;
            if (nil == quaryEntry.fileName || quaryEntry.fileName.length == 0) {
                NSLog(@"wrong file path in _completeEntries, should never happen!!!");
            }
            else
            {
                NSString * fullPath = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], quaryEntry.subPath, quaryEntry.fileName];
                getSuccess = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
                if (getSuccess && eCallbackNewDataIfExist != option.callbackOption)
                {
                    if (sBlock)
                    {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            id data = [DownLoadManager contentsAtPath:fullPath forType:option.dataFormat];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (data) {
                                    sBlock(data);
                                } else {
                                    [self removeAllIndexByKey:key];
                                    if (fBlock) {
                                        fBlock([NSError ErrorWithCode:RetCodeFail description:@"file broken"]);
                                    }
                                }
                            });
                        });
                    } else if (fBlock) {
                        // no success block just failure block, return the file path with error code success
                        fBlock([NSError ErrorWithCode:RetCodeNotModified description:fullPath]);
                    }
                }
            }
            
            if (!getSuccess) {
                [self removeAllIndexByKey:key];
            } else if (eCallbackOldDataIfExist == option.callbackOption || eCallbackOldDataNoFetchNew == option.callbackOption) {
                return NO;
            }
        }
        
        if (isPendding) {
            return NO;
        }
        
        if (eCallbackOldDataNoFetchNew == option.callbackOption) {
            if (fBlock) {
                // no cache data, just return fail
                fBlock([NSError ErrorWithCode:RetCodeNoCacheData description:@"no cache data"]);
            }
            return NO;
        }
        
        return YES;
    };
    
    if (nil == sqlEntry)
    {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            SqlEntry * entry = [self dbDataForUrl:key dbInst:db];
            if (entry) {
                [_cacheLock lock];
                if (_cacheEntries.count > _memCacheThreshold) {
                    [_cacheEntries removeAllObjects];
                }
                [_cacheEntries setObject:entry forKey:key];
                [_cacheLock unlock];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL shouldRequest = quaryEntryBlock(entry);
                if (shouldRequest) {
                    [self asyncRealDownload:entry forKey:key group:group successBlock:sBlock failureBlock:fBlock option:option preporcessBlock:pBlock];
                }
            });
        }];
        

    }
    else
    {
        BOOL shouldRequest = quaryEntryBlock(sqlEntry);
        if (shouldRequest) {
            [self asyncRealDownload:sqlEntry forKey:key group:group successBlock:sBlock failureBlock:fBlock option:option preporcessBlock:pBlock];
        }

    }

    sqlEntry = nil;
}

- (void) asyncRealDownload:(SqlEntry*)sqlEntry forKey:(NSString*)key group:(NSString*)group successBlock:(successDlBlock)sBlock failureBlock:(failureDlBlock)fBlock option:(DownloadOption*)option preporcessBlock:(preprocessBlock)pBlock
{
    if (nil == key) {
        return;
    }
    // create new request
    if (nil == group || group.length == 0) {
        group = DOWNLOAD_DEFAULT_GROUP;
    }
    
    if ([self createDirctory:[self directoryByGroup:group]])
    {
        DownloadDataEntry * downEntry = nil;
        [_pendingLock lock];
        downEntry = [_pendingEntries objectForKey:key];
        [_pendingLock unlock];
        
        downEntry.timestamp = [NSDate date];
        if (nil == downEntry) {
            // should never happen
            downEntry = [[DownloadDataEntry alloc] init];
            downEntry.subPath = group;
            downEntry.fileName = [self nonreqeatFilename:downEntry.timestamp];
        }
        
        downEntry.callbackOption = option.callbackOption;
        downEntry.dataFormat = option.dataFormat;
        [downEntry addSuccessBlock:sBlock failureBlock:fBlock];
        
        ASIHTTPRequest * request = nil;
        if (option.isPost) {
            request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:key]];
        } else {
            request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:key]];
        }
        request.shouldAttemptPersistentConnection = NO;
        request.delegate = self;
        request.downloadProgressDelegate = option.processDelegate;
        if (sqlEntry) {
            // has old data, fetch new to overwrite it
            downEntry.subPath = sqlEntry.subPath;
            downEntry.fileName = sqlEntry.fileName;
            if (sqlEntry.lastModifyGMT) {
                [request addRequestHeader:@"If-Modified-Since" value:sqlEntry.lastModifyGMT];
            }
        }
        request.showAccurateProgress = YES;
        request.downloadDestinationPath = [NSString stringWithFormat:@"%@/%@/%@.tmp", [self downloadRootDirectory], downEntry.subPath, downEntry.fileName];
        if (pBlock) {
            pBlock(request);
        }
        [self appendKey:key toRequest:request];
        downEntry.request = request;
        
        [[ASIDataProvider sharedASIDataProvider] addASIRequest:downEntry.request withGroup:DOWNLOAD_BG_GROUP];
    } else {
        NSLog(@"error create file path of group %@", group);
    }
}

- (void) removeAllIndexByKey:(NSString*)url
{
    if (nil == url) {
        return;
    }
    [_cacheLock lock];
    [_completeEntries removeObjectForKey:url];
    [_cacheEntries removeObjectForKey:url];
    [_cacheLock unlock];
    
    [self dbDataRemoveForUrl:url];
}

- (void) cancelByUrl:(NSString*)url
{
    [self cancelByUrl:url keyMaker:nil];
}

- (void) cancelByUrl:(NSString*)url keyMaker:(keyMakersBlock)kBlock
{
    if (nil == url || url.length == 0) {
        return;
    }
    url = [DownLoadManager trimString:url];
    
    NSString * key = url;
    if (kBlock) key = kBlock(url);
    else if (_defaultKeyMaker) key = _defaultKeyMaker(url);
    if (nil == key || key.length == 0) key = url;
    if (key == nil) {
        return;
    }
    DownloadDataEntry * downEntry = nil;
    [_pendingLock lock];
    downEntry = [_pendingEntries objectForKey:key];
    if (downEntry) {
        [_pendingEntries removeObjectForKey:key];
    }
    [_pendingLock unlock];
    if (downEntry) {
        [downEntry.request clearDelegatesAndCancel];
    }
}

- (void) removeByUrl:(NSString*)url
{
    [self removeByUrl:url keyMaker:nil];
}

- (void) removeByUrl:(NSString*)url keyMaker:(keyMakersBlock)kBlock
{
    if (nil == url || url.length == 0) {
        return;
    }
    url = [DownLoadManager trimString:url];
    
    NSString * key = url;
    if (kBlock) key = kBlock(url);
    else if (_defaultKeyMaker) key = _defaultKeyMaker(url);
    if (nil == key || key.length == 0) key = url;
    if (key == nil) {
        return;
    }
    
    [self cancelByUrl:url keyMaker:kBlock];
    
    [_cacheLock lock];
    SqlEntry * sqlEntry = [_cacheEntries objectForKey:key];
    if (sqlEntry) {
        [_cacheEntries removeObjectForKey:key];
        [_completeEntries removeObjectForKey:key];
    }
    [_cacheLock unlock];
    
    void (^rmEntryBlock)(SqlEntry *) = ^(SqlEntry *entry) {
        if (entry) {
            [self dbDataRemoveForUrl:key];
            
            if (entry.fileName.length > 0) {
                NSString * fullPath = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], sqlEntry.subPath, sqlEntry.fileName];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                });
            }
        }
    };
    
    if (nil == sqlEntry) {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            rmEntryBlock([self dbDataForUrl:key dbInst:db]);
        }];
    } else {
        rmEntryBlock(sqlEntry);
    }
}

- (void) cancelByGroup:(NSString*)group
{
    if (nil == group || group.length == 0) {
        return;
    }
    
    NSMutableArray * cancelKeys = [[NSMutableArray alloc] initWithCapacity:10];
    NSMutableArray * cancelEntrys = [[NSMutableArray alloc] initWithCapacity:10];
    
    [_pendingLock lock];
    
    NSArray * keyArr = [_pendingEntries allKeys];
    for (NSString * oneKey in keyArr) {
        DownloadDataEntry * oneEntry = [_pendingEntries objectForKey:oneKey];
        if ([group isEqualToString:oneEntry.subPath]) {
            [cancelKeys addObject:oneKey];
            [cancelEntrys addObject:oneEntry];
        }
    }
    [_pendingEntries removeObjectsForKeys:cancelKeys];
    
    [_pendingLock unlock];
    
    for (DownloadDataEntry * entry in cancelEntrys) {
        [entry.request clearDelegatesAndCancel];
    }
}


#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    HttpStatus stat = [request responseStatusCode];
    
    BOOL httpSuccess = (HttpStatusOK == stat) || (HttpStatusNotModified == stat);
    
//    NSString *expires = [request.responseHeaders valueForKey:@"Expires"];
//    if (expires && expires.length > 0){
//        NSDate *date = [NSDate dateFromHttpDateString:expires];
//        if (date && [date timeIntervalSinceNow] < 0){
//            httpSuccess = NO;
//        }
//    }
    
    if (!httpSuccess) {
        [self requestFailed:request];
        return;
    }
    
    BOOL noModify = (HttpStatusNotModified == stat);
    
    NSString * url = [[request originalURL] absoluteString];
    NSString * key = [request.userInfo objectForKey:DOWNLOAD_REAL_KEY];
    if (nil == key || key.length == 0) key = url;
    
    DownloadDataEntry * entry = nil;
    BOOL hasOldData = NO;
    
    // try get from pendding array
    [_pendingLock lock];
    entry = [_pendingEntries objectForKey:key];
    [_pendingLock unlock];
    
    NSString * toPath = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], entry.subPath, entry.fileName];
    NSString * fromPath = [toPath stringByAppendingPathExtension:@"tmp"];
    
    if (nil == entry) {
        [[NSFileManager defaultManager] removeItemAtPath:fromPath error:nil];
        return;     // not in pendding request, do not need call back
    }
#ifdef ENABLE_LOG_TIME
    else {
        NSLog(@"%fs cost for url: %@", -[entry.timestamp timeIntervalSinceNow], url);
    }
#endif
    
    if (HttpStatusOK == stat) 
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
        }
        [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
    }
    //NSLog(@"finish(%d) %@, %@", [fromPath isEqualToString:request.downloadDestinationPath], fromPath, request.downloadDestinationPath);

    [_pendingLock lock];
    [_pendingEntries removeObjectForKey:key];
    if (noModify) {
        hasOldData = YES;
        if (eCallbackNewDataIfExist != entry.callbackOption) {
            entry = nil;
        }
    } 
    else 
    {
        SqlEntry * sqlEntry = [[SqlEntry alloc] init];
        sqlEntry.subPath = entry.subPath;
        sqlEntry.fileName = entry.fileName;
        sqlEntry.timestamp = entry.timestamp;
        sqlEntry.url = key;
        
        NSDictionary * header = request.responseHeaders;
        if (header) {
            NSString * lastModify = [header objectForKey:@"Last-Modified"];
            if (lastModify) {
                sqlEntry.lastModifyGMT = lastModify;
            }
        }

        [_cacheLock lock];
        hasOldData = (nil != [_cacheEntries objectForKey:key]);
        if (_cacheEntries.count > _memCacheThreshold) {
            [_cacheEntries removeAllObjects];
        }
        [_cacheEntries setObject:sqlEntry forKey:key];
        [_completeEntries setObject:sqlEntry forKey:key];
        [_cacheLock unlock];
        
        if (!hasOldData) {
            hasOldData = (nil != [self dbDataForUrl:key dbInst:_db]);
        }
    }
    [_pendingLock unlock];
    
    if (![entry isBlocksEmpty]) 
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath]) 
        {
            // data is complete
            if (!hasOldData || (hasOldData && (eCallbackBothOldAndNewData == entry.callbackOption || eCallbackNewDataIfExist == entry.callbackOption)))
            {
                if (![entry isSuccessBlocksEmpty])
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        id data = [DownLoadManager contentsAtPath:toPath forType:entry.dataFormat];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (data) {
                                [entry performSuscessBlocks:data];
                            } else {
                                [self removeAllIndexByKey:key];
                                [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
                                [entry performFailureBlocks:[NSError ErrorWithCode:RetCodeFail description:@"file broken"]];
                            }
                        });
                    });
                } else if (![entry isFailureBlocksEmpty]) {
                    // no success block just failure block, return the file path with error code success
                    if (noModify) {
                        [entry performFailureBlocks:[NSError ErrorWithCode:RetCodeNotModified description:toPath]];
                    } else {
                        [entry performFailureBlocks:[NSError ErrorWithCode:RetCodeOK description:toPath]];
                    }
                }
            }
        } else {
            // file not exist, something wrong
            [self removeAllIndexByKey:key];
        }
    }

    [self dbDataInsertComplete:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString * url = [[request originalURL] absoluteString];
    NSString * key = [request.userInfo objectForKey:DOWNLOAD_REAL_KEY];
    if (nil == key || key.length == 0) key = url;
    
    DownloadDataEntry * entry = nil;
    SqlEntry * sqlEntry = nil;
    
    [_pendingLock lock];
    entry = [_pendingEntries objectForKey:key];
    if (entry) {
        [_cacheLock lock];
        sqlEntry = [_cacheEntries objectForKey:key];
        [_cacheLock unlock];
        if (nil == sqlEntry) {
            sqlEntry = [self dbDataForUrl:key dbInst:_db];
        }
        [_pendingEntries removeObjectForKey:key];
    }
    [_pendingLock unlock];
    
    if (entry) {
        NSString * failLocalPath = [NSString stringWithFormat:@"%@/%@/%@.tmp", [self downloadRootDirectory], entry.subPath, entry.fileName];
        [[NSFileManager defaultManager] removeItemAtPath:failLocalPath error:nil];
        
#ifdef ENABLE_LOG_TIME
        NSLog(@"%fs cost for FAILED url: %@", -[entry.timestamp timeIntervalSinceNow], url);
#endif
    }
    
    if (entry && ![entry isBlocksEmpty]) 
    {
        if (sqlEntry)
        {
            // has old data
            if (eCallbackNewDataIfExist == entry.callbackOption)
            {
                BOOL oldDataComplete = NO;
                if (nil == sqlEntry.fileName || sqlEntry.fileName.length == 0) {
                    NSLog(@"wrong file path in _completeEntries, should never happen!!!");
                }
                else
                {
                    NSString * fullPath = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], sqlEntry.subPath, sqlEntry.fileName];
                    oldDataComplete = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
                    if (oldDataComplete)
                    {
                        if (![entry isSuccessBlocksEmpty])
                        {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                id data = [DownLoadManager contentsAtPath:fullPath forType:entry.dataFormat];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (data) {
                                        [entry performSuscessBlocks:data];
                                    } else {
                                        [self removeAllIndexByKey:key];
                                        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                                        [entry performFailureBlocks:[NSError ErrorWithCode:RetCodeFail description:@"file broken"]];
                                    }
                                });
                            });
                        } else if (![entry isFailureBlocksEmpty]) {
                            // no success block just failure block, return the file path with error code success
                            [entry performFailureBlocks:[NSError ErrorWithCode:RetCodeNotModified description:fullPath]];
                        }
                    }
                }
                
                if (!oldDataComplete) {
                    [self removeAllIndexByKey:key];
                }
            }
        } else {
            NSError *error = [request error];
            if (!error){
                int code = request.responseStatusCode;
                NSString *msg = request.responseStatusMessage;
                
                if (code == HttpStatusOK || code == HttpStatusNotModified){
                    code = HttpStatusNotFound;
                    msg  = @"data expired";
                }
                error = [NSError ErrorWithCode:code description:msg];
            }
            [entry performFailureBlocks:error];
        }
    }
}

- (NSString *)downloadRootDirectory
{
    if (nil == _rootDirectory) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *baseDir = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        _rootDirectory = [[baseDir stringByAppendingPathComponent:@"Downloads"] copy];
    }
    return _rootDirectory;
}

- (void) flush {
    [self dbDataInsertComplete:YES];
}

- (void) cleanAllTemp
{    
    [self cleanAllForGroup:DOWNLOAD_TEMP_GROUP];
}

- (void) cleanAllForGroup:(NSString*)group
{
    [_cacheLock lock];
    [_cacheEntries removeAllObjects];
    [_cacheLock unlock];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd = [NSString stringWithFormat:@"delete from dlinfo where subpath='%@'", group];
        [db executeUpdate:cmd];
        
        NSString * tmpPath = [[self downloadRootDirectory] stringByAppendingPathComponent:group];
        NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:tmpPath];
        NSString * delFile = nil;
        while ((delFile = [dirEnum nextObject]) != nil) {
            [[NSFileManager defaultManager] removeItemAtPath:[tmpPath stringByAppendingPathComponent:delFile] error:nil];
        }
    }];
}

- (void) cleanAllGroup
{
    [_cacheLock lock];
    [_cacheEntries removeAllObjects];
    [_cacheLock unlock];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd = [NSString stringWithFormat:@"delete from dlinfo where subpath!='%@'", DOWNLOAD_PERMANENT_GROUP];
        [db executeUpdate:cmd];
        
        NSString * tmpPath = [self downloadRootDirectory];
        NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:tmpPath];
        NSString * delFile = nil;
        while ((delFile = [dirEnum nextObject]) != nil) {
            NSArray * components = delFile.pathComponents;
            if (components.count > 1 && ![[components objectAtIndex:0] isEqualToString:DOWNLOAD_PERMANENT_GROUP]) {
                [[NSFileManager defaultManager] removeItemAtPath:[tmpPath stringByAppendingPathComponent:delFile] error:nil];
            }
        }
    }];
}

- (void) cleanOutOfDate:(NSTimeInterval)maxAge forGroup:(NSString*)group
{
    if (maxAge <= 0) {
        return;
    }

    
    
    [_cacheLock lock];
    [_cacheEntries removeAllObjects];
    [_cacheLock unlock];
    
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray * removeArr = [[NSMutableArray alloc] initWithCapacity:32];
        NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:(-1.0 * maxAge)];
        
        FMResultSet *rs = nil;
        if (group) {
            rs = [db executeQuery:@"select * from dlinfo where timestamp<? and subpath=?", maxDate, group];
        } else {
            rs = [db executeQuery:@"select * from dlinfo where timestamp<? and subpath!=?", maxDate, DOWNLOAD_PERMANENT_GROUP];
        }
        while ([rs next]) {
            SqlEntry * entry = [[SqlEntry alloc] initWithFMResultSet:rs];
            [removeArr addObject:entry];
        }
        [rs close];
        
        if (group) {
            [db executeUpdate:@"DELETE FROM dlinfo WHERE timestamp<? and subpath=?", maxDate, group];
        } else {
            [db executeUpdate:@"DELETE FROM dlinfo WHERE timestamp<? and subpath!=?", maxDate, DOWNLOAD_PERMANENT_GROUP];
        }
        
        for (SqlEntry * entry in removeArr) {
            NSString * fullPath = [NSString stringWithFormat:@"%@/%@/%@", [self downloadRootDirectory], entry.subPath, entry.fileName];
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        }
    }];
    
}

- (void) cleanWildFile
{
    NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self downloadRootDirectory]];

    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        NSMutableArray * pathArr = [[NSMutableArray alloc] initWithCapacity:10];
        NSString * path = nil;
        while ((path = [dirEnum nextObject]) != nil) {
            if ([[path pathExtension] isEqualToString:DOWNLOAD_FILE_EXTENSION]) {
                [pathArr addObject:path];
            }
        }
        
        // check wild file
        for (NSString * wildPath in pathArr)
        {
            NSString * wildFile = [wildPath lastPathComponent];
            if (wildFile)
            {
                BOOL isWild = YES;
                [_cacheLock lock];
                NSArray * arr = [_cacheEntries allValues];
                for (SqlEntry * entry in arr) {
                    if ([wildFile isEqualToString:entry.fileName]) {
                        isWild = NO;
                        break;
                    }
                }
                [_cacheLock unlock];
                
                if (isWild) {
                    isWild = (nil == [self dbDataForFileName:wildFile dbInst:db]);
                }
                
                if (isWild) {
                    NSString * fullPath = [NSString stringWithFormat:@"%@/%@", [self downloadRootDirectory], wildPath];
                    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                }
            }
        }
    }];
}

- (void) cleanRestrictToCount:(NSUInteger)count thresholdCnt:(NSUInteger)threshold forGroup:(NSString*)group
{
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSUInteger tolCnt = [self totalCountForGroup:group dbInst:db];
        if (tolCnt > count + threshold)
        {
            NSUInteger delCnt = tolCnt - count;
            
            NSMutableArray * delUrlArr = [[NSMutableArray alloc] initWithCapacity:delCnt];
            NSMutableArray * delIdArr = [[NSMutableArray alloc] initWithCapacity:delCnt];
            
            // get del arr
            NSString *cmd = nil;
            if (group) {
                cmd = [NSString stringWithFormat:@"select * from dlinfo where subpath=%@ order by timestamp asc limit %d, %lu", group, 0, (unsigned long)delCnt];
            } else {
                cmd = [NSString stringWithFormat:@"select * from dlinfo where subpath!=%@ order by timestamp asc limit %d, %lu", DOWNLOAD_PERMANENT_GROUP, 0, (unsigned long)delCnt];
            }
            FMResultSet *rs = [db executeQuery:cmd];
            while ([rs next]) {
                [delIdArr addObject:[rs objectForColumnName:@"id"]];
                NSString * subNamePath = [NSString stringWithFormat:@"/%@/%@", [rs objectForColumnName:@"subpath"], [rs objectForColumnName:@"filename"]];
                [delUrlArr addObject:subNamePath];
            }
            [rs close];
            
            //remove from db
            NSString * combinedStuff = [delIdArr componentsJoinedByString:@","];
            NSString *cmdDel = [NSString stringWithFormat:@"delete from dlinfo where id in (%@)", combinedStuff];
            [db executeUpdate:cmdDel];
            
            NSFileManager * manager = [NSFileManager defaultManager];
            for (NSString * subNamePath in delUrlArr) {
                NSString * fullPath = [[self downloadRootDirectory] stringByAppendingString:subNamePath];
                [manager removeItemAtPath:fullPath error:nil];
            }
        }
    }];
}

- (void) cleanRestrictToCount:(NSUInteger)count thresholdCnt:(NSUInteger)threshold forGroups:(NSArray*)groups
{
    if (nil == groups) {
        return [self cleanRestrictToCount:count thresholdCnt:threshold forGroup:nil];
    }
    
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSUInteger tolCnt = [self totalCountForGroups:groups dbInst:db];
        if (tolCnt > count + threshold)
        {
            NSString * combinedGroups = [groups componentsJoinedByString:@"\",\""];
            
            NSUInteger delCnt = tolCnt - count;
            
            NSMutableArray * delUrlArr = [[NSMutableArray alloc] initWithCapacity:delCnt];
            NSMutableArray * delIdArr = [[NSMutableArray alloc] initWithCapacity:delCnt];
            
            // get del arr
            NSString * cmd = [NSString stringWithFormat:@"select * from dlinfo where subpath in (\"%@\") order by timestamp asc limit %d, %lu", combinedGroups, 0, (unsigned long)delCnt];
            FMResultSet *rs = [db executeQuery:cmd];
            while ([rs next]) {
                [delIdArr addObject:[rs objectForColumnName:@"id"]];
                NSString * subNamePath = [NSString stringWithFormat:@"/%@/%@", [rs objectForColumnName:@"subpath"], [rs objectForColumnName:@"filename"]];
                [delUrlArr addObject:subNamePath];
            }
            [rs close];
            
            //remove from db
            NSString * combinedStuff = [delIdArr componentsJoinedByString:@","];
            NSString *cmdDel = [NSString stringWithFormat:@"delete from dlinfo where id in (%@)", combinedStuff];
            [db executeUpdate:cmdDel];
            
            NSFileManager * manager = [NSFileManager defaultManager];
            for (NSString * subNamePath in delUrlArr) {
                NSString * fullPath = [[self downloadRootDirectory] stringByAppendingString:subNamePath];
                [manager removeItemAtPath:fullPath error:nil];
            }
        }
    }];
}

- (NSUInteger) totalCountForGroup:(NSString*)group dbInst:(FMDatabase*)db
{
    NSUInteger count = 0;
    [_cacheLock lock];
    if (group) {
        NSArray * arr = [_completeEntries allValues];
        for (SqlEntry * entry in arr) {
            if ([group isEqualToString:entry.subPath]) {
                count++;
            }
        }
    } else {
        count += _completeEntries.count;
    }
    [_cacheLock unlock];
    
    FMResultSet *rs = nil;
    if (group) {
        rs = [db executeQuery:@"select count(*) from dlinfo where subpath=?", group];
    } else {
        rs = [db executeQuery:@"select count(*) from dlinfo"];
    }
    while ([rs next]) {
        count += [rs intForColumnIndex:0];
    }
    [rs close];
    
    return count;
}

- (NSUInteger) totalCountForGroups:(NSArray*)groups dbInst:(FMDatabase*)db
{
    if (nil == groups) {
        return [self totalCountForGroup:nil dbInst:db];
    }
    NSSet * groupSet = [NSSet setWithArray:groups];
    NSUInteger count = 0;
    [_cacheLock lock];
    NSArray * arr = [_completeEntries allValues];
    for (SqlEntry * entry in arr) {
        if ([groupSet containsObject:entry.subPath]) {
            count++;
        }
    }
    [_cacheLock unlock];
    
    NSString * combinedStuff = [groups componentsJoinedByString:@"\",\""];
    NSString *cmd = [NSString stringWithFormat:@"select count(*) from dlinfo where subpath in (\"%@\")", combinedStuff];
    
    FMResultSet *rs = nil;
    rs = [db executeQuery:cmd];
    while ([rs next]) {
        count += [rs intForColumnIndex:0];
    }
    [rs close];
    
    return count;
}

- (void) setBackgroundDownLoadProgressDelegate:(id)delegate
{
    [[ASIDataProvider sharedASIDataProvider] setShowDetailProgress:YES forGroup:DOWNLOAD_BG_GROUP groupProgressDelegate:delegate];
}


#pragma mark - private

- (NSString *)directoryByGroup:(NSString*)group {

    return [NSString stringWithFormat:@"%@/%@", [self downloadRootDirectory], group];
}

- (BOOL) createDirctory:(NSString*)dirctory
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirctory])
	{
		NSError *err = nil;
		if (![[NSFileManager defaultManager] createDirectoryAtPath:dirctory
		                               withIntermediateDirectories:YES attributes:nil error:&err])
		{
			NSLog(@"DownloadManager: Error creating logsDirectory: %@", err);
            return NO;
		}
	}
    return YES;
}

- (NSString*) nonreqeatFilename:(NSDate*)date
{
    static int nameTail = 1;
    
    return [NSString stringWithFormat:@"%@-%d.%@", [_filenameFormatter stringFromDate:date], nameTail++, DOWNLOAD_FILE_EXTENSION];
}


#pragma mark - db

- (void)validateDBDirectory
{
	// Validate log directory exists or create the directory.
	
    NSString * dbDirectory = [self downloadRootDirectory];
	BOOL isDirectory;
	if ([[NSFileManager defaultManager] fileExistsAtPath:dbDirectory isDirectory:&isDirectory]) {
		if (!isDirectory) {
			NSLog(@"%@: download db Directory(%@) is a file!", [self class], dbDirectory);
		}
	} else {
		NSError *error = nil;
		BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dbDirectory
		                                        withIntermediateDirectories:YES
		                                                         attributes:nil
		                                                              error:&error];
		if (!result) {
			NSLog(@"%@: Unable to create download db Directory(%@) due to error: %@", [self class], dbDirectory, error);
		}
	}
}

- (void)openDatabase
{
	if (nil == _db)
	{
        NSString * dbDirectory = [self downloadRootDirectory];
        NSString *path = [dbDirectory stringByAppendingPathComponent:@"dldb.sqlite"];
        
        _db = [[FMDatabase alloc] initWithPath:path];

        if (![_db open]) {
            NSLog(@"%@: Failed opening database!", [self class]);
            _db = nil;
            return;
        }
        
        [self checkDatabaseValidation:_db];
        
        NSString *cmd1 = @"CREATE TABLE IF NOT EXISTS dlinfo (id integer primary key autoincrement, "
                                                                "url text, "
                                                                "subpath text, "
                                                                "filename text, "  
                                                                "timestamp double, "
                                                                "lastgmt text,"
                                                                "UNIQUE (url)"
                                                                ")";
        
        [_db executeUpdate:cmd1];
        if ([_db hadError]) {
            NSLog(@"%@: Error creating table: code(%d): %@", [self class], [_db lastErrorCode], [_db lastErrorMessage]);
            [_db close];
            _db = nil;
            return;
        }
        
        NSString *cmd2 = @"CREATE INDEX IF NOT EXISTS timestamp ON dlinfo (timestamp)";
        
        [_db executeUpdate:cmd2];
        if ([_db hadError]) {
            NSLog(@"%@: Error creating index: code(%d): %@", [self class], [_db lastErrorCode], [_db lastErrorMessage]);
            [_db close];
            _db = nil;
            return;
        }
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path flags:SQLITE_OPEN_READWRITE];
	}
}

- (void)checkDatabaseValidation:(FMDatabase *)db
{
    if (db)
    {
        NSArray * columns = [NSArray arrayWithObjects:@"id", @"url", @"subpath", @"filename", @"timestamp", @"lastgmt", nil];
        
        BOOL shouldDrop = NO;
        NSUInteger idx = 0;
        FMResultSet *rs = [db executeQuery:@"PRAGMA table_info(dlinfo)"];
        while ([rs next]) {
            if (!shouldDrop && idx < columns.count) {
                NSString * name = [rs objectForColumnIndex:1];
                if (![name isEqualToString:[columns objectAtIndex:idx++]]) {
                    shouldDrop = YES;
                }
            }
        }
        [rs close];
        
        if (shouldDrop) 
        {
            NSLog(@"############# download manager database error, drop the whole table #############");
            [db executeUpdate:@"DROP TABLE imginfo"];
        }
    }
}

- (SqlEntry*)dbDataForUrl:(NSString*)url dbInst:(FMDatabase*)db;
{
    SqlEntry * entry = nil;
    
    NSString * cmd = [NSString stringWithFormat:@"select * from dlinfo where url='%@'", url];
    FMResultSet *rs = [db executeQuery:cmd];
    while ([rs next]) {
        if (nil == entry) {
            entry = [[SqlEntry alloc] initWithFMResultSet:rs];
            break;
        }
    }
    [rs close];
    
    // update time stamp
    NSString * updateCmd = [NSString stringWithFormat:@"update dlinfo set timestamp=? where url='%@'", url];
    [db executeUpdate:updateCmd, [NSDate date]];
    
    return entry;
}

- (void)dbDataInsertComplete:(BOOL)force
{
    NSUInteger cnt = _completeEntries.count;
    if (cnt > SAVE_THRESHOLD || (force && cnt > 0)) 
    {
        [_dbQueue inDatabase:^(FMDatabase *db) {

            NSString *cmd = @"REPLACE INTO dlinfo (url, subpath, filename, timestamp, lastgmt) "
            "VALUES (?, ?, ?, ?, ?)";
            
            [_cacheLock lock];
            NSArray * entryArr = [_completeEntries allValues];
            [_completeEntries removeAllObjects];
            [_cacheLock unlock];
            
            for (SqlEntry * entry in entryArr)
            {
                [db executeUpdate:cmd, entry.url, entry.subPath, entry.fileName, entry.timestamp, entry.lastModifyGMT];
            }
        }];
    }
}

- (void)dbDataRemoveForUrl:(NSString*)url
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSString *cmd = [NSString stringWithFormat:@"delete from dlinfo where url='%@'", url];
        [db executeUpdate:cmd];
    }];
}

- (SqlEntry*)dbDataForFileName:(NSString*)name dbInst:(FMDatabase*)db
{
    SqlEntry * entry = nil;
    
    NSString * cmd = [NSString stringWithFormat:@"select * from dlinfo where filename='%@'", name];
    FMResultSet *rs = [db executeQuery:cmd];
    while ([rs next]) {
        if (entry) {
            entry = [[SqlEntry alloc] initWithFMResultSet:rs];
        }
    }
    [rs close];
    
    return entry;
}


// helper function

+ (BOOL) isRemoteUrl:(NSString*)url
{
    return [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"];
}

+ (NSDictionary*) fileStatForPath:(NSString*)loacalPath
{
    if (loacalPath)
    {
        NSDate * modDate = nil;
        
		const char *path = [loacalPath UTF8String];
		
		struct attrlist attrList;
		memset(&attrList, 0, sizeof(attrList));
		attrList.bitmapcount = ATTR_BIT_MAP_COUNT;
		attrList.commonattr = ATTR_CMN_MODTIME;
		
		struct {
			u_int32_t attrBufferSizeInBytes;
			struct timespec crtime;
		} attrBuffer;
		
		int result = getattrlist(path, &attrList, &attrBuffer, sizeof(attrBuffer), 0);
		if (result == 0) {
			double seconds = (double)(attrBuffer.crtime.tv_sec);
			double nanos   = (double)(attrBuffer.crtime.tv_nsec);
			NSTimeInterval ti = seconds + (nanos / 1000000000.0);
			modDate = [NSDate dateWithTimeIntervalSince1970:ti];
		} else {
			NSLog(@"DownloadManager: urlStat(%@): getattrlist result = %i", loacalPath, result);
		}
        
        return [NSDictionary dictionaryWithObjectsAndKeys:modDate, @"modifyDate", nil];
    }
    return nil;
}

@end


