//
//  FavouriteServiceItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "FavouriteServiceItemModel.h"

@implementation FavouriteServiceItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"serveId"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"serveId"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"channelId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgurl"]];
        self.name = [data objectForKey:@"serveName"];
        self.starNumber = [[data objectForKey:@"level"] integerValue];
        self.price = [[data objectForKey:@"price"] floatValue];
    }
    return self;
}

@end
