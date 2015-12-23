//
//  BrowseHistoryStoreListItemModel.m
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BrowseHistoryStoreListItemModel.h"

@implementation BrowseHistoryStoreListItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"rSysNo"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"rSysNo"]];
        }
        self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
        self.name = [data objectForKey:@"title"];
        self.bizZone = [data objectForKey:@"desc"];
    }
    return self;
}

@end
