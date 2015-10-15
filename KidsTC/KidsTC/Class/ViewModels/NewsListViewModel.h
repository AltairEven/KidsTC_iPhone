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

@property (nonatomic, assign) NSUInteger currentTagIndex;

- (NSArray *)currentResultArray;

- (void)startUpdateDataWithNewsTagIndex:(NSUInteger)index;

- (void)getMoreDataWithNewsTagIndex:(NSUInteger)index;

- (void)resetResultWithNewsTagIndex:(NSUInteger)index;

@end
