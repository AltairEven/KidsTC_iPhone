//
//  BrowseHistoryServiceListItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BrowseHistoryServiceListItemModel.h"

@implementation BrowseHistoryServiceListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"rSysNo"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"rSysNo"]];
        }
        if ([data objectForKey:@"channelId"]) {
            self.channelId = [NSString stringWithFormat:@"%@", [data objectForKey:@"chId"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.name = [data objectForKey:@"title"];
        self.price = [[data objectForKey:@"desc"] floatValue];
    }
    return self;
}

@end
