//
//  NewsViewModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/24/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsViewModel.h"
#import "NewsRecommendListViewModel.h"
#import "NewsListViewModel.h"

@interface NewsViewModel ()

@property (nonatomic, weak) NewsView *view;

@property (nonatomic, strong) NewsRecommendListViewModel *recommendListViewModel;

@property (nonatomic, strong) NewsListViewModel *listViewModel;

@end

@implementation NewsViewModel

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.view = (NewsView *)view;
        self.recommendListViewModel = [[NewsRecommendListViewModel alloc] initWithView:self.view.recommendListView];
        self.listViewModel = [[NewsListViewModel alloc] initWithView:self.view.newsListView];
    }
    return self;
}

- (void)setCurrentNewsTagIndex:(NSUInteger)currentNewsTagIndex {
    _currentNewsTagIndex = currentNewsTagIndex;
    self.listViewModel.currentTagIndex = currentNewsTagIndex;
    if ([[self.listViewModel currentResultArray] count] == 0) {
        [self.listViewModel startUpdateDataWithNewsTagIndex:self.currentNewsTagIndex];
    }
}

- (void)refreshNewsWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index {
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel startUpdateDataWithSucceed:nil failure:nil];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listViewModel startUpdateDataWithNewsTagIndex:index];
        }
        default:
            break;
    }
}

- (void)getMoreNewsWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index {
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel getMoreRecommendNewsWithSucceed:nil failure:nil];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listViewModel getMoreDataWithNewsTagIndex:index];
        }
        default:
            break;
    }
}

- (void)resetNewsViewWithViewTag:(NewsViewTag)viewTag newsTagIndex:(NSUInteger)index {
    self.currentViewTag = viewTag;
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel stopUpdateData];
            if ([self.recommendListViewModel.resultListItems count] == 0) {
                [self.recommendListViewModel startUpdateDataWithSucceed:nil failure:nil];
            }
        }
            break;
        case NewsViewTagMore:
        {
            _currentNewsTagIndex = index;
            [self.listViewModel resetResultWithNewsTagIndex:index];
        }
        default:
            break;
    }
}

- (void)activateNewsListViewWithTagType:(NSInteger)type tagId:(NSString *)tagId {
    self.currentViewTag = NewsViewTagMore;
    self.listViewModel.currentTagType = type;
    self.listViewModel.preselectedTagId = tagId;
    _currentNewsTagIndex = [self.listViewModel resetResultWithNewsTagId:tagId];
}

- (NSArray *)resultListItemsWithViewTag:(NewsViewTag)viewTag {
    NSArray *array = nil;
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            array = [self.recommendListViewModel resultListItems];
        }
            break;
        case NewsViewTagMore:
        {
            array = [self.listViewModel currentResultArray];
        }
        default:
            break;
    }
    return nil;
}

- (NSArray<NewsTagTypeModel *> *)tagTypeModels {
    return self.listViewModel.newsTagTypeModels;
}

- (NSArray<NewsTagItemModel *> *)tagItemModels {
    return [NSArray arrayWithArray:self.listViewModel.newsTagItemModels];
}

- (void)setTagItemModelsWithModel:(NewsTagItemModel *)model {
    [self.listViewModel setTagItemModel:model];
}

- (void)stopUpdateData {
    switch (self.currentViewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel stopUpdateData];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listViewModel stopUpdateData];
        }
        default:
            break;
    }
}

- (NSUInteger)currentTagType {
    return self.listViewModel.currentTagType;
}

@end
