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

- (void)refreshNewsWithViewTag:(NewsViewTag)viewTag Succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure {
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel startUpdateDataWithSucceed:succeed failure:failure];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listViewModel startUpdateDataWithSucceed:succeed failure:failure];
        }
        default:
            break;
    }
}

- (void)getMoreNewsWithViewTag:(NewsViewTag)viewTag Succeed:(void(^)(NSDictionary *data))succeed failure:(void(^)(NSError *error))failure {
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            [self.recommendListViewModel getMoreRecommendNewsWithSucceed:succeed failure:failure];
        }
            break;
        case NewsViewTagMore:
        {
            [self.listViewModel getMoreNewsWithSucceed:succeed failure:failure];
        }
        default:
            break;
    }
}

- (void)resetNewsViewWithViewTag:(NewsViewTag)viewTag {
    [self stopUpdateData];
    self.currentViewTag = viewTag;
    switch (viewTag) {
        case NewsViewTagRecommend:
        {
            if ([self.recommendListViewModel.resultListItems count] == 0) {
                [self.recommendListViewModel startUpdateDataWithSucceed:nil failure:nil];
            }
        }
            break;
        case NewsViewTagMore:
        {
            if ([self.listViewModel.resultListItems count] == 0) {
                [self.listViewModel startUpdateDataWithSucceed:nil failure:nil];
            }
        }
        default:
            break;
    }
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
            array = [self.listViewModel resultListItems];
        }
        default:
            break;
    }
    return nil;
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
    }}

@end
