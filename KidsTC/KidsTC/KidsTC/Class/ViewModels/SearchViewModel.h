//
//  SearchViewModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "KTCSearchView.h"

extern NSString *const kSearchHotKeyName;
extern NSString *const kSearchHotKeyCondition;

@interface SearchViewModel : BaseViewModel

@property (nonatomic, assign) KTCSearchType searchType;

- (instancetype)initWithView:(UIView *)view defaultSearchType:(KTCSearchType)type;

- (void)getSearchHistory;

- (void)addSearchHistoryWithType:(KTCSearchType)type keyword:(NSString *)keyword;

- (void)clearSearchHistory;

- (void)updateLocalSearchHistory;

- (NSDictionary *)searchHistory;

- (NSArray *)hotSearchArrayOfSearchType:(KTCSearchType)type;

@end
