//
//  NewsListItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "NewsListItemModel.h"

@implementation NewsListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.type = (NewsType)[[data objectForKey:@"articleKind"] integerValue];
        self.title = [data objectForKey:@"title"];
        self.author = [data objectForKey:@"author"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.linkUrl = [data objectForKey:@"linkUrl"];
        self.viewCount = [[data objectForKey:@"viewCount"] integerValue];
        self.commentCount = [[data objectForKey:@"viewCount"] integerValue];
    }
    return self;
}

@end
