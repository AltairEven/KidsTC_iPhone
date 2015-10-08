//
//  NewsViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "NewsView.h"

@interface NewsViewModel : BaseViewModel

@property (nonatomic, assign) NewsViewTag currentViewTag;

- (void)refreshNewsWithViewTag:(NewsViewTag)viewTag Succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)getMoreNewsWithViewTag:(NewsViewTag)viewTag Succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure;

- (void)resetNewsViewWithViewTag:(NewsViewTag)viewTag;

- (NSArray *)resultListItemsWithViewTag:(NewsViewTag)viewTag;

@end
