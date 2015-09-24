//
//  HomeBanner.m
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeBanner.h"

@implementation HomeBanner


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    self.segueDestination = HomeViewSegueDestinationH5;
}

@end
