//
//  NewsRecommendListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"

@interface NewsRecommendListViewModel : BaseViewModel

- (NSArray *)resultListItems;

- (void)getMoreRecommendNewsWithSucceed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

@end
