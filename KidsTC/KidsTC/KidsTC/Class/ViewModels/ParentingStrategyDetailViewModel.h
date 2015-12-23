//
//  ParentingStrategyDetailViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/9/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "ParentingStrategyDetailView.h"

@interface ParentingStrategyDetailViewModel : BaseViewModel

@property (nonatomic, strong, readonly) ParentingStrategyDetailModel *detailModel;

- (void)startUpdateDataWithStrategyIdentifier:(NSString *)identifier Succeed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (void)addOrRemoveFavouriteWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

@end
