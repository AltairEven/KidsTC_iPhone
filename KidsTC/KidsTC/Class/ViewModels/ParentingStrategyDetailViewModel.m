//
//  ParentingStrategyDetailViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ParentingStrategyDetailViewModel.h"
#import "KTCFavouriteManager.h"

@interface ParentingStrategyDetailViewModel () <ParentingStrategyDetailViewDataSource>

@property (nonatomic, weak) ParentingStrategyDetailView *view;

@property (nonatomic, strong) HttpRequestClient *loadServiceDetailRequest;

@property (nonatomic, strong) HttpRequestClient *addToSettlementRequest;

- (void)loadDetailSucceed:(NSDictionary *)data;

- (void)loadDetailFailed:(NSError *)error;

@end

@implementation ParentingStrategyDetailViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (ParentingStrategyDetailView *)view;
        self.view.dataSource = self;
        _detailModel = [[ParentingStrategyDetailModel alloc] init];
    }
    return self;
}

#pragma mark ServiceDetailViewDataSource

- (ParentingStrategyDetailModel *)detailModelForParentingStrategyDetailView:(ParentingStrategyDetailView *)detailView {
    return self.detailModel;
}

#pragma mark Private methods

- (void)loadDetailSucceed:(NSDictionary *)data {
    if (![self.detailModel fillWithRawData:[data objectForKey:@"data"]]) {
        _detailModel = nil;
    }
    [self.view reloadData];
}

- (void)loadDetailFailed:(NSError *)error {
    _detailModel = nil;
}

#pragma mark Public methods

- (void)startUpdateDataWithStrategyIdentifier:(NSString *)identifier Succeed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if ([identifier length] == 0) {
        return;
    }
    [self.detailModel setIdentifier:identifier];
    
    if (!self.loadServiceDetailRequest) {
        self.loadServiceDetailRequest = [HttpRequestClient clientWithUrlAliasName:@"STRATEGY_GET_DETAIL"];
        [self.loadServiceDetailRequest setErrorBlock:self.netErrorBlock];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:identifier, @"id", nil];
    
    __weak ParentingStrategyDetailViewModel *weakSelf = self;
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
        if (weakSelf.netErrorBlock) {
            weakSelf.netErrorBlock(error);
        }
    }];
}
- (void)addOrRemoveFavouriteWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    NSString *identifier = self.detailModel.identifier;
    KTCFavouriteType type = KTCFavouriteTypeStrategy;
    __weak ParentingStrategyDetailViewModel *weakSelf = self;
    if (self.detailModel.isFavourite) {
        [[KTCFavouriteManager sharedManager] deleteFavouriteWithIdentifier:identifier type:type succeed:^(NSDictionary *data) {
            [weakSelf.detailModel setIsFavourite:NO];
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
            [weakSelf.detailModel setIsFavourite:YES];
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

@end
