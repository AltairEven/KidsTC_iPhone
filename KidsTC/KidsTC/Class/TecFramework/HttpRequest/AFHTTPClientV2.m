 //
//  AFHTTPClientV2.m
//  PAFNetClient
//
//  Created by michael on 15-2-28.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "AFHTTPClientV2.h"


@interface AFHTTPClientV2 ()

@end

@implementation AFHTTPClientV2

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HTTPReqMethodTypeE)httpMethod
                           stringEncoding:(NSStringEncoding)encoding
                                  timeout:(NSTimeInterval)seconds
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;
{
    [self requestWithBaseURLStr:URLString params:params httpMethod:httpMethod userInfo:nil stringEncoding:encoding timeout:seconds success:success failure:failure];
}

- (void)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HTTPReqMethodTypeE)httpMethod
                                 userInfo:(NSDictionary*)userInfo
                           stringEncoding:(NSStringEncoding)encoding
                                  timeout:(NSTimeInterval)seconds
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure;
{
    self.userInfo = userInfo;
    self.timeoutSeconds = seconds;
    self.stringEncoding = encoding;
    
    __weak AFHTTPClientV2 *weakSelf = self;
    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysVersion < 7.0) {
        AFHTTPRequestOperationManager   *httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        httpClient.requestSerializer.timeoutInterval = self.timeoutSeconds;
        httpClient.requestSerializer.stringEncoding = self.stringEncoding;
        httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/xml", @"text/html", @"text/plain",nil];
        [(AFJSONResponseSerializer *)httpClient.responseSerializer setRemovesKeysWithNullValues:YES];

        if (httpMethod == kHTTPReqMethodTypeGET) {
            
            [httpClient GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];
            
        }else if (httpMethod == kHTTPReqMethodTypePOST){
            
            
            [httpClient POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];
            
        }else if (httpMethod == kHTTPReqMethodTypeDELETE){
            
            
            [httpClient DELETE:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];
            
        }

    }else{
        AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        httpClient.requestSerializer.timeoutInterval = weakSelf.timeoutSeconds;
        httpClient.requestSerializer.stringEncoding = weakSelf.stringEncoding;
        httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/xml", @"text/html", @"text/plain",nil];
        [(AFJSONResponseSerializer *)httpClient.responseSerializer setRemovesKeysWithNullValues:YES];

        if (httpMethod == kHTTPReqMethodTypeGET) {
            
            _currentSessionTask = [httpClient GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];
            
        }else if (httpMethod == kHTTPReqMethodTypePOST){
            
            _currentSessionTask = [httpClient POST:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];
            
        }else if (httpMethod == kHTTPReqMethodTypeDELETE){
            
            _currentSessionTask = [httpClient DELETE:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success) {
                    success(weakSelf, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failure) {
                    failure(weakSelf, error);
                }
            }];            
        }

    }
}

- (void)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                                 userInfo:(NSDictionary*)userInfo
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure
{
    self.userInfo = userInfo;
    
    __weak AFHTTPClientV2 *weakSelf = self;
    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysVersion < 7.0) {
        AFHTTPRequestOperationManager   *httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/xml", @"text/html", @"text/plain",nil];

        [httpClient POST:URLString parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(weakSelf, responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(weakSelf, error);
            }
        }];

    }else{
        AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/xml", @"text/html", @"text/plain",nil];
        [(AFJSONResponseSerializer *)httpClient.responseSerializer setRemovesKeysWithNullValues:YES];

        _currentSessionTask = [httpClient POST:URLString parameters:parameters constructingBodyWithBlock:block success:^(NSURLSessionDataTask *task, id responseObject) {
            if (success) {
                success(weakSelf, responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure) {
                failure(weakSelf, error);
            }
        }];
    }
}

- (void)requestWithBaseURLStr:(NSString *)URLString
                               parameters:(id)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  success:(void (^)(AFHTTPClientV2 *request, id responseObject))success
                                  failure:(void (^)(AFHTTPClientV2 *request, NSError *error))failure
{
    [self requestWithBaseURLStr:URLString parameters:parameters userInfo:nil constructingBodyWithBlock:block success:success failure:failure];
}

- (void)downloadImageWithURLStr:(NSString *)URLString success:(void (^)(AFHTTPClientV2 *, id))success failure:(void (^)(AFHTTPClientV2 *, NSError *))failure {
    __weak AFHTTPClientV2 *weakSelf = self;
    AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    httpClient.responseSerializer = [AFImageResponseSerializer serializer];
    
    _currentSessionTask = [httpClient GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(weakSelf, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(weakSelf, error);
        }
    }];
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    AFHTTPClientV2  *clientV2 = [[self class] init];
    [clientV2 setUserInfo:[[self userInfo] copyWithZone:zone]];
    return clientV2;
}


- (void)cancel {
    if (_currentSessionTask) {
        [_currentSessionTask cancel];
        _currentSessionTask = nil;
    }
}

@end
