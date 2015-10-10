//
//  HomeElementBaseModel.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"

@implementation HomeElementBaseModel

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if (!data || [data count] == 0 || ![data isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        [self parseHomeData:data];
    }
    return self;
}

- (void)parseHomeData:(NSDictionary *)data {
    
    self.imageUrl = [NSURL URLWithString:[data objectForKey:@"imgUrl"]];
    
    //跳转目的地
    HomeSegueDestination segueDestination = (HomeSegueDestination)[[data objectForKey:@"linkType"] integerValue];
    
    self.segueModel = [[HomeSegueModel alloc] initWithDestination:segueDestination paramRawData:[data objectForKey:@"params"]];
}

@end
