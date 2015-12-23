/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpProcessHelper.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */

#import "HttpProcessHelper.h"
#import "UIDevice+IdentifierAddition.h"
#import "Constants.h"


static const NSTimeInterval kTimeoutSeconds = 10;  //edit by Altair, 20141205

@implementation HttpProcessHelper
@synthesize url = _url;
@synthesize result = _result;
@synthesize requestMethod = _requestMethod;


- (id)initWithUrl:(NSString*)url
{
	if (self = [super init]) {
		if(url == nil || [url length] == 0)
			return nil;
		self.url = url;
	}
	return self;
}


-(ASIHTTPRequest *)get:(NSDictionary *)data
{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[GToolUtil addQueryStringToUrl:self.url params:data]]];
	
	[request setUseCookiePersistence:NO];//设置cookie不全局共享
	[HttpProcessHelper getIcsonCookie:request];
	
	[request setTimeOutSeconds: kTimeoutSeconds];
	[request startSynchronous];
	return request;
}

-(ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed data:(NSDictionary *)data
{
	return [self startGETProcess:target onSuccess:success onFailed:failed onLoading:nil data:data];
}

-(ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data
{
	return [self startGETProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo: nil];
}

- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo
{
	return [self startGETProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo:userInfo useCache: [ASIHTTPRequest defaultCache]];
}

- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart
{
	return [self startGETProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo:userInfo useCache: [ASIHTTPRequest defaultCache] autoStart:autoStart];
}

- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo useCache:(id <ASICacheDelegate>)cache
{
	return [self startGETProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo:userInfo useCache:cache autoStart: YES];
}

- (ASIHTTPRequest *)startGETProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo useCache:(id <ASICacheDelegate>)cache autoStart:(BOOL)autoStart
{
	if ([target respondsToSelector:loading]) {
		SuppressPerformSelectorLeakWarning([target performSelector:loading]);
	}
    
    // Add device type and version code
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:data];
    [dataDic setObject:@"iPhone" forKey:@"appSource"];
    [dataDic setObject:[GConfig getCurrentAppVersionCode] forKey:@"appVersion"];

    [dataDic setObject:[[UserWrapper shareMasterUser] getExToken] forKey:@"exAppTag"];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[GToolUtil addQueryStringToUrl: self.url params:dataDic]]];
	NSLog(@"get url:%@\n",[request.url absoluteString]);
	NSLog(@"get params:%@\n",dataDic);
	
    [request setUseCookiePersistence:NO];
	[HttpProcessHelper getIcsonCookie:request];
    
	request.didFinishSelector = success;
	request.didFailSelector = failed;
	[request setDelegate:target];
	//[request setDownloadProgressDelegate: self];
	[request setUserInfo:userInfo];
	if (cache) {
		[request setDownloadCache:cache];
	}
    
    
    [request setTimeOutSeconds: kTimeoutSeconds];
    
	if (autoStart) {
        [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];
	}
	return request;
}

- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed data:(NSDictionary *)data
{
	return [self startPOSTProcess:target onSuccess:success onFailed:failed onLoading:nil data:data];
}

- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data
{
	return [self startPOSTProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo: nil];
}

- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo
{
	return [self startPOSTProcess:target onSuccess:success onFailed:failed onLoading:loading data:data userInfo:userInfo autoStart: YES];
}

- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart
{
	if ([target respondsToSelector:loading]) {
		SuppressPerformSelectorLeakWarning([target performSelector:loading]);
	}
	
    // Add device type and version code
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iPhone",@"appSource",[GConfig getCurrentAppVersionCode], @"appVersion", nil];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[GToolUtil addQueryStringToUrl: self.url params:dataDic]]];
	[request setUseCookiePersistence:NO];
	[HttpProcessHelper getIcsonCookie:request];
	
	[request setStringEncoding: CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 )];
	for (id k in data) {
		[request setPostValue: [data objectForKey: k] forKey: k];
	}
	NSLog(@"post url:%@\n",[request.url absoluteString]);
	NSLog(@"post params:%@\n",data);
    [request setPostValue:[[UserWrapper shareMasterUser] getExToken] forKey:@"exAppTag"];

	request.didFinishSelector = success;
	request.didFailSelector = failed;
	[request setDelegate:target];
	//[request setDownloadProgressDelegate: self];
	[request setUserInfo:userInfo];
	[request setTimeOutSeconds: kTimeoutSeconds];
	
	if (autoStart) {
        [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];
	}
	return request;
}



