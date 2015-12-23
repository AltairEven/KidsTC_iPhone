//
//  WebCookieCache.h
//  iPhone51Buy
//
//  用户保存 GWebViewController 中Cookie数据
//
//  Created by Gene Chu on 11/6/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebCookieCache : NSObject

//@property (nonatomic, retain)NSMutableArray * cookies;
@property (nonatomic, strong)NSMutableDictionary *cookiesDict;

+ (WebCookieCache *)sharedWebCookieCache;

- (NSHTTPCookie *)cookieOfName:(NSString *)name path:(NSString *)path domain:(NSString *)domain url:(NSString *)urlStr;
- (void)cleanAllCache;
@end
