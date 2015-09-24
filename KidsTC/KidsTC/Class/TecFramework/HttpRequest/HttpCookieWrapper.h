/*
 * Copyright (c) 2013,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：HttpCookieWrapper.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：13-05-15
 */


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface HttpCookieWrapper : NSObject

+ (NSMutableArray*) icsonCookies;

+ (NSString*) identifyStrForUser;
+ (NSString*) identifyStrForSite;
+ (NSString*) identifyStrForUserAndSite;
+ (NSString*) identifyStrDefault;


+ (NSHTTPCookie*)init:(NSString *)value forName:(NSString*)name forDomain:(NSString*)domain forPath:(NSString*)path forExpire:(id)exipre;
+ (NSHTTPCookie*)init:(NSString *)value forName:(NSString*)name;

+ (NSArray*)getValues:(NSArray*)names forCookie:(NSArray *)cookies;
+ (NSString *)getValue:(NSString *)name forCookie:(NSArray *)cookies;

@end
