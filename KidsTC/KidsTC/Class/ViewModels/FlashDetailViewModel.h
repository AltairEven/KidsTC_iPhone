//
//  FlashDetailViewModel.h
//  KidsTC
//
//  Created by Altair on 2/29/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "FlashDetailView.h"

@interface FlashDetailViewModel : BaseViewModel

@property (nonatomic, strong, readonly) FlashDetailModel *detailModel;

- (void)startUpdateDataWithServiceId:(NSString *)serviceId channelId:(NSString *)channelId Succeed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)addToSettlementWithBuyCount:(NSUInteger)count
                            storeId:(NSString *)storeId
                            succeed:(void (^)(NSDictionary *data))succeed
                            failure:(void (^)(NSError *error))failure;

- (void)addOrRemoveFavouriteWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)resetMoreInfoViewWithViewTag:(ServiceDetailMoreInfoViewTag)viewTag;

@end
