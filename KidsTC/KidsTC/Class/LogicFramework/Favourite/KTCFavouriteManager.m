//
//  KTCFavouriteManager.m
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCFavouriteManager.h"

static KTCFavouriteManager *_sharedInstance = nil;

@interface KTCFavouriteManager ()

@property (nonatomic, strong) HttpRequestClient *addFavouriteRequest;

@property (nonatomic, strong) HttpRequestClient *deleteFavourateRequest;

@property (nonatomic, strong) HttpRequestClient *loadFavourateRequest;

@end

@implementation KTCFavouriteManager

+ (instancetype)sharedManager {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCFavouriteManager alloc] init];
    });
    return _sharedInstance;
}

- (void)addFavouriteWithIdentifier:(NSString *)identifier
                              type:(KTCFavouriteType)type
                           succeed:(void (^)(NSDictionary *))succeed
                           failure:(void (^)(NSError *))failure {
    if (!self.addFavouriteRequest) {
        self.addFavouriteRequest = [HttpRequestClient clientWithUrlAliasName:@"COLLECT_ADD"];
    }
    [self.addFavouriteRequest cancel];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           identifier, @"number",
                           [NSNumber numberWithInteger:type], @"type", nil];
    [self.addFavouriteRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)deleteFavouriteWithIdentifier:(NSString *)identifier
                                 type:(KTCFavouriteType)type
                              succeed:(void (^)(NSDictionary *))succeed
                              failure:(void (^)(NSError *))failure {
    if (!self.deleteFavourateRequest) {
        self.deleteFavourateRequest = [HttpRequestClient clientWithUrlAliasName:@"COLLECT_DELETE"];
    }
    [self.deleteFavourateRequest cancel];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           identifier, @"number",
                           [NSNumber numberWithInteger:type], @"type", nil];
    [self.deleteFavourateRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadFavouriteWithType:(KTCFavouriteType)type
                         page:(NSUInteger)page
                     pageSize:(NSUInteger)pageSize
                      succeed:(void (^)(NSDictionary *))succeed
                      failure:(void (^)(NSError *))failure {
    if (!self.loadFavourateRequest) {
        self.loadFavourateRequest = [HttpRequestClient clientWithUrlAliasName:@"COLLECT_QUERY"];
    }
    [self.loadFavourateRequest cancel];
    NSMutableDictionary *tempParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:type], @"type",
                                      [NSNumber numberWithInteger:page], @"page",
                                      [NSNumber numberWithInteger:pageSize], @"pagecount", nil];
    if (type == KTCFavouriteTypeStore || type == KTCFavouriteTypeService) {
        [tempParam setObject:[GConfig sharedConfig].currentLocationCoordinateString forKey:@"mapaddr"];
    }
    [self.loadFavourateRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithDictionary:tempParam] success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)stopAddFavourite {
    [self.addFavouriteRequest cancel];
}

- (void)stopDeleteFavourite {
    [self.deleteFavourateRequest cancel];
}

- (void)stopLoadFavourite {
    [self.loadFavourateRequest cancel];
}

@end
