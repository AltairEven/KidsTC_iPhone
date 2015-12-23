//
//  HttpIcsonCookieManager.m
//  ICSON
//
//  Created by 钱烨 on 3/5/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HttpIcsonCookieManager.h"
#import "UserWrapper.h"
#import "UIDevice+IdentifierAddition.h"


#define CookieDomain (@".kidstc.com")

static HttpIcsonCookieManager *_sharedManager = nil;


NSString *const kHttpKTCCookieKeyUid = @"uid";
NSString *const kHttpKTCCookieKeySkey = @"skey";
NSString *const kHttpKTCCookieKeyVersion = @"appversion";
NSString *const kHttpKTCCookieKeyDeviceId = @"deviceid";
NSString *const kHttpKTCCookieKeyAppSource = @"appsource";
NSString *const kHttpKTCCookieKeyApp = @"app";
NSString *const kHttpKTCCookieKeyUserRole = @"population_type";
NSString *const kHttpKTCCookieKeyCoordinate = @"mapaddr";

@interface HttpIcsonCookieManager ()

@property (nonatomic, strong) NSLock *resetLock;

@end

@implementation HttpIcsonCookieManager


- (id)init
{
    self = [super init];
    if (self) {
        self.resetLock = [[NSLock alloc] init];
    }
    
    return self;
}


+ (instancetype)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^ (void) {
        _sharedManager = [[HttpIcsonCookieManager alloc] init];
    });
    
    return _sharedManager;
}



- (void)setupCookies
{
    //组装需要设置的值
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *uid = [NSDictionary dictionaryWithObject:[KTCUser currentUser].uid forKey:kHttpKTCCookieKeyUid];
    [cookieArray addObject:uid];
    
    NSDictionary *skey = [NSDictionary dictionaryWithObject:[KTCUser currentUser].skey forKey:kHttpKTCCookieKeySkey];
    [cookieArray addObject:skey];
    
    NSDictionary *version = [NSDictionary dictionaryWithObject:[GConfig getCurrentAppVersionCode] forKey:kHttpKTCCookieKeyVersion];
    [cookieArray addObject:version];
    
    NSDictionary *deviceId = [NSDictionary dictionaryWithObject:[[UIDevice currentDevice] uniqueDeviceIdentifier] forKey:kHttpKTCCookieKeyDeviceId];
    [cookieArray addObject:deviceId];
    
    NSDictionary *appSource = [NSDictionary dictionaryWithObject:@"iPhone" forKey:kHttpKTCCookieKeyAppSource];
    [cookieArray addObject:appSource];
    
    NSDictionary *app = [NSDictionary dictionaryWithObject:@"1" forKey:kHttpKTCCookieKeyApp];
    [cookieArray addObject:app];
    
    NSDictionary *coordinate = [NSDictionary dictionaryWithObject:[[GConfig sharedConfig] currentLocationCoordinateString] forKey:kHttpKTCCookieKeyCoordinate];
    [cookieArray addObject:coordinate];
    
    //设置cookie
    [self setIcsonCookiesWithNameValueDictionaries:[NSArray arrayWithArray:cookieArray]];
}



- (void)resetCookies
{
    [self.resetLock lock];
    //先删除所有cookie
    [self deleteAllCookies];
    [self setupCookies];
    [self.resetLock unlock];
}



- (void)setIcsonCookieWithName:(NSString *)name andValue:(NSString *)value
{
    if (!name || !value) {
        return;
    }
    NSDictionary *propertiesKidsTC = [NSDictionary dictionaryWithObjectsAndKeys:
                                     name, NSHTTPCookieName,
                                     value, NSHTTPCookieValue,
                                     @"/", NSHTTPCookiePath,
                                     CookieDomain, NSHTTPCookieDomain, nil];
    NSHTTPCookie *kisTCCookie = [NSHTTPCookie cookieWithProperties:propertiesKidsTC];
    
    //set cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:kisTCCookie];
}


- (void)setCookie:(NSHTTPCookie *)cookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}


- (void)setIcsonCookiesWithNameValueDictionaries:(NSArray *)array
{
    if (!array) {
        return;
    }
    
    for (NSDictionary *properties in array) {
        [self setIcsonCookieWithName:[[properties allKeys] objectAtIndex:0] andValue:[[properties allValues] objectAtIndex:0]];
    }
}



- (void)setIcsonCookiesWithNamesAndValues:(NSString *)first, ...
{
    va_list arguments;
    NSString *eachString;
    if (first) {
        va_start(arguments, first);
        
        int n = 0;
        NSMutableArray *nameArray = [[NSMutableArray alloc] initWithObjects:first, nil];
        NSMutableArray *valueArray = [[NSMutableArray alloc] init];
        
        while ((eachString = va_arg(arguments, NSString *))) {
            NSLog(@"%@",eachString);
            n ++;
            if (n % 2) {
                //奇数位是value
                [valueArray addObject:eachString];
            } else {
                //偶数位是name
                [nameArray addObject:eachString];
            }
            
        }
        va_end(arguments);
        //调用设置cookie方法
        [self setIcsonCookiesWithNames:nameArray andValues:valueArray];
    }
}


- (void)setIcsonCookiesWithNames:(NSArray *)namesArray andValues:(NSArray *)valuesArray
{
    if (!namesArray || !valuesArray) {
        return;
    }
    NSUInteger nameCount = [namesArray count];
    NSUInteger valueCount = [valuesArray count];
    if (nameCount != valueCount) {
        return;
    }
    
    for (NSUInteger n = 0; n < nameCount; n ++) {
        NSString *name = [namesArray objectAtIndex:n];
        NSString *value = [valuesArray objectAtIndex:n];
        [self setIcsonCookieWithName:name andValue:value];
    }
}


- (void)setCookies:(NSArray *)cookiesArray
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookiesArray forURL:nil mainDocumentURL:nil];
}


- (NSHTTPCookie *)getCookieWithName:(NSString *)name
{
    if (!name) {
        return nil;
    }
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        if ([cookie.name isEqualToString:name] && [cookie.domain isEqualToString:CookieDomain]) {
            return cookie;
        }
    }
    return nil;
}


- (NSArray *)getCookiesWithNames:(NSArray *)namesArray
{
    if (!namesArray) {
        return nil;
    }
    
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    for (NSString *name in namesArray) {
        NSHTTPCookie *cookie = [self getCookieWithName:name];
        if (cookie) {
            [cookieArray addObject:cookie];
        }
    }
    
    if ([cookieArray count] > 0) {
        return cookieArray;
    }
    return nil;
}


- (NSArray *)getAllCookies
{
    return [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
}


- (void)deleteCookieWithName:(NSString *)name
{
    if (!name) {
        return;
    }
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        if ([cookie.name isEqualToString:name]) {
            [storage deleteCookie:cookie];
        }
    }
}


- (void)deleteAllCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
}

@end
