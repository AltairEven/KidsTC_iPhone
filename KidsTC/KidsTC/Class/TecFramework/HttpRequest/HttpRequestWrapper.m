/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpRequestWrapper.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */

#import "HttpRequestWrapper.h"
//#import "GVersionChecker.h"
#import "GInterface.h"
#import "HttpActionQueueItem.h"
#import "HttpProcessHelper.h"


static BOOL isAPP51BUYConnectable = YES;

@interface HttpRequestWrapper ()
@property (nonatomic) NSTimeInterval requestStartTime;
@end

@implementation HttpRequestWrapper
@synthesize delegate;
@synthesize requestStartTime;
@synthesize urlAliasName = _urlAliasName;

- (id)initWithUrlAliasName:(NSString * )urlAliasName
{
    if (self = [super init])
	{
		if(urlAliasName == nil || [urlAliasName length] == 0)
		{
			return nil;
		}
		
        self.requestStartTime = 0;
		_httpProcessHelper = [[HttpProcessHelper alloc] initWithUrl: [[GConfig sharedConfig] getURLStringWithAliasName:urlAliasName]];
        _httpProcessHelper.requestMethod = [[GConfig sharedConfig] getURLSendDataMethodWithAliasName:urlAliasName];
		_rQueue = [[NSMutableArray alloc] init];
		_status = HttpRequestStatusInitialize;
        _connectionsLock = [[NSLock alloc] init];
	}
	
	return self;
}

- (id)initWithUrl:(NSString *)url method:(HttpRequestMethod)method urlAliasName:(NSString *)aliasName
{
	if (self = [super init])
	{
		if(url == nil || [url length] == 0)
		{
			return nil;
		}
		
        self.requestStartTime = 0;
		_httpProcessHelper = [[HttpProcessHelper alloc] initWithUrl: url];
		_rQueue = [[NSMutableArray alloc] init];
		_method = method;
		_status = HttpRequestStatusInitialize;
        _connectionsLock = [[NSLock alloc] init];
        _mtaStat = [[MTAAppMonitorStat alloc] init];
        [_mtaStat setInterface:aliasName];
        self.urlAliasName = aliasName;
        
	}
	
	return self;
}

- (void)dealloc
{
    [self cancel];
}

- (void)removeTarget:(id)target
{
    [_connectionsLock lock];
    for (int i = 0; i < [_rQueue count]; i++)
    {
        HttpActionQueueItem *item = [_rQueue objectAtIndex: i];
        if(item.target == target)
        {
            [_rQueue removeObject:item];
            break;
        }
    }
    
    [_connectionsLock unlock];
}

- (void)setUrl:(NSString *)url
{
	[_httpProcessHelper setUrl:url];
}

- (void)cancel
{
	if (_currentRequest)
    {
		if (!_currentRequest.isCancelled)
        {
			[_currentRequest clearDelegatesAndCancel];
		}
        else
        {
            _currentRequest.delegate = nil;
        }
        
		_currentRequest = nil;
	}
    
    self.requestStartTime = 0;
    if ([_connectionsLock tryLock])
    {
        [_rQueue removeAllObjects];
        [_connectionsLock unlock];
    }
}

+ (NSDictionary *)handleResult:(ASIHTTPRequest *)request error:(NSError **)err pretreat:(void(^)(NSString **resultStr))pretreat
{
    NSData * data = request.responseData;
	if (nil == data)
    {
		*err = ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_DATA_INVALID);
		return nil;
	}
    @try
    {
        NSString *strData = GBSTR_FROM_DATA(data);
        if (pretreat)
        {
            if (nil == strData) {
                *err = ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_DATA_INVALID);
                return nil;
            }
            NSString *tresult = [NSMutableString stringWithString:strData];
            pretreat(&tresult);
            data = [tresult dataUsingEncoding:NSUTF8StringEncoding];
        }
        else
        {
            data = [strData dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSDictionary * dic = [data toJSONObject];
        if (dic == nil || ![dic isKindOfClass:[NSDictionary class]])
        {
            if (err != nil)
            {
                *err = ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_JSON_INVALID);
            }
            
            return dic;
        }
        else
        {
            NSString * goodNo = [dic objectForKey: @"errno"];
            if (nil == goodNo) {
                goodNo = [dic objectForKey: @"errCode"];
            }
            NSInteger errNo = [goodNo integerValue];
            if (errNo != 0)
            {
                if (err != nil)
                {
                    if (![dic objectForKey: @"data"])
                    {
                        *err = ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, (100000 + errNo));
                    }
                    else
                    {
                        *err = ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(ERR_COMMON, (100000 + errNo), ([NSDictionary dictionaryWithObjectsAndKeys: [dic objectForKey:@"data"], @"returnData", nil]));
                    }
                }
                
                return nil;
            }
            
            if (err != nil)
            {
                *err = nil;
            }
            
            return dic;
        }
    }
    @catch(...)
    {
        if (err != nil)
        {
            *err = ERROR_WITH_TYPE_AND_CODE(ERR_COMMON, ERRCODE_JSON_INVALID);
        }
        return  nil;
    }
}

