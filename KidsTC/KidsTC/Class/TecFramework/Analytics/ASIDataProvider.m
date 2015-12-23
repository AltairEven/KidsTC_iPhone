/*
 * Copyright (c) 2011,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：ASIDataProvider.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：qitao
 * 完成日期：2011年11月17日
 */

#import "ASIDataProvider.h"
#import "ASINetworkQueue.h"
//#import "DebugUtil.h"

#define ASI_DEFAULT_QUEUE_MAX_CONCURRENT_CNT        5
#define ASI_DEFAULT_MAX_CONCURRENT_CNT              2

@implementation ASIDataProvider

static ASIDataProvider * _instanceASIDataProvider = nil;

+ (ASIDataProvider*) sharedASIDataProvider
{
	//@synchronized(self)
	{
		if (_instanceASIDataProvider == nil) {
			_instanceASIDataProvider = [[ASIDataProvider alloc] init];
		}
	}
	return _instanceASIDataProvider;
}

- (id) init
{
    self = [super init];
    if (self != nil)
    {
        _queueDict = [[NSMutableDictionary alloc] initWithCapacity:2];

        ASINetworkQueue * queueDefault = [[ASINetworkQueue alloc] init];
        [queueDefault setMaxConcurrentOperationCount:ASI_DEFAULT_QUEUE_MAX_CONCURRENT_CNT];
        
        ASINetworkQueue * queueCancelLast = [[ASINetworkQueue alloc] init];
        [queueCancelLast setMaxConcurrentOperationCount:1];
        
        [_queueDict setObject:queueDefault forKey:ASI_DEFAULT_QUEUE];
        [_queueDict setObject:queueCancelLast forKey:ASI_CANCEL_LAST_QUEUE];
    }
    return self;
}

- (void)dealloc
{
    [_queueDict removeAllObjects];
    
}


- (void) setMaxConcurrentOperationCount:(NSInteger)cnt forGroup:(NSString*)group
{
    NSOperationQueue * queue = [_queueDict objectForKey:group];
    if (nil == queue) {
        queue = [[ASINetworkQueue alloc] init];
        [_queueDict setObject:queue forKey:group];
    }
    [queue setMaxConcurrentOperationCount:cnt];
}

- (void) setShowDetailProgress:(BOOL)ifShow forGroup:(NSString*)group groupProgressDelegate:(id)groupDelegate
{
    ASINetworkQueue * queue = [_queueDict objectForKey:group];
    if (nil == queue) {
        queue = [[ASINetworkQueue alloc] init];
        [_queueDict setObject:queue forKey:group];
    }
    [queue setShowAccurateProgress:ifShow];
    queue.downloadProgressDelegate = groupDelegate;
}

- (void) addASIRequest:(ASIHTTPRequest*)request
{
    [self addASIRequest:request withGroup:ASI_DEFAULT_QUEUE];
}

- (void) addASIRequest:(ASIHTTPRequest*)request withGroup:(NSString*)group
{
    if (group == nil) {
        group = ASI_DEFAULT_QUEUE;
    }
    
    if (request)
    {
#ifndef RELEASE
        if (nil == request.delegate) {
            request.delegate = self;
        } else {
            __weak ASIHTTPRequest * nonRetainReq = request;
            
            [request setCompletionBlock:^{
                [self requestFinished:nonRetainReq];
            }];

            [request setFailedBlock:^{
                [self requestFailed:nonRetainReq];
            }];
        }
#endif
        
        ASINetworkQueue * queue = [_queueDict objectForKey:group];
        if (nil == queue) {
            queue = [[ASINetworkQueue alloc] init];
            [queue setMaxConcurrentOperationCount:ASI_DEFAULT_MAX_CONCURRENT_CNT];
            [_queueDict setObject:queue forKey:group];
        }
        
        // check group
        if ([group isEqualToString:ASI_CANCEL_LAST_QUEUE]) {
            [queue cancelAllOperations];
        }
        
        [queue addOperation:request];
        [queue go];
    }
}

- (void) cancelRequestGroup:(NSString*)group
{
    ASINetworkQueue * queue = [_queueDict objectForKey:group];
    if (queue) {
        [queue cancelAllOperations];
    }
}

- (void) suspendRequestGroup:(NSString*)group
{
    ASINetworkQueue * queue = [_queueDict objectForKey:group];
    if (queue) {
        [queue setSuspended:YES];
    }
}

- (void) resumeRequestGroup:(NSString*)group
{
    ASINetworkQueue * queue = [_queueDict objectForKey:group];
    if (queue) {
        [queue setSuspended:NO];
    }
}

#ifndef RELEASE

#pragma mark - ASIDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
//    NSString * url = [[request url] absoluteString];
//    unsigned long long dataRead = request.totalBytesRead;
//    unsigned long long dataSend = request.totalBytesSent;
    
//    [[DebugUtil sharedInstance] read:dataRead fromUrl:url];
//    [[DebugUtil sharedInstance] write:dataSend toUrl:url];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self requestFinished:request];
}

#endif


@end
