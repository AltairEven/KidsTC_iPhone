//
//  HomeViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeViewModel.h"

static NSString *kLocalFileName = @"home.plist";

static NSString *kLocalCacheDate = @"localSaveDate";

NSString *const kHomeViewDataFinishLoadingNotification = @"kHomeViewDataFinishLoadingNotification";

#define LOCAL_CACHE_TIME (100)

@interface HomeViewModel () <HomeViewDataSource>

@property (nonatomic, weak) HomeView *view;

@property (nonatomic, strong) HttpRequestClient *loadHomeDataRequest;

@property (nonatomic, strong) HttpRequestClient *loadCustomerRecommendRequest;

@property (nonatomic, assign) BOOL updating;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, assign) BOOL alreadyFirstLoaded;

@property (nonatomic, strong) HomeModel *customerRecommendHomeModel;

@property (nonatomic, strong) NSMutableArray *customerRecommendModelsArray;

- (void)loadHomeDataSucceed:(NSDictionary *)data;

- (void)loadHomeDataFailed:(NSError *)error;

- (NSString *)localFilePath;

- (BOOL)writeFileWithRemoteData:(NSDictionary *)data;

- (BOOL)loadLocalFileToModel;

- (void)loadCustomerRecommendSucceed:(NSDictionary *)data;

- (void)loadCustomerRecommendFailed:(NSError *)error;

@end

@implementation HomeViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (HomeView *)view;
        self.view.dataSource = self;
    }
    return self;
}

#pragma mark HomeViewDataSource

- (HomeModel *)homeModelForHomeView:(HomeView *)homeView {
    return self.homeModel;
}

- (HomeModel *)customerRecommendModelForHomeView:(HomeView *)homeView {
    return nil;
}

- (NSArray *)customerRecommendModesArrayForHomeView:(HomeView *)homeView {
    return self.customerRecommendModelsArray;
}

#pragma mark Private methods


- (void)loadHomeDataSucceed:(NSDictionary *)data {
    self.homeModel = [[HomeModel alloc] initWithRawData:data];
    [self.view reloadData];
    [self.view endRefresh];
    [self.view noMoreData:NO];
    [self.view hideLoadMoreFooter:NO];
}

- (void)loadHomeDataFailed:(NSError *)error {
    self.homeModel = nil;
    [self.view endRefresh];
    [self.view noMoreData:YES];
    [self.view hideLoadMoreFooter:YES];
}

- (NSString *)localFilePath {
    NSString *path = FILE_CACHE_PATH(kLocalFileName);
    return path;
}


- (BOOL)writeFileWithRemoteData:(NSDictionary *)data {
    if (!data || [data count] == 0) {
        return NO;
    }
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:data];
    [tempDic setObject:[NSDate date] forKey:kLocalCacheDate];
    [self.lock lock];
    BOOL bWrite = [tempDic writeToFile:[self localFilePath] atomically:NO];
    [self.lock unlock];
    return bWrite;
}


- (BOOL)loadLocalFileToModel {
    if (self.homeModel) {
        //如果已经有内存缓存，则直接return;
        return YES;
    }
    //读取文件缓存
    [self.lock lock];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:[self localFilePath]];
    [self.lock unlock];
    if (data) {
        NSDate *saveDate = [data objectForKey:kLocalCacheDate];
        if (saveDate) {
            NSDate *now = [NSDate date];
            NSTimeInterval interval = [now timeIntervalSinceDate:saveDate];
            if (interval > LOCAL_CACHE_TIME) {
                return NO;
            }
        }
        [self loadHomeDataSucceed:data];
        if (self.homeModel) {
            return YES;
        }
    }
    return NO;
}

- (void)loadCustomerRecommendSucceed:(NSDictionary *)data {
    NSArray *contentArray = [data objectForKey:@"data"];
    if (!self.customerRecommendModelsArray) {
        self.customerRecommendModelsArray = [[NSMutableArray alloc] init];
    }
    if (contentArray && [contentArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *singleSection in contentArray) {
            HomeSectionModel *model = [[HomeSectionModel alloc] initWithRawData:singleSection];
            if (model) {
                [self.customerRecommendModelsArray addObject:model];
            }
        }
    }
    [self.view reloadData];
    [self.view noMoreData:NO];
    [self.view endLoadMore];
}