+ (NSDictionary *)handleResult:(ASIHTTPRequest *)request error:(NSError **)err
{
    return [HttpRequestWrapper handleResult: request error: err pretreat: nil];
}

- (void)execProductSucQueue:(NSDictionary *)result request:(ASIHTTPRequest *)request
{
    [_connectionsLock lock];
    
    self.durationTime = [NSDate timeIntervalSinceReferenceDate] - self.requestStartTime;
    _mtaStat.consumedMilliseconds = (uint64_t)(self.durationTime *1000);
    _mtaStat.responsePackageSize = (uint32_t)[request.responseData length];
    
    
    [_mtaStat setResultType:MTA_SUCCESS];
    [MTA reportAppMonitorStat:_mtaStat];
    
	while ([_rQueue count] > 0)
    {
		HttpActionQueueItem *item = [_rQueue objectAtIndex: 0];
		if ([item.target respondsToSelector:item.sucCb])
        {
			SuppressPerformSelectorLeakWarning([item.target performSelector:item.sucCb withObject: result withObject: request.userInfo ]);
		}
        
		[_rQueue removeObject: item];
	}
    
    [_connectionsLock unlock];
	_status = HttpRequestStatusCompleted;
}

- (void)execProductFailQueue:(NSError*)err request:(ASIHTTPRequest *)request
{
    [_connectionsLock lock];
    // request return failed, log the request _status
    self.durationTime = [NSDate timeIntervalSinceReferenceDate] - self.requestStartTime;

    _mtaStat.consumedMilliseconds = (uint64_t)(self.durationTime *1000);
    _mtaStat.responsePackageSize = (uint32_t)[request.responseData length];
    _mtaStat.returnCode = (int32_t)err.code;
    
    [_mtaStat setResultType:MTA_FAILURE];
    [MTA reportAppMonitorStat:_mtaStat];
    
    // 重新激活QQ用户登录态
    if ((err.code - 100000) == 500)
    {
        [[UserWrapper shareMasterUser] logout];
    }
    
	while ([_rQueue count] > 0)
    {
		HttpActionQueueItem *item = [_rQueue objectAtIndex: 0];
		if ([item.target respondsToSelector:item.failCb])
        {
			SuppressPerformSelectorLeakWarning([item.target performSelector:item.failCb withObject: err withObject: request.responseData]);
		}
        
		[_rQueue removeObject: item];
	}
    
    [_connectionsLock unlock];
	_status = HttpRequestStatusInitialize;
}

- (void)daoFinished:(ASIHTTPRequest *)request
{
    static int sAllLen = 0;
    sAllLen += request.responseData.length;
    NSLog(@"url(%lu) = %@", (unsigned long)(request.url.absoluteString.length), request.url);
    NSLog(@"response(%d), len(%lu/%d) = %@", request.responseStatusCode, (unsigned long)(request.responseData.length), sAllLen, request.responseString);
    
    
	NSError *err = nil;
	NSDictionary *dic = nil;
    if (delegate)
    {
        dic = [HttpRequestWrapper handleResult: request error: &err pretreat:^(NSString **resultStr)
        {
            if ([delegate respondsToSelector: @selector(preTreatRequest:responseString:)])
            {
                if (resultStr)
                {
                    *resultStr = [delegate preTreatRequest: (HttpRequestWrapper*)self responseString: *resultStr];
                }
            }
        }];
    }
    else
    {
        dic = [HttpRequestWrapper handleResult: request error: &err];
    }

	if (err != nil)
    {
		[self execProductFailQueue: err request: request];
	}
    else
    {
		[self execProductSucQueue: dic request: request];
	}
}

