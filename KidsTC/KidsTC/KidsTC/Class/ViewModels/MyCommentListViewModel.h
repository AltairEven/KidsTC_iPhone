//
//  MyCommentListViewModel.h
//  KidsTC
//
//  Created by Altair on 12/1/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "MyCommentListView.h"
#import "MyCommentListItemModel.h"

@interface MyCommentListViewModel : BaseViewModel

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (NSArray *)resultArray;

@end
