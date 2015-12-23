//
//  HomeViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "HomeView.h"

extern NSString *const kHomeViewDataFinishLoadingNotification;

@interface HomeViewModel : BaseViewModel

@property (nonatomic, strong) HomeModel *homeModel;

- (void)refreshHomeDataWithSysNo:(NSString *)sysNo succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)refreshHomeDataWithSucceed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)getCustomerRecommendWithSucceed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (NSArray *)sectionModelsArray;

@end
