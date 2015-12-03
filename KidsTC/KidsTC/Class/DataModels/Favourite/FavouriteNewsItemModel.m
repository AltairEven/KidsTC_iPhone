//
//  FavouriteNewsItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteNewsItemModel.h"

@implementation FavouriteNewsItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.title = [data objectForKey:@"title"];
        self.authorName = [data objectForKey:@"author"];
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.linkUrlString = [data objectForKey:@"linkUrl"];
    }
    return self;
}

@end
