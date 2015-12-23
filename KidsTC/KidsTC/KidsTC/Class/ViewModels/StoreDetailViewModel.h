//
//  StoreDetailViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "StoreDetailView.h"

@interface StoreDetailViewModel : BaseViewModel

@property (nonatomic, strong, readonly) StoreDetailModel *detailModel;

- (void)startUpdateDataWithStoreId:(NSString *)storeId succeed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)addOrRemoveFavouriteWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

@end
