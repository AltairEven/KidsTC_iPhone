//
//  WebCookieCache.m
//  iPhone51Buy
//
//  Created by Gene Chu on 11/6/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "WebCookieCache.h"

@implementation WebCookieCache

+ (WebCookieCache *)sharedWebCookieCache
{
    static WebCookieCache * sharedWebCookieCache = nil;
    if (!sharedWebCookieCache)
    {
        sharedWebCookieCache = [[WebCookieCache alloc] init];
    }
    
    return sharedWebCookieCache;
}

- (id)init
{
    self = [super init];
    if (self)
    {
//        _cookies = [[NSMutableArray alloc] init];
        _cookiesDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (NSHTTPCookie *)cookieOfName:(NSString *)name path:(NSString *)path domain:(NSString *)domain url:(NSString *)urlStr
{
    NSHTTPCookie * theCookie = nil;
    if (urlStr)
    {
        NSArray * cookies = [self.cookiesDict objectForKey:urlStr];
        for (NSHTTPCookie * aCookie in cookies)
        {
            if ([aCookie.name isEqualToString:name] && [aCookie.path isEqualToString:path] && [aCookie.domain isEqualToString:domain])
            {
                theCookie = aCookie;
            }
        }
    }
    
    return theCookie;
}

- (void)cleanAllCache
{
    self.cookiesDict = nil;
}
@end
