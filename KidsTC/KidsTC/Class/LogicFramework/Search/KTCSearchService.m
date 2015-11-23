//
//  KTCSearchService.m
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchService.h"

static KTCSearchService *_sharedInstance;

@interface KTCSearchService ()

@property (nonatomic, strong) HttpRequestClient *serviceSearchRequest;

@property (nonatomic, strong) HttpRequestClient *storeSearchRequest;

@end

@implementation KTCSearchService

+ (instancetype)sharedService {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCSearchService alloc] init];
    });
    return _sharedInstance;
}

/*
  a,c,k,s,st
  */
- (void)startServiceSearchWithParamDic:(NSDictionary *)param
                             Condition:(KTCSearchServiceCondition *)condition
                               success:(void (^)(NSDictionary *))success
                               failure:(void (^)(NSError *))failure {
    if (!self.serviceSearchRequest) {
        self.serviceSearchRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_SEARCH"];
    }
    [self.serviceSearchRequest cancel];
    
    if (!param) {
        return;
    }
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:param];
    if (condition) {
        if ([condition.age.identifier length] > 0) {
            [requestParam setObject:condition.age.identifier forKey:@"a"];
        }
        if ([condition.categoryIdentifier length] > 0) {
            [requestParam setObject:condition.categoryIdentifier forKey:@"c"];
        }
        if ([condition.keyWord length] > 0) {
            [requestParam setObject:condition.keyWord forKey:@"k"];
        }
        if ([condition.area.identifier length] > 0) {
            [requestParam setObject:condition.area.identifier forKey:@"s"];
        }
        if (condition.sortType > 0) {
            [requestParam setObject:[NSString stringWithFormat:@"%d", condition.sortType] forKey:@"st"];
        }
    }
    
    __weak KTCSearchService *weakSelf = self;
    [weakSelf.serviceSearchRequest startHttpRequestWithParameter:requestParam success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)startStoreSearchWithParamDic:(NSDictionary *)param
                           Condition:(KTCSearchStoreCondition *)condition
                             success:(void (^)(NSDictionary *))success
                             failure:(void (^)(NSError *))failure {
    if (!self.storeSearchRequest) {
        self.storeSearchRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_SEARCH"];
    }
    [self.storeSearchRequest cancel];
    
    if (!param) {
        return;
    }
    NSMutableDictionary *requestParam = [NSMutableDictionary dictionaryWithDictionary:param];
    if (condition) {
        if ([condition.age.identifier length] > 0) {
            [requestParam setObject:condition.age.identifier forKey:@"a"];
        }
        if ([condition.categoryIdentifier length] > 0) {
            [requestParam setObject:condition.categoryIdentifier forKey:@"c"];
        }
        if ([condition.keyWord length] > 0) {
            [requestParam setObject:condition.keyWord forKey:@"k"];
        }
        if ([condition.area.identifier length] > 0) {
            [requestParam setObject:condition.area.identifier forKey:@"s"];
        }
        if (condition.sortType > 0) {
            [requestParam setObject:[NSString stringWithFormat:@"%d", condition.sortType] forKey:@"st"];
        }
    }
    [requestParam setObject:[[GConfig sharedConfig] currentLocationCoordinateString] forKey:@"mapAddr"];
    
    __weak KTCSearchService *weakSelf = self;
    [weakSelf.storeSearchRequest startHttpRequestWithParameter:requestParam success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)stopServiceSearch {
    [self.serviceSearchRequest cancel];
}

- (void)stopStoreSearch {
    [self.storeSearchRequest cancel];
}

@end