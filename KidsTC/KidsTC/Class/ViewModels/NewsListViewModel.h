//
//  NewsListViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "NewsListView.h"
#import "NewsListItemModel.h"

@interface NewsListViewModel : BaseViewModel

- (NSArray *)resultListItems;

- (void)getMoreNewsWithSucceed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

@end
