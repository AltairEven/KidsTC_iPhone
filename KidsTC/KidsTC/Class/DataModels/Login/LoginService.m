//
//  LoginService.m
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "LoginService.h"
#import "GTMBase64.h"

static LoginService *_sharedInstance = nil;

@interface LoginService ()

@property (nonatomic, strong) HttpRequestClient *KTCLoginRequest;

@property (nonatomic, strong) HttpRequestClient *QQLoginRequest;

@property (nonatomic, strong) HttpRequestClient *WechatLoginRequest;

@end

@implementation LoginService

+ (instancetype)sharedService {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[LoginService alloc] init];
    });
    return _sharedInstance;
}

- (void)KTCLoginWithAccount:(NSString *)account
                   password:(NSString *)password
                    success:(void (^)(NSString *, NSString *))sucess
                    failure:(void (^)(NSError *))failure {
    if (!self.KTCLoginRequest) {
        self.KTCLoginRequest = [HttpRequestClient clientWithUrlAliasName:@"LOGIN_LOGIN"];
    }
    NSString *encodePWD = [GTMBase64 stringByEncodingData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:account, @"account", encodePWD, @"password", nil];
    
    __weak LoginService *weakSelf = self;
    [weakSelf.KTCLoginRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        NSDictionary *data = [responseData objectForKey:@"data"];
        if (data) {
            NSString *uid = [NSString stringWithFormat:@"%@", [data objectForKey:@"uid"]];
            NSString *skey = [NSString stringWithFormat:@"%@", [data objectForKey:@"skey"]];
            if (sucess) {
                sucess(uid, skey);
            }
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
