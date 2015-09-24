/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpCookieWrapper.m
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */

#import "HttpCookieWrapper.h"
#import "GConfig.h"

@implementation HttpCookieWrapper

+ (NSMutableArray*) icsonCookies
{
    KTCUser *user = [KTCUser currentUser];
    
    NSMutableArray * cookies = [[NSMutableArray alloc] init];
    
    // environment info cookie
    NSHTTPCookie *env = [HttpCookieWrapper init:[GConfig sharedConfig].envInfo forName:GLOBAL_COOKIE_NAME_ENV];
    [cookies addObject:env];
    
    // user info cookie
    if( [user.uid length] > 0 && [user.skey length] > 0  ){
        NSHTTPCookie *uidCookie = [HttpCookieWrapper init:user.uid forName:GLOBAL_COOKIE_NAME_UID];
        NSHTTPCookie *sKeyCookie = [ HttpCookieWrapper init: user.skey forName:GLOBAL_COOKIE_NAME_SKEY ];;
//        if (user.loginUserType == LoginQQUser) {
//            NSString * qqlSkey = [user getQQLSkey];
//            if (qqlSkey) {
//                NSHTTPCookie * lsKeyCookie = [ HttpCookieWrapper init: qqlSkey forName:GLOBAL_COOKIE_NAME_LSKEY ];
//                [cookies addObject:lsKeyCookie];
//            }
//        }
//        NSHTTPCookie *tokenCookie = [HttpCookieWrapper init: user.token forName:GLOBAL_COOKIE_NAME_TOKEN ];
        
        [cookies addObject:uidCookie];
        [cookies addObject:sKeyCookie];
//        [cookies addObject:tokenCookie];
    }
    
    // site info cookie
//    NSHTTPCookie *wsid = [HttpCookieWrapper init:[NSString stringWithFormat:@"%ld", (long)user.siteID] forName:GLOBAL_COOKIE_NAME_WSID];
//    [cookies addObject:wsid];
    
    // districtid info cookie
//    NSHTTPCookie *distid = [HttpCookieWrapper init:[NSString stringWithFormat:@"%d", user.districtID] forName:GLOBAL_COOKIE_NAME_DISTID];
//    [cookies addObject:distid];
    
//    if( [UserWrapper shareMasterUser].subSiteID > 0 ){
//        NSHTTPCookie *siteSc = [HttpCookieWrapper init:[NSString stringWithFormat:@"%d", user.subSiteID] forName:GLOBAL_COOKIE_NAME_SITE_SC];
//        [cookies addObject:siteSc];
//    }

    return cookies;
}

+ (NSString*) identifyStrForUser
{
    UserWrapper *user = [UserWrapper shareMasterUser];
    return [NSString stringWithFormat:@"%@:%ld:", [GConfig sharedConfig].envInfo, (long)user.uid];
}

+ (NSString*) identifyStrForSite
{
    UserWrapper *user = [UserWrapper shareMasterUser];
//    return [NSString stringWithFormat:@"%@::%d-%d", [GConfig sharedConfig].envInfo, user.siteID, user.subSiteID];
	return [NSString stringWithFormat:@"%@::%ld", [GConfig sharedConfig].envInfo, (long)user.siteID];
}

+ (NSString*) identifyStrForUserAndSite
{
    UserWrapper *user = [UserWrapper shareMasterUser];
//    return [NSString stringWithFormat:@"%@:%d:%d-%d", [GConfig sharedConfig].envInfo, user.uid, user.siteID, user.subSiteID];
	return [NSString stringWithFormat:@"%@:%ld:%ld", [GConfig sharedConfig].envInfo, (long)user.uid, (long)user.siteID];
}

+ (NSString*) identifyStrDefault
{
    return [NSString stringWithFormat:@"%@::", [GConfig sharedConfig].envInfo];
}


+(NSHTTPCookie *)init:(NSString *)value forName:(NSString*)name forDomain:(NSString*)domain forPath:(NSString*)path forExpire:(id)exipre{	
	NSDictionary *properties = [[NSMutableDictionary alloc] init];
	[properties setValue:name forKey:NSHTTPCookieName];
	[properties setValue:value forKey:NSHTTPCookieValue];
//	[properties setValue:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:NSHTTPCookieValue];
	[properties setValue:domain forKey:NSHTTPCookieDomain];
//	[properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60*24*365] forKey:NSHTTPCookieExpires];
	[properties setValue:path forKey:NSHTTPCookiePath];
	[properties setValue:@"false" forKey:NSHTTPCookieSecure];
	[properties setValue:@"true" forKey:NSHTTPCookieDiscard];

	NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
    
	return cookie;
}
	

+(NSHTTPCookie *)init:(NSString *)value forName:(NSString*)name{	
	return [HttpCookieWrapper init:value forName:name forDomain: @".51buy.com" forPath: @"/" forExpire : [NSDate dateWithTimeIntervalSinceNow:60*60]];
}


+(NSArray*)getValues:(NSArray*)names forCookie:(NSArray *)cookies{
	NSMutableDictionary *values = [[NSMutableDictionary alloc] init ];
	
	for(NSInteger i = 0, len = [names count]; i < len; i++){
		[values setObject:@"" forKey:[names objectAtIndex:i]];
	}
	
	for(NSInteger i = 0, len = [cookies count]; i < len; i++){
		NSHTTPCookie *cookie = [cookies objectAtIndex:i];
		
        if ([cookie isKindOfClass:[NSHTTPCookie class]]) {
            if( [values objectForKey:cookie.name] != nil ){
                [values setObject:cookie.value forKey:cookie.name];
            }
        } else if (i < names.count) {
            [values setObject:cookie forKey:[names objectAtIndex:i]];
        }

	}
	
	NSMutableArray *ret = [[NSMutableArray alloc] init ]; 
	
	for(NSInteger i = 0, len = [names count]; i < len; i++){
		NSString * _val = [ values objectForKey:[ names objectAtIndex:i ] ];
		[ret addObject: _val ? _val : @""];
	}
	return ret;
}

+ (NSString *)getValue:(NSString *)name forCookie:(NSArray *)cookies{
	NSArray *values = [self getValues:[NSArray arrayWithObject:name] forCookie:cookies];
	
	return [values objectAtIndex:0];

}

@end
