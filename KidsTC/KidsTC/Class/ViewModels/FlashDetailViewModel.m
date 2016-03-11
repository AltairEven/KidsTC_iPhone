//
//  FlashDetailViewModel.m
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "FlashDetailViewModel.h"
#import "KTCFavouriteManager.h"

@interface FlashDetailViewModel () <FlashDetailViewDataSource>

@property (nonatomic, weak) FlashDetailView *view;

@property (nonatomic, strong) HttpRequestClient *loadFlashDetailRequest;

@property (nonatomic, strong) HttpRequestClient *loadIntroductionRequest;

@property (nonatomic, strong) HttpRequestClient *addToSettlementRequest;

- (void)loadIntroduction;

- (void)loadIntroductionSucceed:(NSDictionary *)data;

- (void)loadIntroductionFailed:(NSError *)error;

- (BOOL)loadDetailSucceed:(NSDictionary *)data;

- (void)loadDetailFailed:(NSError *)error;

@end

@implementation FlashDetailViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (FlashDetailView *)view;
        self.view.dataSource = self;
        _detailModel = [[FlashDetailModel alloc] init];
    }
    return self;
}

#pragma mark FlashDetailViewDataSource

- (FlashDetailModel *)detailModelForFlashDetailView:(FlashDetailView *)detailView {
    return self.detailModel;
}

#pragma mark Private methods

- (BOOL)loadDetailSucceed:(NSDictionary *)data {
    return [self.detailModel fillWithRawData:[data objectForKey:@"data"]];
}

- (void)loadDetailFailed:(NSError *)error {
    _detailModel = nil;
}

- (void)loadIntroduction {
    
    [self.view setIntroductionUrlString:self.detailModel.introductionUrlString];
    //    if (!self.loadIntroductionRequest) {
    //        self.loadIntroductionRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_GET_DESC"];
    //    }
    //    __weak FlashDetailViewModel *weakSelf = self;
    //    [weakSelf.loadIntroductionRequest startHttpRequestWithParameter:[NSDictionary dictionaryWithObject:self.detailModel.FlashId forKey:@"pid"] success:^(HttpRequestClient *client, NSDictionary *responseData) {
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

- (void)startUpdateDataWithServiceId:(NSString *)FlashId channelId:(NSString *)channelId Succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([FlashId length] == 0) {
        return;
    }
    if ([channelId length] == 0) {
        channelId = @"0";
    }
    [self.detailModel setServiceId:FlashId];
    [self.detailModel setChannelId:channelId];
    
    if (!self.loadFlashDetailRequest) {
        self.loadFlashDetailRequest = [HttpRequestClient clientWithUrlAliasName:@"PRODUCT_GETDETAIL"];
        [self.loadFlashDetailRequest setErrorBlock:self.netErrorBlock];
    }
    NSString *coordinateString = [[GConfig sharedConfig] currentLocationCoordinateString];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:FlashId, @"pid", channelId, @"chid", coordinateString, @"mapaddr", nil];
    
    __weak FlashDetailViewModel *weakSelf = self;
    [weakSelf.loadFlashDetailRequest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        if ([weakSelf loadDetailSucceed:responseData]) {
            if (succeed) {
                succeed(responseData);
            }
        } else {
            NSError *error = [NSError errorWithDomain:@"Flash Detail" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"没有查询到数据" forKey:kErrMsgKey]];
            [weakSelf loadDetailFailed:error];
            if (failure) {
                failure(error);
            }
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
        self.addToSettlementRequest = [HttpRequestClient clientWithUrlAliasName:@"SHOPPINGCART_SET_V2"];
    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.detailModel.serviceId, @"productid", self.detailModel.channelId, @"chid", storeId, @"storeno", [NSNumber numberWithInteger:count], @"buynum", nil];
    
    __weak FlashDetailViewModel *weakSelf = self;
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
    __weak FlashDetailViewModel *weakSelf = self;
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
    [self.loadFlashDetailRequest cancel];
    [self.addToSettlementRequest cancel];
}

@end
