//
//  NewsTagItemModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/15/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsTagItemModel.h"

@implementation NewsTagItemModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"tagid"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"tagid"]];
        }
        self.name = [data objectForKey:@"tagname"];
    }
    return self;
}

@end
