//
//  HomeBannerElement.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeBannerElement.h"

@interface HomeBannerElement ()


@end

@implementation HomeBannerElement

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //渠道
    self.channel = [data objectForKey:@"channel"];
}


@end
