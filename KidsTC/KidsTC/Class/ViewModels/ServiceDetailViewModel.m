//
//  ServiceDetailViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailViewModel.h"
#import "KTCFavouriteManager.h"

@interface ServiceDetailViewModel () <ServiceDetailViewDataSource>

@property (nonatomic, weak) ServiceDetailView *view;

@property (nonatomic, strong) HttpRequestClient *loadServiceDetailRequest;

@property (nonatomic, strong) HttpRequestClient *loadIntroductionRequest;

@property (nonatomic, strong) HttpRequestClient *addToSettlementRequest;

- (void)loadIntroduction;

- (void)loadIntroductionSucceed:(NSDictionary *)data;

- (void)loadIntroductionFailed:(NSError *)error;

- (void)loadDetailSucceed:(NSDictionary *)data;

- (void)loadDetailFailed:(NSError *)error;

@end

@implementation ServiceDetailViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ServiceDetailView *)view;
        self.view.dataSource = self;
        _detailModel = [[ServiceDetailModel alloc] init];
    }
    return self;
}

#pragma mark ServiceDetailViewDataSource

- (ServiceDetailModel *)detailModelForServiceDetailView:(ServiceDetailView *)detailView {
    return self.detailModel;
}

#pragma mark Private methods

- (void)loadDetailSucceed:(NSDictionary *)data {
    [self.detailModel fillWithRawData:[data objectForKey:@"data"]];
}

- (void)loadDetailFailed:(NSError *)error {
}

- (void)loadIntroduction {
    
    [self.view setIntroductionUrlString:self.detailModel.introductionUrlString];
//    if (!self.loadIntroductionRequest) {
//        self.loadIntroductionRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_GET_DESC"];
//    }
//    __weak ServiceDetailViewModel *weakSelf = self;
//    [weakSelf.loadIntroductionRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithObject:self.detailModel.serviceId forKey:@"pid"] success:^(HttpRequestClient *client, NSDictionary *responseData) {
//        [weakSelf loadIntroductionSucceed:responseData];
//    } failure:^(HttpRequestClient *client, NSError *error) {
//        [weakSelf loadIntroductionFailed:error];
//    }];
}

- (void)loadIntroductionSucceed:(NSDictionary *)data {
    NSString *htmlString = [data objectForKey:@"data"];
    if ([htmlString isKindOfClass:[NSString class]]) {
        if ([htmlString length] > 0) {
        }
    }
}

- (void)loadIntroductionFailed:(NSError *)error {
    
}

#pragma mark Public methods

- (void)startUpdateDataWithServiceId:(NSString *)serviceId channelId:(NSString *)channelId Succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([serviceId length] == 0) {
        return;
    }
    if ([channelId length] == 0) {
        channelId = @"0";
    }
    [self.detailModel setServiceId:serviceId];
    [self.detailModel setChannelId:channelId];
    
    if (!self.loadServiceDetailRequest) {
        self.loadServiceDetailRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_GETDETAIL"];
        [self.loadServiceDetailRequest setErrorBlock:self.netErrorBlock];
    }
    NSString *coordinateString = [[GConfig sharedConfig] currentLocationCoordinateString];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:serviceId, @"pid", channelId, @"chid", coordinateString, @"mapaddr", nil];
    
    __weak ServiceDetailViewModel *weakSelf = self;
    [weakSelf.loadServiceDetailRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadDetailSucceed:responseData];
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadDetailFailed:error];
        if (failure) {
            failure(error);
        }
    }];
}


- (void)addToSettlementWithBuyCount:(NSUInteger)count storeId:(NSString *)storeId succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([storeId length] == 0) {
        storeId = @"0";
    }
    
    if (!self.addToSettlementRequest) {
        self.addToSettlementRequest = [HttpRequestClient clientWithUrlAliasName:@"SHOPPINGCART_SET"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.detailModel.serviceId, @"productid", self.detailModel.channelId, @"chid", storeId, @"storeno", [NSNumber numberWithInteger:count], @"buynum", nil];
    
    __weak ServiceDetailViewModel *weakSelf = self;
    [weakSelf.addToSettlementRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if (succeed) {
            succeed(responseData);
        }
    } failure:^(HttpRequestClient *client, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)addOrRemoveFavouriteWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    NSString *identifier = self.detailModel.serviceId;
    KTCFavouriteType type = KTCFavouriteTypeService;
    __weak ServiceDetailViewModel *weakSelf = self;
    if (self.detailModel.isFavourate) {
        [[KTCFavouriteManager sharedManager] deleteFavouriteWithIdentifier:identifier type:type succeed:^(NSDictionary *data) {
            [weakSelf.detailModel setIsFavourate:NO];
            if (succeed) {
                succeed(data);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    } else {
        [[KTCFavouriteManager sharedManager] addFavouriteWithIdentifier:identifier type:type succeed:^(NSDictionary *data) {
            [weakSelf.detailModel setIsFavourate:YES];
            if (succeed) {
                succeed(data);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}



- (void)resetMoreInfoViewWithViewTag:(ServiceDetailMoreInfoViewTag)viewTag {
    if (viewTag == ServiceDetailMoreInfoViewTagIntroduction) {
        [self loadIntroduction];
    }
}

#pragma mark Super methods

- (void)stopUpdateData {
    [self.loadServiceDetailRequest cancel];
    [self.addToSettlementRequest cancel];
}


@end
