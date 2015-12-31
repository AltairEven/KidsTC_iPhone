//
//  KTCSearchService.h
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTCSearchCondition.h"

extern NSString *const kSearchHotKeysHasChangedNotification;

extern NSString *const kSearchHotKeyName;
extern NSString *const kSearchHotKeyCondition;

typedef enum {
    KTCSearchTypeNone = 0,
    KTCSearchTypeService = 1,
    KTCSearchTypeStore,
    KTCSearchTypeNews
}KTCSearchType;

@interface KTCSearchService : NSObject

+ (instancetype)sharedService;

- (void)synchronizeHotSearchKeysWithSuccess:(void(^)(NSDictionary *responseData))success failure:(void(^)(NSError *error))failure;

- (void)startServiceSearchWithParamDic:(NSDictionary *)param
                             Condition:(KTCSearchServiceCondition *)condition
                               success:(void(^)(NSDictionary *responseData))success
                               failure:(void(^)(NSError *error))failure;

- (void)startStoreSearchWithParamDic:(NSDictionary *)param
                           Condition:(KTCSearchStoreCondition *)condition
                             success:(void(^)(NSDictionary *responseData))success
                             failure:(void(^)(NSError *error))failure;

- (void)startNewsSearchWithKeyWord:(NSString *)keyword
                         pageIndex:(NSUInteger)index
                          pageSize:(NSUInteger)size
                           success:(void(^)(NSDictionary *responseData))success
                           failure:(void(^)(NSError *error))failure;


- (NSArray *)hotSearchConditionsOfSearchType:(KTCSearchType)type;

- (KTCSearchCondition *)mostHotSearchConditionOfSearchType:(KTCSearchType)type;

- (void)stopSyncHotSearchKeys;

- (void)stopServiceSearch;

- (void)stopStoreSearch;

- (void)stopNewsSearch;

@end

@interface KTCSearchTypeItem : NSObject

@property (nonatomic, assign) KTCSearchType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *relationImage;

+ (instancetype)itemWithType:(KTCSearchType)type Name:(NSString *)name image:(UIImage *)image;

@end
