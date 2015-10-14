//
//  NewsRecommendListModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendListModel.h"

@interface NewsRecommendListModel ()

- (void)fillWithRawData:(NSDictionary *)data;

@end

@implementation NewsRecommendListModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        [self fillWithRawData:data];
    }
    return self;
}

- (void)fillWithRawData:(NSDictionary *)data {
    self.timeDescription = [data objectForKey:@"lastTime"];
    NSArray *dataArray = [data objectForKey:@"item"];
    if ([dataArray isKindOfClass:[NSArray class]] && [dataArray count] > 0) {
        NSMutableArray *tempContainer = [[NSMutableArray alloc] init];
        for (NSDictionary *singleItem in dataArray) {
            NewsListItemModel *model = [[NewsListItemModel alloc] initWithRawData:singleItem];
            if (model) {
                [tempContainer addObject:model];
            }
        }
        self.cellModelsArray = [NSArray arrayWithArray:tempContainer];
    }
}

- (CGFloat)cellHeight {
    CGFloat height = 0;
    NSUInteger count = [self.cellModelsArray count];
    if (count > 0) {
        height = 40 + ((SCREEN_WIDTH - 40) * 0.6) + (count - 1) * 60;
    }
    
    return height;
}

@end