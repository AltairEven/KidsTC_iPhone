//
//  GInterface.m
//  iPhone51Buy
//
//  Created by xiaomanwang on 13-3-19.
//  Copyright (c) 2013年 icson. All rights reserved.
//

#import "GInterface.h"
#import "UIDevice+IdentifierAddition.h"
#import "HttpActionQueueItem.h"
#import "HttpProcessHelper.h"
#import "GConfig.h"

static GInterface *_staticInterface = nil;
//#define URL_INTERFACE_LIST   @"http://mb.51buy.com/json.php?mod=main&act=getinterface"
#define URL_INTERFACE_LIST     @"http://api.kidstc.com/json.php?mod=main&&act=getinterface&&app=1"
//cfgver 版本号  deviceid设备id
@implementation GInterface

- (id)init
{
	if (self = [super init]) {
		
		connectionsLock = [[NSLock alloc] init];
		queue = [[NSMutableArray alloc] init];
		_interfaceList = nil;
	}
    
	return self;
}

- (void)dealloc
{
	queue = nil;
	connectionsLock = nil;
}

+(GInterface *)sharedGInterface
{
    @synchronized([self class])
    {
        if (!_staticInterface) {
            _staticInterface = [[[self class] alloc] init];
		}
        return _staticInterface;
    }
    return nil;
}

- (NSString*)getPath
{
	NSString *path = FILE_CACHE_PATH(@"interface_list.plist");
	return  path;
}

- (void)removeTheConfigFile
{
	NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [self getPath];
	[manager removeItemAtPath:path error:nil];
}

- (NSDictionary*)loadCache
{
	NSString *path = [self getPath];
	NSFileManager* manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:path])
	{
		NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
		if(dic != nil && [dic isKindOfClass:[NSDictionary class]])
		{
			return dic;
		}
		[self removeTheConfigFile];
		return [self loadBundle];
	}
	return nil;
}

- (NSDictionary*)loadBundle
{
	NSDictionary*dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interface_list" ofType:@"plist"]];
	return dic;
}

- (void)checkFileStatus
{
	NSString *path = [self getPath];
	NSFileManager* manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:path])
	{
		NSString*oldBundleVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kInterfaceBundleVersion];
		if(!oldBundleVersion)//老版本的
		{
			[self removeTheConfigFile];
			self.interfaceList = [self loadBundle];
			[[NSUserDefaults standardUserDefaults] setObject:kidsTCAppSDKVersion forKey:kidsTCAppSDKVersionKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			[self start];
		}
		else
		{
			NSString*localBundleVersion = [GConfig getCurrentAppVersionCode];
			if(![localBundleVersion isEqualToString:oldBundleVersion])//版本更新
			{
				[self removeTheConfigFile];
				self.interfaceList = [self loadBundle];
				[[NSUserDefaults standardUserDefaults] setObject:kidsTCAppSDKVersion forKey:kidsTCAppSDKVersionKey];
				[[NSUserDefaults standardUserDefaults] synchronize];
				[self start];
			}
			else  //同一版本配置升级
			{
				self.interfaceList = [self loadCache];
				[self start];
			}
		}
	}
	else
	{
		self.interfaceList = [self loadBundle];
		[[NSUserDefaults standardUserDefaults] setObject:kidsTCAppSDKVersion forKey:kidsTCAppSDKVersionKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[self start];
	}
}

- (void)clearCache
{
	[self removeTheConfigFile];
	self.interfaceList = [self loadBundle];
	[[GConfig sharedConfig] refresh:self.interfaceList];
	[[NSUserDefaults standardUserDefaults] setObject:kidsTCAppSDKVersion forKey:kidsTCAppSDKVersionKey];
	[[NSUserDefaults standardUserDefaults] setObject:[GConfig getCurrentAppVersionCode] forKey:kInterfaceBundleVersion];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self start];
}

- (NSDictionary*)load
{
	[self checkFileStatus];
   return self.interfaceList;
}

- (void)start
{
#if(kInterfaceDownLoad ==1)
	//LOG_METHOD
	NSString *versionLocal = [[NSUserDefaults standardUserDefaults] objectForKey:kidsTCAppSDKVersionKey];
    if (versionLocal == nil)
	{
		versionLocal = kidsTCAppSDKVersion;
	}
	[self startDownload:versionLocal];
#endif
}