- (void)daoFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request url]);
    self.durationTime = [NSDate timeIntervalSinceReferenceDate] - self.requestStartTime;
    _mtaStat.consumedMilliseconds = (uint64_t)(self.durationTime *1000);
    _mtaStat.returnCode = 0;
    [_mtaStat setResultType:MTA_FAILURE];
    [MTA reportAppMonitorStat:_mtaStat];
	[self execProductFailQueue:request.error request:request];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading encode:(NSStringEncoding)encoding
{
    BOOL b = [GToolUtil filterBlackList:_httpProcessHelper.url];
    if(!b)return nil;
    
    if(!isAPP51BUYConnectable){
        if (target && [target respondsToSelector:failed]) {
            SuppressPerformSelectorLeakWarning([target performSelector:failed withObject: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_COMMON, ERRCODE_DATA_INVALID, @"无法连接服务器，请检查网络连接") withObject:nil ]);
        }
        return nil;
    }
    
    if (_currentRequest) {
        [self cancel];
    }
    
    HttpActionQueueItem *queueItem = [[HttpActionQueueItem alloc] initWithTarget:target onSuccess:success onFail:failed];
    [_rQueue addObject: queueItem];
    
    if (_status == HttpRequestStatusCompleted) {
        [self daoFinished:_currentRequest];
        return _currentRequest;
    }
    
    if ([target respondsToSelector:loading]) {
        SuppressPerformSelectorLeakWarning([target performSelector:loading]);
    }
    
    if (_status == HttpRequestStatusLoading) {
        return _currentRequest;
    }
    
    // record request start time here
    self.requestStartTime = [NSDate timeIntervalSinceReferenceDate];
    _status = HttpRequestStatusLoading;
    if (_method == HttpRequestMethodPOST) {
        return _currentRequest = [_httpProcessHelper startPOSTProcess: self onSuccess: @selector(daoFinished:) onFailed: @selector(daoFailed:) onLoading: nil data: params userInfo:nil autoStart:YES encoding:encoding];
    } else if(_method == HttpRequestMethodGET){
        return _currentRequest = [_httpProcessHelper startGETProcess: self onSuccess: @selector(daoFinished:) onFailed: @selector(daoFailed:) onLoading: nil data: params userInfo:nil autoStart:YES];
    } else {
        return nil;
    }
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed
{
	return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading: nil];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading
{
	return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading:loading userInfo: nil];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading autoStart:(BOOL)autoStart
{
	return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading:loading userInfo: nil cancelPrevious: YES autoStart:autoStart];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo
{
	return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading:loading userInfo:userInfo cancelPrevious: YES];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart
{
    return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading:loading userInfo:userInfo cancelPrevious:YES autoStart: autoStart];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo cancelPrevious:(BOOL)cancelPrevious
{
	return [self startProcess: params target:target onSuccess:success onFailed:failed onLoading:loading userInfo:userInfo cancelPrevious:cancelPrevious autoStart: YES];
}

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo cancelPrevious:(BOOL)cancelPrevious autoStart:(BOOL)autoStart
{
	BOOL b = [GToolUtil filterBlackList:_httpProcessHelper.url];
	if(!b)return nil;
	
	if(!isAPP51BUYConnectable){
		if (target && [target respondsToSelector:failed]) {
			SuppressPerformSelectorLeakWarning([target performSelector:failed withObject: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_COMMON, ERRCODE_DATA_INVALID, @"无法连接服务器，请检查网络连接") withObject:userInfo ]);
		}
		return nil;
	}

	if (cancelPrevious) {
		if (_currentRequest) {
			[self cancel];
		}
	}
        
	HttpActionQueueItem *queueItem = [[HttpActionQueueItem alloc] initWithTarget:target onSuccess:success onFail:failed];
	[_rQueue addObject: queueItem];

	if (!cancelPrevious) {
		if (_status == HttpRequestStatusCompleted) {
			[self daoFinished:_currentRequest];
			return _currentRequest;
		}
	}

	if ([target respondsToSelector:loading]) {
		SuppressPerformSelectorLeakWarning([target performSelector:loading]);
	}

	if (!cancelPrevious) {
		if (_status == HttpRequestStatusLoading) {
			return _currentRequest;
		}
	}
	
    // record request start time here
    self.requestStartTime = [NSDate timeIntervalSinceReferenceDate];
	_status = HttpRequestStatusLoading;
	if (_method == HttpRequestMethodPOST) {
		return _currentRequest = [_httpProcessHelper startPOSTProcess: self onSuccess: @selector(daoFinished:) onFailed: @selector(daoFailed:) onLoading: nil data: params userInfo:userInfo autoStart:autoStart];
	} else if(_method == HttpRequestMethodGET){
		return _currentRequest = [_httpProcessHelper startGETProcess: self onSuccess: @selector(daoFinished:) onFailed: @selector(daoFailed:) onLoading: nil data: params userInfo:userInfo autoStart:autoStart];
	} else {
		return nil;
	}
}

#pragma mark reachability

+ (void)registerForNetworkReachabilityNotifications
{
	[[Reachability sharedReachability] startNotifier];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name: kReachabilityChangedNotification object:nil];
}

+ (void)unsubscribeFromNetworkReachabilityNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name: kReachabilityChangedNotification object:nil];
}

+ (BOOL)isNetworkReachableViaWWAN
{
	return ([[Reachability sharedReachability] currentReachabilityStatus] == ReachableViaWWAN);	
}

+ (void)reachabilityChanged:(NSNotification *)note
{
    BOOL newStatus = [[Reachability sharedReachability] currentReachabilityStatus] != NotReachable;
    if (newStatus != isAPP51BUYConnectable)
    {
        isAPP51BUYConnectable = newStatus;
    }
}

@end