- (ASIHTTPRequest *)startPOSTProcess:(id)target onSuccess:(SEL)success onFailed:(SEL)failed onLoading:(SEL)loading data:(NSDictionary *)data userInfo:(NSDictionary *)userInfo autoStart:(BOOL)autoStart encoding:(NSStringEncoding)encoding
{
    if ([target respondsToSelector:loading]) {
        SuppressPerformSelectorLeakWarning([target performSelector:loading]);
    }
    
    // Add device type and version code
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iPhone",@"appSource",[GConfig getCurrentAppVersionCode], @"appVersion", nil];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[GToolUtil addQueryStringToUrl: self.url params:dataDic]]];
    [request setUseCookiePersistence:NO];
    [HttpProcessHelper getIcsonCookie:request];
    
    [request setStringEncoding:encoding];
    for (id k in data) {
        [request setPostValue: [data objectForKey: k] forKey: k];
    }
    NSLog(@"post url:%@\n",[request.url absoluteString]);
    NSLog(@"post params:%@\n",data);
    [request setPostValue:[[UserWrapper shareMasterUser] getExToken] forKey:@"exAppTag"];
    
    request.didFinishSelector = success;
    request.didFailSelector = failed;
    [request setDelegate:target];
    //[request setDownloadProgressDelegate: self];
    [request setUserInfo:userInfo];
    [request setTimeOutSeconds: kTimeoutSeconds];
    
    if (autoStart) {
        [[ASIDataProvider sharedASIDataProvider] addASIRequest:request];
    }
    return request;
}


+(void)getIcsonCookie:(ASIHTTPRequest *)request{
	
	//NSError *error = NULL;

	NSURL *sUrl =  request.url;
    
    if (sUrl.host.length == 0) {
        return;
    }
	
    /*NSRegularExpression
     正则匹配，从iOS4.0开始支持
     */
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\.]+\\.(51buy|yixun)\\.com" options:NSRegularExpressionCaseInsensitive  error:&error];
//	
//	NSUInteger numberOfMatches = [regex numberOfMatchesInString:[sUrl host] options:0 range:NSMakeRange(0, [[sUrl host] length])];
//
//	if( numberOfMatches < 1){
//		return;
//	}
	
	UIDevice *device= [[UIDevice alloc] init];
    NSString *deviceID = [device uniqueDeviceIdentifier];
	NSMutableArray *cookies = [[NSMutableArray alloc] init];
	KTCUser *user = [KTCUser currentUser];
	if( [user.uid length] > 0 && [user.skey length] > 0){
		
//        if ([[request.url absoluteString] containsString:@"qiang.yixun.com"]) {
//            /////////////////////////////////edit by Altair, 20150129, for qiang test//////////////////////////////////////
//            NSDictionary *uidProperties =  [NSDictionary dictionaryWithObjectsAndKeys: [NSString stringWithFormat:@"%d", 410000102], NSHTTPCookieValue, @"uid",
//                                            NSHTTPCookieName, @"/" , NSHTTPCookiePath, @".51buy.com" , NSHTTPCookieDomain, nil];
//            NSHTTPCookie *uidCookie = [NSHTTPCookie cookieWithProperties:uidProperties];
//            NSDictionary *skeyProperties =  [NSDictionary dictionaryWithObjectsAndKeys: @"iw5AA608C4", NSHTTPCookieValue, @"skey",
//                                             NSHTTPCookieName, @"/" , NSHTTPCookiePath, @".51buy.com" , NSHTTPCookieDomain, nil];
//            NSHTTPCookie *sKeyCookie = [NSHTTPCookie cookieWithProperties:skeyProperties];
//            [cookies addObject:uidCookie];
//            [cookies addObject:sKeyCookie];
//            /////////////////////////////////edit by Altair, 20150129, for qiang test//////////////////////////////////////
//        } else {
//            NSHTTPCookie *uidCookie = [ HttpCookieWrapper init: [NSString stringWithFormat:@"%d", user.uid] forName:GLOBAL_COOKIE_NAME_UID ];
//            NSHTTPCookie *sKeyCookie = [ HttpCookieWrapper init: user.skey forName:GLOBAL_COOKIE_NAME_SKEY ];
//            [cookies addObject:uidCookie];
//            [cookies addObject:sKeyCookie];
//
//        }
        
        NSHTTPCookie *uidCookie = [ HttpCookieWrapper init: [NSString stringWithFormat:@"%ld", (long)(user.uid)] forName:GLOBAL_COOKIE_NAME_UID ];
        NSHTTPCookie *sKeyCookie = [ HttpCookieWrapper init: user.skey forName:GLOBAL_COOKIE_NAME_SKEY ];
        [cookies addObject:uidCookie];
        [cookies addObject:sKeyCookie];
        
//        if (user.loginUserType == LoginQQUser) {
//            NSString * qqlSkey = [user getQQLSkey];
//            if (qqlSkey) {
//                NSHTTPCookie * lsKeyCookie = [ HttpCookieWrapper init: qqlSkey forName:GLOBAL_COOKIE_NAME_LSKEY ];
//                [cookies addObject:lsKeyCookie];
//            }
//        }
        
//		NSHTTPCookie *tokenCookie = [ HttpCookieWrapper init: user.token forName:GLOBAL_COOKIE_NAME_TOKEN ];
		
//        [cookies addObject:tokenCookie];
        
	}
    //[[NSUserDefaults standardUserDefaults] setObject:cpsCookie forKey:kCPSLocalKeyName];
