//
//  KTCBrowseHistoryManager.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "KTCBrowseHistoryManager.h"

#define PageSize (10)

static KTCBrowseHistoryManager *_sharedInstance = nil;

@interface KTCBrowseHistoryManager ()

@property (nonatomic, strong) HttpRequestClient *loadHistoryRequest;

@property (nonatomic, strong) NSMutableArray *serviceResultArray;

@property (nonatomic, strong) NSMutableArray *storeResultArray;

@property (nonatomic, assign) NSUInteger pageIndex;

- (void)clearDataForType:(KTCBrowseHistoryType)type;

- (void)loadHistorySucceedWithData:(NSDictionary *)data type:(KTCBrowseHistoryType)type;

- (void)loadHistoryFailedWithError:(NSError *)error type:(KTCBrowseHistoryType)type;

- (void)loadMoreHistorySucceedWithData:(NSDictionary *)data type:(KTCBrowseHistoryType)type;

- (void)loadMoreHistoryFailedWithError:(NSError *)error type:(KTCBrowseHistoryType)type;

- (void)parseLoadResult:(NSDictionary *)data type:(KTCBrowseHistoryType)type;

@end

@implementation KTCBrowseHistoryManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serviceResultArray = [[NSMutableArray alloc] init];
        self.storeResultArray = [[NSMutableArray alloc] init];
        self.pageIndex = 1;
    }
    return self;
}

+ (instancetype)sharedManager {
    static dispatch_once_t token = 0;
    
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCBrowseHistoryManager alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark Private methods

- (void)clearDataForType:(KTCBrowseHistoryType)type {
    switch (type) {
        case KTCBrowseHistoryTypeService:
        {
            [self.serviceResultArray removeAllObjects];
        }
            break;
        case KTCBrowseHistoryTypeStore:
        {
            [self.storeResultArray removeAllObjects];
        }
        default:
            break;
    }
}

- (void)loadHistorySucceedWithData:(NSDictionary *)data type:(KTCBrowseHistoryType)type {
    [self parseLoadResult:data type:type];
}

- (void)loadHistoryFailedWithError:(NSError *)error type:(KTCBrowseHistoryType)type {
    [self parseLoadResult:nil type:type];
}

- (void)loadMoreHistorySucceedWithData:(NSDictionary *)data type:(KTCBrowseHistoryType)type {
    self.pageIndex ++;
    [self parseLoadResult:data type:type];
}

- (void)loadMoreHistoryFailedWithError:(NSError *)error type:(KTCBrowseHistoryType)type {
    [self parseLoadResult:nil type:type];
}

- (void)parseLoadResult:(NSDictionary *)data type:(KTCBrowseHistoryType)type {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *dataArray = [data objectForKey:@"data"];
    if ([dataArray isKindOfClass:[NSArray class]]) {
        switch (type) {
            case KTCBrowseHistoryTypeService:
            {
                for (NSDictionary *singleElem in dataArray) {
                    BrowseHistoryServiceListItemModel *model = [[BrowseHistoryServiceListItemModel alloc] initWithRawData:singleElem];
                    if (model) {
                        [self.serviceResultArray addObject:model];
                    }
                }
                return;
            }
                break;
            case KTCBrowseHistoryTypeStore:
            {
                for (NSDictionary *singleElem in dataArray) {
                    BrowseHistoryStoreListItemModel *model = [[BrowseHistoryStoreListItemModel alloc] initWithRawData:singleElem];
                    if (model) {
                        [self.storeResultArray addObject:model];
                    }
                }
                return;
            }
            default:
                break;
        }
    }
}

#pragma mark Public methods

- (void)getUserBrowseHistoryWithType:(KTCBrowseHistoryType)type needMore:(BOOL)need succeed:(void (^)(NSArray *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadHistoryRequest) {
        self.loadHistoryRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_BROWSE_RECORD"];
    } else {
        [self.loadHistoryRequest cancel];
    }
    NSUInteger index = 0;
    if (need) {
        index = self.pageIndex + 1;
    } else {
        [self clearDataForType:type];
        index = self.pageIndex = 1;
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInteger:type], @"type",
                           [NSNumber numberWithInteger:index], @"page",
                           [NSNumber numberWithInteger:PageSize], @"pagecount", nil];
    
    __weak KTCBrowseHistoryManager *weakSelf = self;
    [weakSelf.loadHistoryRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (need) {
            [weakSelf loadMoreHistorySucceedWithData:responseData type:type];
        } else {
            [weakSelf loadHistorySucceedWithData:responseData type:type];
        }
        if (succeed) {
            succeed([weakSelf resultForType:type]);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (need) {
            [weakSelf loadMoreHistoryFailedWithError:error type:type];
        } else {
            [weakSelf loadHistoryFailedWithError:error type:type];
        }
        if (failure) {
            failure(error);
        }
    }];
}


- (void)stopGettingHistory {
    [self.loadHistoryRequest cancel];
}

- (NSArray *)resultForType:(KTCBrowseHistoryType)type {
    switch (type) {
        case KTCBrowseHistoryTypeService:
        {
            return [NSArray arrayWithArray:self.serviceResultArray];
        }
            break;
        case KTCBrowseHistoryTypeStore:
        {
            return [NSArray arrayWithArray:self.storeResultArray];
        }
        default:
            break;
    }
    return nil;
}

@end
