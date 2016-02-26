//
//  SearchViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/4/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "SearchViewModel.h"
#import "KTCSearchCondition.h"

@interface SearchViewModel () <KTCSearchViewDataSource>

@property (nonatomic, weak) KTCSearchView *view;

@property (nonatomic, strong) NSMutableDictionary *historySearchDic;

@end

@implementation SearchViewModel

- (instancetype)initWithView:(UIView *)view defaultSearchType:(KTCSearchType)type {
    self = [super initWithView:view];
    if (self) {
        self.view = (KTCSearchView *)view;
        self.view.dataSource = self;
        KTCSearchTypeItem *item1 = [KTCSearchTypeItem itemWithType:KTCSearchTypeService Name:@"服务" image:[UIImage imageNamed:@"bizicon_service_n"]];
        KTCSearchTypeItem *item2 = [KTCSearchTypeItem itemWithType:KTCSearchTypeStore Name:@"门店" image:[UIImage imageNamed:@"bizicon_store_n"]];
        KTCSearchTypeItem *item3 = [KTCSearchTypeItem itemWithType:KTCSearchTypeNews Name:@"知识库" image:[UIImage imageNamed:@"bizicon_news_n"]];
        [self.view setCategoryArray:[NSArray arrayWithObjects:item1, item2, item3, nil]];
        
        self.historySearchDic = [[NSMutableDictionary alloc] init];
        
        if (type != KTCSearchTypeNone) {
            for (NSUInteger index = 0; index < [self.view.categoryArray count]; index ++) {
                KTCSearchTypeItem *item  = [self.view.categoryArray objectAtIndex:index];
                if (item.type == type) {
                    [self.view setCurrentSearchTypeItemIndex:index];
                    break;
                }
            }
        }
    }
    return self;
}

- (void)startUpdateDataWithSucceed:(void (^)(NSDictionary *))succeed failure:(void (^)(NSError *))failure {
}

- (void)stopUpdateData {
}

- (void)setSearchType:(KTCSearchType)searchType {
    _searchType = searchType;
    [self.view reloadData];
}

#pragma KTCSearchViewDataSource

- (NSArray *)hotKeysArrayForKTCSearchView:(KTCSearchView *)searchView {
    NSArray *hotSearchArray = [[KTCSearchService sharedService] hotSearchConditionsOfSearchType:self.searchType];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *hotDic in hotSearchArray) {
        NSString *title = [hotDic objectForKey:kSearchHotKeyName];
        [tempArray addObject:title];
    }
    return [NSArray arrayWithArray:tempArray];
}

- (NSArray *)historiesArrayForKTCSearchView:(KTCSearchView *)searchView {
    return [self searchHistory];
}

#pragma mark Private methods

#pragma mark Public methods

- (void)getSearchHistory {
    if ([self.historySearchDic count] == 0) {
        NSString *filePath = FILE_CACHE_PATH(@"SearchHistory");
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL]) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            if (dic) {
                [self.historySearchDic addEntriesFromDictionary:dic];
            }
        }
    }
    [self.view reloadData];
}

- (void)addSearchHistoryWithType:(KTCSearchType)type keyword:(NSString *)keyword {
    if ([keyword length] == 0) {
        return;
    }
    if (type == KTCSearchTypeService || type == KTCSearchTypeStore || type == KTCSearchTypeNews) {
        NSArray *hisArray = [self.historySearchDic objectForKey:[NSNumber numberWithInteger:type]];
        BOOL alreadyExist = NO;
        if (hisArray && [hisArray indexOfObject:keyword] != NSNotFound) {
            alreadyExist = YES;
        }
        
//        for (NSString *key in [self.historySearchDic allKeys]) {
//            if ([key isEqualToString:keyword] && [[self.historySearchDic objectForKey:key] integerValue] == type) {
//                alreadyExist = YES;
//                break;
//            }
//        }
        if (alreadyExist) {
            return;
        }
        NSMutableArray *tempArray = nil;
        if (hisArray) {
            tempArray = [[NSMutableArray alloc] initWithArray:hisArray];
        } else {
            tempArray = [[NSMutableArray alloc] initWithObjects:keyword, nil];
        }
        [self.historySearchDic setObject:[NSArray arrayWithArray:tempArray] forKey:[NSNumber numberWithInt:type]];
    }
}

- (void)clearSearchHistory {
    [self.historySearchDic removeAllObjects];
    [self updateLocalSearchHistory];
}

- (void)updateLocalSearchHistory {
    NSString *filePath = FILE_CACHE_PATH(@"SearchHistoryNew");
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:self.historySearchDic];
    if (!dic || [dic count] == 0) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        return;
    }
    [dic writeToFile:filePath atomically:NO];
}

- (NSArray *)searchHistory {
    NSDictionary *allHistory = [NSDictionary dictionaryWithDictionary:self.historySearchDic];
    
    NSArray *currentHistory = [allHistory objectForKey:[NSNumber numberWithInteger:self.searchType]];
    
//    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
//    for (NSString *key in [allHistory allKeys]) {
//        NSNumber *type = [allHistory objectForKey:key];
//        if ([type integerValue] == self.searchType) {
//            [tempDic setObject:type forKey:key];
//        }
//    }
    return currentHistory;
}

@end
