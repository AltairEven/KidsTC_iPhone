//
//  FavouriteStrategyItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteStrategyItemModel.h"

@implementation FavouriteStrategyItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.title = [data objectForKey:@"title"];
        self.content = [data objectForKey:@"editorWords"];
    }
    return self;
}

@end
