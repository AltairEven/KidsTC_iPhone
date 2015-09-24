//
//  HomeTimeQiangElement.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeTimeQiangElement.h"

@implementation HomeTimeQiangElement

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //标题
    self.price = [[data objectForKey:@"price"] floatValue];
}

@end
