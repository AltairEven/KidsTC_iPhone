//
//  KTCSearchService.h
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCSearchCondition.h"

typedef enum {
    KTCSearchTypeService = 1,
    KTCSearchTypeStore
}KTCSearchType;

@interface KTCSearchService : NSObject

+ (instancetype)sharedService;

- (void)startServiceSearchWithParamDic:(NSDictionary *)param
                             Condition:(KTCSearchServiceCondition *)condition
                               success:(void(^)(NSDictionary *responseData))success
                               failure:(void(^)(NSError *error))failure;

- (void)startStoreSearchWithParamDic:(NSDictionary *)param
                           Condition:(KTCSearchStoreCondition *)condition
                             success:(void(^)(NSDictionary *responseData))success
                             failure:(void(^)(NSError *error))failure;

- (void)stopServiceSearch;

- (void)stopStoreSearch;

@end
