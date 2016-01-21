//
//  StoreRelatedStrategyModel.m
//  KidsTC
//
//  Created by Altair on 1/20/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import "StoreRelatedStrategyModel.h"

@implementation StoreRelatedStrategyModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"strategySysNo"]) {
            self.strategyId = [NSString stringWithFormat:@"%@", [data objectForKey:@"strategySysNo"]];
        }
        NSArray *array = [data objectForKey:@"images"];
        self.imageUrl = [NSURL URLWithString:[array lastObject]];
        self.title = [data objectForKey:@"title"];
        self.author = [data objectForKey:@"author"];
        self.viewCount = [[data objectForKey:@"viewCount"] integerValue];
        self.commentCount = [[data objectForKey:@"commentCount"] integerValue];
        self.brief = [data objectForKey:@"simplyDesc"];
        self.isHot = [[data objectForKey:@"isHot"] boolValue];
        self.isRecommend = [[data objectForKey:@"isRecommend"] boolValue];
        self.tagNames = [data objectForKey:@"flagArray"];
        
        self.imageRatio = 0.6;
    }
    return self;
}


- (CGFloat)cellHeight {
    return self.imageRatio * SCREEN_WIDTH;
}

@end
