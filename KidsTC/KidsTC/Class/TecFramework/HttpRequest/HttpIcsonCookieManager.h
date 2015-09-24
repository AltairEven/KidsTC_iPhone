//
//  HttpIcsonCookieManager.h
//  ICSON
//
//  Created by 钱烨 on 3/5/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kHttpIcsonCookieKeyUid;
extern NSString *const kHttpIcsonCookieKeySkey;
extern NSString *const kHttpIcsonCookieKeyVersion;
extern NSString *const kHttpIcsonCookieKeyDeviceId;
extern NSString *const kHttpIcsonCookieKeyAppSource;
extern NSString *const kHttpIcsonCookieKeyApp;

//AFNetWorking共享NSHTTPCookieStorage中设置的cookie
@interface HttpIcsonCookieManager : NSObject

/*
 *brief:HttpIcsonCookieManager单例方法
 *return:HttpIcsonCookieManager实例
 */
+ (instancetype)sharedManager;

/*
 *brief:设置需要的所有cookie
 *return:void
 */
- (void)setupCookies;

/*
 *brief:重置所有cookie
 *return:void
 */
- (void)resetCookies;

/*
 *brief:根据name和value设置易迅cookie
 *param:name
 *param:value
 *return:void
 */
- (void)setIcsonCookieWithName:(NSString *)name andValue:(NSString *)value;

/*
 *brief:设置cookie
 *param:cookie
 *return:void
 */
- (void)setCookie:(NSHTTPCookie *)cookie;

/*
 *brief:根据Dictionary（name为key，value为value）数组设置易迅cookie
 *param:Dictionary（name为key，value为value）数组
 *return:void
 */
- (void)setIcsonCookiesWithNameValueDictionaries:(NSArray *)array;

/*
 *brief:根据name和value不定参数设置易迅cookie
 *param:name1, value1, name2, value2,..., nil
 *return:void
 */
- (void)setIcsonCookiesWithNamesAndValues:(NSString *)first, ...;

/*
 *brief:根据name数组和value数组设置易迅cookie，数组长度要相等
 *param:name数组
 *param:value数组
 *return:void
 */
- (void)setIcsonCookiesWithNames:(NSArray *)namesArray andValues:(NSArray *)valuesArray;

/*
 *brief:根据cookie数组设置cookie
 *param:cookie数组
 *return:void
 */
- (void)setCookies:(NSArray *)cookiesArray;

/*
 *brief:根据name获取易迅cookie（51buy.com）
 *param:name
 *return:name对应51buy.com域名的cookie
 */
- (NSHTTPCookie *)getCookieWithName:(NSString *)name;

/*
 *brief:根据name数组获取易迅cookie（51buy.com）数组
 *param:name数组
 *return:name对应51buy.com域名的cookie数组
 */
- (NSArray *)getCookiesWithNames:(NSArray *)namesArray;

/*
 *brief:获取所有cookie
 *return:所有cookie的数组
 */
- (NSArray *)getAllCookies;

/*
 *brief:根据name删除cookie
 *param:name
 *return:void
 */
- (void)deleteCookieWithName:(NSString *)name;

/*
 *brief:删除所有cookie
 *return:void
 */
- (void)deleteAllCookies;

@end