- (void)startDownload:(NSString*)version
{
	NSString *url = URL_INTERFACE_LIST;
	NSString *appVersion = [GConfig getCurrentAppVersionCode];
	url = [NSString stringWithFormat:@"%@&cfgver=%@&appVersion=%@",url,version, appVersion];
	_interfaceRequestProcessHelper = [[HttpProcessHelper alloc] initWithUrl: url];
    
	[_interfaceRequestProcessHelper setUrl:url];
	[self loadInterface:self success:@selector(suc:) failed:@selector(fal:)];
}

- (void)loadInterface:(id)_target success:(SEL)_success failed:(SEL)_failed
{
	[self loadInterface: _target success: _success failed: _failed loading: nil];
}

- (void)loadInterface:(id)_target success:(SEL)_success failed:(SEL)_failed loading:(SEL)_loading
{
	HttpActionQueueItem *actItem = [[HttpActionQueueItem alloc] initWithTarget: _target onSuccess: _success onFail: _failed];
    [connectionsLock lock];
	[queue addObject: actItem];
    [connectionsLock unlock];
	if (status == GInterfaceCompleted)
	{
		[self execSuccessQueue];
		return;
	}
	if ([_target respondsToSelector:_loading])
	{
		SuppressPerformSelectorLeakWarning([_target performSelector:_loading]);
	}
	if (status == GInterfaceLoading)
	{
		return;
	}
	status = GInterfaceLoading;
	[_interfaceRequestProcessHelper startPOSTProcess:self onSuccess:@selector(finished:) onFailed:@selector(failed:) onLoading: nil data: nil];
}

- (void)execSuccessQueue
{
    [connectionsLock lock];
	for (NSInteger i = 0; i < [queue count]; i++)
	{
		HttpActionQueueItem *item = [queue objectAtIndex: i];
		if ([item.target respondsToSelector:item.sucCb])
		{
			SuppressPerformSelectorLeakWarning([item.target performSelector:item.sucCb withObject:self.interfaceList]);
		}
	}
	[queue removeAllObjects];
    [connectionsLock unlock];
}

- (void)execFailedQueue:(NSError *)error
{
    [connectionsLock lock];
	for (NSInteger i = 0; i < [queue count]; i++) {
		HttpActionQueueItem *item = [queue objectAtIndex: i];
		if ([item.target respondsToSelector:item.failCb]) {
			SuppressPerformSelectorLeakWarning([item.target performSelector:item.failCb withObject: error]);
		}
	}
    [queue removeAllObjects];
    [connectionsLock unlock];
}

- (void)failed:(NSError *)error
{
	[self execFailedQueue: error];
	status = GInterfaceInitialize;
}

- (void) pp:(id)obj
{
    if ([obj isKindOfClass:[NSArray class]]) {
        for (id aa in obj) {
            [self pp:aa];
        }
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = (NSDictionary*)obj;
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self pp:key];
            [self pp:obj];
        }];
    } else {
        if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
            return;
        } else {
            NSLog(@"err type: %@, val:%@", [obj class], obj);
        }
    }
}

- (void)finished:(ASIHTTPRequest *)request
{
	if ([request isCancelled])
	{
		return;
	}

	NSDictionary *dic = [request.responseData toJSONObjectFO];
	if (!dic)
	{
		return;
	}
	NSInteger errNo = [[dic objectForKey:@"errno"] integerValue];
	if(errNo == 0)
	{
		self.interfaceList = dic;//[[dic objectForKey:@"data"] retain];
		[self execSuccessQueue];
	}
	else
	{
		[self execFailedQueue:nil];
	}
	status = GInterfaceCompleted;
}

- (void)suc:(id)sender
{
	//LOG_METHOD
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){

		BOOL res = [self.interfaceList writeToFile:[self getPath] atomically:NO];
        if (!res)
		{
            //[self pp:self.interfaceList];
			self.interfaceList = [self loadBundle];
        }
		else
		{
			NSString *newVersion = [self.interfaceList objectForKey:@"version"];
			[[NSUserDefaults standardUserDefaults] setObject:newVersion forKey:kidsTCAppSDKVersionKey];
			[[NSUserDefaults standardUserDefaults] setObject:[GConfig getCurrentAppVersionCode] forKey:kInterfaceBundleVersion];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
			[[GConfig sharedConfig] refresh:self.interfaceList];
		});
	});
}

- (void)fal:(id)sender
{
	//LOG_METHOD
}
@end
