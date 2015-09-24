/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：MessageCenterParser.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：haoquanbai
 * 完成日期：13-3-12
 */

#import "MessageCenterParser.h"
#import "MessageItem.h"
#import "MTA.h"

@interface UserMessageCache ()
@property (nonatomic, strong) NSMutableDictionary *msgCacheDic;
@property (nonatomic, strong) NSLock *writeCacheLock;
@end

@implementation UserMessageCache

- (id)init
{
    if (self = [super init])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath: FILE_CACHE_PATH(@"plist")])
        {
            [fileManager createDirectoryAtPath: FILE_CACHE_PATH(@"plist") withIntermediateDirectories: YES attributes: nil error: nil];
        }
        
        _msgCacheDic = [[NSMutableDictionary alloc] init];
        NSDictionary *cacheDataDic = [NSDictionary dictionaryWithContentsOfFile:FILE_CACHE_PATH(@"plist/userMessageCache.plist")];
        if (cacheDataDic)
        {
            for (id key in cacheDataDic)
            {
                NSArray *dataItemArr = [cacheDataDic objectForKey:key];
                NSMutableArray *itemArr = [NSMutableArray arrayWithCapacity:[dataItemArr count]];
                for (NSData *dataItem in dataItemArr)
                {
                    MessageItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:dataItem];
                    [itemArr addObject:item];
                }
                
                [_msgCacheDic setObject:itemArr forKey:key];
            }
        }
        
        _writeCacheLock = [[NSLock alloc] init];
    }
    
    return self;
}


+ (UserMessageCache *)sharedUserMessageCache
{
    static UserMessageCache *_sharedInstance = nil;
    @synchronized([self class])
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[[self class] alloc] init];
        }
        
        return _sharedInstance;
    }
    
    return nil;
}

+ (void)updateMessageCacheWithUid:(NSInteger)uid andNewCache:(NSArray *)newCache
{
    [[self sharedUserMessageCache].writeCacheLock lock];
    NSMutableArray *newCacheDataItemArr = [NSMutableArray arrayWithCapacity:[newCache count]];
    for (MessageItem *item in newCache)
    {
        NSData *dataItem = [NSKeyedArchiver archivedDataWithRootObject:item];
        [newCacheDataItemArr addObject:dataItem];
    }
    
    [[self sharedUserMessageCache].msgCacheDic setObject:newCache forKey:[NSString stringWithFormat:@"%ld", (long)uid]];
    NSMutableDictionary *cacheDataDic = [NSMutableDictionary dictionaryWithContentsOfFile:FILE_CACHE_PATH(@"plist/userMessageCache.plist")];
    if (!cacheDataDic)
    {
        cacheDataDic = [NSMutableDictionary dictionary];
    }
    
    [cacheDataDic setObject:newCacheDataItemArr forKey:[NSString stringWithFormat:@"%ld", (long)uid]];
    [cacheDataDic writeToFile:FILE_CACHE_PATH(@"plist/userMessageCache.plist") atomically:YES];

    [[self sharedUserMessageCache].writeCacheLock unlock];
}

+ (NSArray *)getMessageCacheWithUid:(NSInteger)uid
{
    return [[self sharedUserMessageCache].msgCacheDic objectForKey:[NSString stringWithFormat:@"%ld", (long)uid]];
}

@end

@implementation MessageCenterParser

- (id)initWithDelegate:(id<MessageCenterParserDelegate>)delegate
{
    if (self = [self init])
    {
        _needRawData = YES;
        _delegate = delegate;
    }
    
    return self;
}

- (void)loadMessageWithParams:(NSDictionary *)params andReqType:(MsgReqType)type
{
    [_reqPostDict removeAllObjects];
    [_reqPostDict addEntriesFromDictionary:params];
    NSString * url = URL_GET_MESSAGES;
    
    [self nocacheRequestWithURL:url completion:^(NSDictionary *dict){
        if ([self.delegate respondsToSelector:@selector(messageCenterDidGetSuccessWithData:andType:)])
        {
            [self.delegate messageCenterDidGetSuccessWithData:dict andType:type];
        }
    } fail:^(NSError *error){
        if ([self.delegate respondsToSelector:@selector(messageCenterDidGetFailedWithError:andType:)])
        {
            [self.delegate messageCenterDidGetFailedWithError:error andType:type];
        }
    } withName:@"URL_GET_MESSAGES"];
}

- (void)setMessageStatusWithParams:(NSDictionary *)params
{
    [_reqPostDict removeAllObjects];
    [_reqPostDict addEntriesFromDictionary:params];
    NSString * url = URL_SET_MESSAGE_STATUS;
    
        // set message status and nothing to do with the result
    [self nocacheRequestWithURL:url completion:nil fail:nil withName:@"URL_SET_MESSAGE_STATUS"];
}

@end
