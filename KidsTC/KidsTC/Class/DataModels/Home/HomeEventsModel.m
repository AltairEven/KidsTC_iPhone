//
//  HomeEventsModel.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeEventsModel.h"

@interface HomeEventsModel ()

- (void)parseHomeData:(NSDictionary *)data;

@end

@implementation HomeEventsModel

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if (!data || [data count] == 0) {
            return nil;
        }
        [self parseHomeData:data];
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    self.title = [data objectForKey:@"title"];
    
    NSArray *eventsArray = [data objectForKey:@"list"];
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    for (NSDictionary *eventDic in eventsArray) {
        HomeEventItem *item = [[HomeEventItem alloc] initWithHomeData:eventDic];
        if (item) {
            [tempItems addObject:item];
        }
    }
    self.eventItemsArray = [NSArray arrayWithArray:tempItems];
    self.eventItemsArray = [HomeElementBaseModel sortWithArray:self.eventItemsArray];
}


@end
