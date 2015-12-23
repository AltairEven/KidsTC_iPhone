//
//  VersionManager.m
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "VersionManager.h"
#import "GConfig.h"

static VersionManager *_versionManager = nil;

@interface VersionManager ()

@property (nonatomic, strong) HttpRequestClient *checkVersionRequest;


@end

@implementation VersionManager
@synthesize version = _version;
@synthesize checkVersionRequest;

- (id)init
{
    self = [super init];
    if (self) {
        _version = [GConfig getCurrentAppVersionCode];
    }
    return self;
}


+ (instancetype)sharedManager
{
    static dispatch_once_t predicate = 0;
    
    dispatch_once(&predicate, ^{
        _versionManager = [[VersionManager alloc] init];
    });
    
    return _versionManager;
}



- (void)checkAppVersionWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    if (!self.checkVersionRequest)
    {
        self.checkVersionRequest = [HttpRequestClient clientWithUrlAliasName:@"APP_UPDATE_VERSION"];
    }
    
    __weak VersionManager *weakSelf = self;
    [weakSelf.checkVersionRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if ([[responseData objectForKey:@"Code"] integerValue] != 0) {
            failure(nil);
        } else {
            success(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        
        failure(error);
        
    }];
}



- (void)goToUpdateViaItunes
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_APP_STORE_UPDATE]];
}

@end
