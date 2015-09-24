//
//  KTCFavouriteManager.h
//  KidsTC
//
//  Created by 钱烨 on 8/21/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    KTCFavouriteTypeService,
    KTCFavouriteTypeStore,
    KTCFavouriteTypeStrategy,
    KTCFavouriteTypeNews
}KTCFavouriteType;

@interface KTCFavouriteManager : NSObject

+ (instancetype)sharedManager;

- (void)addFavouriteWithIdentifier:(NSString *)identifier
                              type:(KTCFavouriteType)type
                           succeed:(void(^)(NSDictionary *data))succeed
                           failure:(void(^)(NSError *error))failure;

- (void)deleteFavouriteWithIdentifier:(NSString *)identifier
                                 type:(KTCFavouriteType)type
                              succeed:(void(^)(NSDictionary *data))succeed
                              failure:(void(^)(NSError *error))failure;

- (void)loadFavouriteWithType:(KTCFavouriteType)type
                         page:(NSUInteger)page
                     pageSize:(NSUInteger)pageSize
                      succeed:(void(^)(NSDictionary *data))succeed
                      failure:(void(^)(NSError *error))failure;

- (void)stopAddFavourite;

- (void)stopDeleteFavourite;

- (void)stopLoadFavourite;

@end