//    NSString *cpsCookieValue = [[NSUserDefaults standardUserDefaults] stringForKey:kCPSCookieLocalKeyName];
//    if (cpsCookieValue != nil) {
//        NSHTTPCookie *cpsCookies = [ HttpCookieWrapper init:cpsCookieValue forName:GLOBAL_COOKIE_NAME_CPSCOOKIES ];
//        [cookies addObject:cpsCookies];
//    }
//    
//    NSString *cpsTkdValue = [[NSUserDefaults standardUserDefaults] stringForKey:kCPSTkdLocalKeyName];
//    if (cpsTkdValue != nil) {
//        NSHTTPCookie *cpsTkd = [ HttpCookieWrapper init:cpsTkdValue forName:GLOBAL_COOKIE_NAME_CPSTKD ];
//        [cookies addObject:cpsTkd];
//    }
    
    NSHTTPCookie *deviceIDCookie = [ HttpCookieWrapper init:deviceID  forName:GLOBAL_COOKIE_NAME_DEVICE_ID ];//根据5月10号的沟通结果，所有的接口都在cookie中上报唯一标示符
	[cookies addObject:deviceIDCookie];
	//get site set
	//get config from SQLite
	//NSHTTPCookie *wsid = [ HttpCookieWrapper init:[NSString stringWithFormat:@"%d", [UserWrapper shareMasterUser].siteID] forName:GLOBAL_COOKIE_NAME_WSID ];//站点id也需要在cookie中上报
//    NSHTTPCookie *wsid = [ HttpCookieWrapper init:[NSString stringWithFormat:@"%d", 1] forName:GLOBAL_COOKIE_NAME_WSID ];//站点id也需要在cookie中上报
//	[cookies addObject:wsid];
    
    // districtid info cookie
//    NSHTTPCookie *distid = [HttpCookieWrapper init:[NSString stringWithFormat:@"%@", user.districtId] forName:GLOBAL_COOKIE_NAME_DISTID];
//    [cookies addObject:distid];
    
	
//	if( [UserWrapper shareMasterUser].subSiteID > 0 ){
//		NSHTTPCookie *siteSc = [ HttpCookieWrapper init:[NSString stringWithFormat:@"%d", [UserWrapper shareMasterUser].subSiteID] forName:GLOBAL_COOKIE_NAME_SITE_SC ];
//		[cookies addObject:siteSc];
    //	}//分站id如果有，也需要上报
    
    //add for qiang, 20150302  --前面的是value，后面的是key
    NSHTTPCookie *appSourceCookie = [ HttpCookieWrapper init: @"iPhone" forName:@"appSource" ];
    
    [cookies addObject:appSourceCookie];
	
    //add by ivy 2015-3-12 应邀加上visitkey
//    NSHTTPCookie *visitKeyCookie = [ HttpCookieWrapper init: [UserWrapper shareMasterUser].visitKey forName:@"visitkey" ];
//    
//    if (visitKeyCookie) {
//        [cookies addObject:visitKeyCookie];
//    }

	
	[request setRequestCookies:cookies];
	//NSLog(@"all cookies for request:\n%@",cookies);
}
@end
