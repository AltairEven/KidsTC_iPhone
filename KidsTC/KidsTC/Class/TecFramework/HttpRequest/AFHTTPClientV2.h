//
//  AFHTTPClientV2.h
//  PAFNetClient
//
//  Created by michael on 15-2-28.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, HTTPReqMethodTypeE) {
    kHTTPReqMethodTypeGET         = 0,
    kHTTPReqMethodTypePOST        = 1,
    kHTTPReqMethodTypeDELETE      = 2,
};

@class AFHTTPClientV2;


@interface AFHTTPClientV2 : NSObject<NSCopying> {
    NSURLSessionTask *_currentSessionTask;
}

@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

@property (nonatomic, assign) NSStringEncoding stringEncoding;

- (void)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HTTPReqMethodTypeE)httpMethod
                           stringEncoding:(NSStringEncoding)encoding
                                  timeout:(NSTimeInterval)seconds
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;

- (void)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HTTPReqMethodTypeE)httpMethod
                                 userInfo:(NSDictionary*)userInfo
                           stringEncoding:(NSStringEncoding)encoding
                                  timeout:(NSTimeInterval)seconds
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;


- (void)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;

- (void)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                                 userInfo:(NSDictionary*)userInfo
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;


- (void)cancel;

@end
