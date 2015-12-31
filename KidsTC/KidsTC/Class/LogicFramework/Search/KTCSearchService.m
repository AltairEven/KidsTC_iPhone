//
//  KTCSearchService.m
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchService.h"

NSString *const kSearchHotKeysHasChangedNotification = @"kSearchHotKeysHasChangedNotification";

NSString *const kSearchHotKeyName = @"kSearchHotKeyName";
NSString *const kSearchHotKeyCondition = @"kSearchHotKeyCondition";

static KTCSearchService *_sharedInstance;

@interface KTCSearchService ()

@property (nonatomic, strong) HttpRequestClient *hotSearchRequest;

@property (nonatomic, strong) HttpRequestClient *serviceSearchRequest;

@property (nonatomic, strong) HttpRequestClient *storeSearchRequest;

@property (nonatomic, strong) HttpRequestClient *newsSearchRequest;

@property (nonatomic, strong) NSMutableDictionary *hotSearchDic;

- (void)loadHotKeySucceed:(NSDictionary *)data;

- (void)loadHotKeyFailed:(NSError *)error;

@end

@implementation KTCSearchService

+ (instancetype)sharedService {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCSearchService alloc] init];
        _sharedInstance.hotSearchDic = [[NSMutableDictionary alloc] init];
    });
    return _sharedInstance;
}

#pragma mark Hot Search

- (void)synchronizeHotSearchKeysWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    if (!self.hotSearchRequest) {
        self.hotSearchRequest = [HttpRequestClient clientWithUrlAliasName:@"SEARCH_GET_HOTKEY"];
    } else {
        [self stopSyncHotSearchKeys];
    }
    __weak KTCSearchService *weakSelf = self;
    [weakSelf.hotSearchRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadHotKeySucceed:responseData];
        if (success) {
            success(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadHotKeyFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadHotKeySucceed:(NSDictionary *)data {
    NSDictionary *dataDic = [data objectForKey:@"data"];
    if (!dataDic || ![dataDic isKindOfClass:[NSDictionary class]]) {
        //无效数据，或数据格式不正确
        return;
    }
    //服务
    NSArray *serviceHotArray = [dataDic objectForKey:@"product"];
    if ([serviceHotArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *hotDic in serviceHotArray) {
            NSString *name = [hotDic objectForKey:@"name"];
            NSDictionary *searchParam = [hotDic objectForKey:@"search_parms"];
            KTCSearchServiceCondition *condition = [KTCSearchServiceCondition conditionFromRawData:searchParam];
            if (!condition) {
                condition = [[KTCSearchServiceCondition alloc] init];
            }
            if ([condition.keyWord length] == 0) {
                condition.keyWord = name;
            }
            NSDictionary *hotKey = [NSDictionary dictionaryWithObjectsAndKeys:name, kSearchHotKeyName, condition, kSearchHotKeyCondition, nil];
            [tempArray addObject:hotKey];
        }
        [self.hotSearchDic setObject:[NSArray arrayWithArray:tempArray] forKey:[NSNumber numberWithInteger:KTCSearchTypeService]];
    }
    //门店
    NSArray *storeHotArray = [dataDic objectForKey:@"store"];
    if ([storeHotArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *hotDic in storeHotArray) {
            NSString *name = [hotDic objectForKey:@"name"];
            NSDictionary *searchParam = [hotDic objectForKey:@"search_parms"];
            KTCSearchStoreCondition *condition = [KTCSearchStoreCondition conditionFromRawData:searchParam];
            if (!condition) {
                condition = [[KTCSearchStoreCondition alloc] init];
            }
            if ([condition.keyWord length] == 0) {
                condition.keyWord = name;
            }
            NSDictionary *hotKey = [NSDictionary dictionaryWithObjectsAndKeys:name, kSearchHotKeyName, condition, kSearchHotKeyCondition, nil];
            [tempArray addObject:hotKey];
        }
        [self.hotSearchDic setObject:[NSArray arrayWithArray:tempArray] forKey:[NSNumber numberWithInteger:KTCSearchTypeStore]];
    }
    //知识库
    NSArray *newsHotArray = [dataDic objectForKey:@"article"];
    if ([newsHotArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *hotDic in newsHotArray) {
            NSString *name = [hotDic objectForKey:@"name"];
            NSDictionary *searchParam = [hotDic objectForKey:@"search_parms"];
            KTCSearchNewsCondition *condition = [KTCSearchNewsCondition conditionFromRawData:searchParam];
            if (!condition) {
                condition = [[KTCSearchNewsCondition alloc] init];
            }
            if ([condition.keyWord length] == 0) {
                condition.keyWord = name;
            }
            NSDictionary *hotKey = [NSDictionary dictionaryWithObjectsAndKeys:name, kSearchHotKeyName, condition, kSearchHotKeyCondition, nil];
            [tempArray addObject:hotKey];
        }
        [self.hotSearchDic setObject:[NSArray arrayWithArray:tempArray] forKey:[NSNumber numberWithInteger:KTCSearchTypeNews]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kSearchHotKeysHasChangedNotification object:nil];
}

- (void)loadHotKeyFailed:(NSError *)error {
    
}

- (NSArray *)hotSearchConditionsOfSearchType:(KTCSearchType)type {
    NSArray *hotSearchArray = [self.hotSearchDic objectForKey:[NSNumber numberWithInteger:type]];
    return hotSearchArray;
}

- (KTCSearchCondition *)mostHotSearchConditionOfSearchType:(KTCSearchType)type {
    NSDictionary *searchParam = [[self hotSearchConditionsOfSearchType:type] firstObject];
    if ([searchParam count] == 0) {
        return nil;
    }
    return [searchParam objectForKey:kSearchHotKeyCondition];
}

- (void)stopSyncHotSearchKeys {
    [self.hotSearchRequest cancel];
}



#pragma mark Service

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

- (void)stopServiceSearch {
    [self.serviceSearchRequest cancel];
}

#pragma mark Store

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
    NSString *mapAddr = @"";
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
        if ([condition.coordinateString length] > 0) {
            mapAddr = condition.coordinateString;
        }
    }
    if ([mapAddr length] == 0) {
        mapAddr = [[GConfig sharedConfig] currentLocationCoordinateString];
    }
    [requestParam setObject:mapAddr forKey:@"mapaddr"];
    
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

- (void)stopStoreSearch {
    [self.storeSearchRequest cancel];
}

#pragma mark News

- (void)startNewsSearchWithKeyWord:(NSString *)keyword
                         pageIndex:(NSUInteger)index
                          pageSize:(NSUInteger)size
                           success:(void (^)(NSDictionary *))success
                           failure:(void (^)(NSError *))failure {
    if (!self.newsSearchRequest) {
        self.newsSearchRequest = [HttpRequestClient clientWithUrlAliasName:@"ARTICLE_GET_LIST"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:size], @"pageCount",
                           [NSNumber numberWithInteger:0], @"authorId",
                           keyword, @"keyWord", nil];
    __weak KTCSearchService *weakSelf = self;
    [weakSelf.newsSearchRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (success) {
            success(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)stopNewsSearch {
    
}

@end



@implementation KTCSearchTypeItem

+ (instancetype)itemWithType:(KTCSearchType)type Name:(NSString *)name image:(UIImage *)image {
    KTCSearchTypeItem *item = [[KTCSearchTypeItem alloc] init];
    item.type = type;
    item.name = name;
    item.relationImage = image;
    return item;
}

@end