- (void)loadCustomerRecommendFailed:(NSError *)error {
    [self.view noMoreData:YES];
    [self.view endLoadMore];
}

#pragma mark Public methods

- (void)refreshHomeDataWithSysNo:(NSString *)sysNo succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadHomeDataRequest) {
        self.loadHomeDataRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_PAGE_HOME"];
        [self.loadHomeDataRequest setTimeoutSeconds:5];
    }
    [self.loadHomeDataRequest cancel];
    [self.loadCustomerRecommendRequest cancel];
    [self.customerRecommendModelsArray removeAllObjects];
    self.updating = YES;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:sysNo, @"id", @"0", @"type", nil];
    __weak HomeViewModel *weakSelf = self;
    [weakSelf.loadHomeDataRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        weakSelf.updating = NO;
        [weakSelf loadHomeDataSucceed:responseData];
        if (!weakSelf.alreadyFirstLoaded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHomeViewDataFinishLoadingNotification object:nil]];
            weakSelf.alreadyFirstLoaded = YES;
        }
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        weakSelf.updating = NO;
        [weakSelf loadHomeDataFailed:error];
        if (!weakSelf.alreadyFirstLoaded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHomeViewDataFinishLoadingNotification object:nil]];
            weakSelf.alreadyFirstLoaded = YES;
        }
        if (failure) {
            failure(error);
        }
    }];
}

- (void)refreshHomeDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadHomeDataRequest) {
        self.loadHomeDataRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_PAGE_HOME"];
        [self.loadHomeDataRequest setTimeoutSeconds:5];
    }
    [self.loadHomeDataRequest cancel];
    [self.loadCustomerRecommendRequest cancel];
    [self.customerRecommendModelsArray removeAllObjects];
    self.updating = YES;
    NSDictionary *param = [NSDictionary dictionaryWithObject:[[KTCUser currentUser].userRole userRoleIdentifierString] forKey:@"type"];
    __weak HomeViewModel *weakSelf = self;
    [weakSelf.loadHomeDataRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        weakSelf.updating = NO;
        [weakSelf loadHomeDataSucceed:responseData];
        if (!weakSelf.alreadyFirstLoaded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHomeViewDataFinishLoadingNotification object:nil]];
            weakSelf.alreadyFirstLoaded = YES;
        }
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        weakSelf.updating = NO;
        [weakSelf loadHomeDataFailed:error];
        if (!weakSelf.alreadyFirstLoaded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHomeViewDataFinishLoadingNotification object:nil]];
            weakSelf.alreadyFirstLoaded = YES;
        }
        if (failure) {
            failure(error);
        }
    }];
}


- (void)getCustomerRecommendWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadCustomerRecommendRequest) {
        self.loadCustomerRecommendRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_PAGE_HOME"];
        [self.loadCustomerRecommendRequest setTimeoutSeconds:5];
    }
    [self.loadHomeDataRequest cancel];
    self.updating = YES;
    __weak HomeViewModel *weakSelf = self;
    [weakSelf.loadCustomerRecommendRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        weakSelf.updating = NO;
        [weakSelf loadCustomerRecommendSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        weakSelf.updating = NO;
        [weakSelf loadCustomerRecommendFailed:error];
    }];
}

- (NSArray *)sectionModelsArray {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.homeModel allSectionModels]];
    [array addObjectsFromArray:self.customerRecommendModelsArray];
    return [NSArray arrayWithArray:array];
}

#pragma mark Super methods


- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([self loadLocalFileToModel]) {
        [self.view reloadData];
        if (!self.alreadyFirstLoaded) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kHomeViewDataFinishLoadingNotification object:nil]];
            self.alreadyFirstLoaded = YES;
        }
        return;
    }
    [self refreshHomeDataWithSucceed:succeed failure:failure];
}

- (void)stopUpdateData {
    [self.loadHomeDataRequest cancel];
    [self.loadCustomerRecommendRequest cancel];
    [self.view endRefresh];
    [self.view endLoadMore];
}

@end
