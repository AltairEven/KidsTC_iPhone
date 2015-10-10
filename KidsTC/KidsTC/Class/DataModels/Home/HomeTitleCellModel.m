//
//  HomeTitleCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeTitleCellModel.h"

@implementation HomeTitleCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if (!data || [data count] == 0 || ![data isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        [self parseRawData:data];
    }
    return self;
}

- (void)parseRawData:(NSDictionary *)data {
    self.mainTitle = [data objectForKey:@"name"];
    
    HomeSegueDestination destination = (HomeSegueDestination)[[data objectForKey:@"linkType"] integerValue];
    
    self.segueModel = [[HomeSegueModel alloc] initWithDestination:destination paramRawData:[data objectForKey:@"params"]];
}

- (CGFloat)cellHeight {
    return 0;
}

@end
