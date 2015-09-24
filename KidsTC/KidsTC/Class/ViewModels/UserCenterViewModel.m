//
//  UserCenterViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterViewModel.h"

@interface UserCenterViewModel () <UserCenterViewDataSource>

@property (nonatomic, weak) UserCenterView *view;

@property (nonatomic, strong) HttpRequestClient *loadUserCenterInfoRequest;

- (void)loadUserCenterInfoSucceed:(NSDictionary *)data;

- (void)loadUserCenterInfoFailed:(NSError *)error;

@end

@implementation UserCenterViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (UserCenterView *)view;
        self.view.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserCenterModel) name:kUserLogoutNotification object:nil];
    }
    return self;
}

#pragma mark UserCenterViewDataSource


- (UserCenterModel *)modelForUserCenterView:(UserCenterView *)view {
    return self.dataModel;
}

#pragma mark Private methods

- (void)loadUserCenterInfoSucceed:(NSDictionary *)data {
    NSDictionary *userInfo = [data objectForKey:@"data"];
    _dataModel = [[UserCenterModel alloc] initWithRawData:userInfo];
    [self.view reloadData];
}

- (void)loadUserCenterInfoFailed:(NSError *)error {
    _dataModel = nil;
    [self.view reloadData];
}


#pragma mark Super methods

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
    if (!self.loadUserCenterInfoRequest) {
        self.loadUserCenterInfoRequest = [HttpRequestClient clientWithUrlAliasName:@"GET_CENTER_COUNT"];
    }
    [self.loadUserCenterInfoRequest cancel];
    __weak UserCenterViewModel *weakSelf = self;
    [weakSelf.loadUserCenterInfoRequest startHttpRequestWithParameter:nil success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadUserCenterInfoSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadUserCenterInfoFailed:error];
    }];
}

- (void)stopUpdateData {
    [self.loadUserCenterInfoRequest cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserLogoutNotification object:nil];
}

#pragma mark Public methods

- (void)resetUserCenterModel {
    _dataModel = nil;
    if (self.view) {
        [self.view reloadData];
    }
}

@end
