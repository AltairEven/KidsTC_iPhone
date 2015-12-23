/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpProcessHelper.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */

#import <Foundation/Foundation.h>
#import "Constants.h"

@class ASIHTTPRequest;
@class ASIDownloadCache;


@interface HttpProcessHelper : NSObject
{
    NSString *          _url;
    NSString *          _result;
    HttpRequestMethod   _requestMethod; // 1,post; 2,get
    
}
@property (nonatomic, assign) HttpRequestMethod requestMethod;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *result;

+(void)getIcsonCookie:(ASIHTTPRequest *)request;

- (id)initWithUrl:(NSString*)url;
- (ASIHTTPRequest *)get:(NSDictionary *)data;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed data:(NSDictionary *)data;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo useCache:(id <ASICacheDelegate>)cache;
- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo useCache:(id <ASICacheDelegate>)cache autoStart:(BOOL)autoStart;
- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed data:(NSDictionary *)data;
- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data;
-(ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo;
-(ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart;
- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart encoding:(NSStringEncoding)encoding;
@end
