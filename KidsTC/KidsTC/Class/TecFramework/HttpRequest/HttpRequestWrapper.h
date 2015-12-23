/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpRequestWrapper.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */

#import "ASIHTTPRequest.h"
#import "GToolUtil.h"

#import "Constants.h"
#import "MTA.h"


@class HttpProcessHelper;



@class HttpRequestWrapper;
@protocol HttpRequestDelegate <NSObject>
@optional
- (NSString *)preTreatRequest:(HttpRequestWrapper *)request responseString:(NSString *)responseString;
@end

@interface HttpRequestWrapper : NSObject
{	
	HttpProcessHelper *             _httpProcessHelper;
	NSMutableArray *                _rQueue; // 将要执行的事件队列
	ASIHTTPRequest *                _currentRequest;
	HttpRequestMethod               _method; // 1,post; 2,get
	HttpRequestStatus               _status;
    NSLock*                         _connectionsLock;
    NSString *                      _urlAliasName;
    MTAAppMonitorStat *             _mtaStat;
    
}
@property (retain, nonatomic) NSString * urlAliasName;
@property (assign, nonatomic) id<HttpRequestDelegate> delegate;
@property (nonatomic) NSTimeInterval  durationTime;

- (id)initWithUrl:(NSString *)url method:(HttpRequestMethod)method urlAliasName:(NSString *)aliasName;
- (id)initWithUrlAliasName:(NSString * )urlAliasName;
- (void)setUrl:(NSString *)url;

- (void)cancel;

- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading autoStart:(BOOL)autoStart;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading userInfo:(NSDictionary *)userInfo cancelPrevious:(BOOL)cancelPrevious;
- (ASIHTTPRequest *)startProcess:(NSDictionary*)params target:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading encode:(NSStringEncoding)encoding;

+ (void)registerForNetworkReachabilityNotifications;
+ (void)unsubscribeFromNetworkReachabilityNotifications;
+ (BOOL)isNetworkReachableViaWWAN;
+ (void)reachabilityChanged:(NSNotification *)note;


- (void)removeTarget:(id)target;

@end