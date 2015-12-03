//
//  KTCBrowseHistoryManager.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrowseHistoryServiceListItemModel.h"
#import "BrowseHistoryStoreListItemModel.h"

typedef enum {
    KTCBrowseHistoryTypeNone = 0,
    KTCBrowseHistoryTypeService = 1,
    KTCBrowseHistoryTypeStore
}KTCBrowseHistoryType;

@interface KTCBrowseHistoryManager : NSObject

+ (instancetype)sharedManager;

- (void)getUserBrowseHistoryWithType:(KTCBrowseHistoryType)type needMore:(BOOL)need succeed:(void(^)(NSArray *modelsArray))succeed failure:(void(^)(NSError *error))failure;

- (void)stopGettingHistory;

- (NSArray *)resultForType:(KTCBrowseHistoryType)type;

@end
