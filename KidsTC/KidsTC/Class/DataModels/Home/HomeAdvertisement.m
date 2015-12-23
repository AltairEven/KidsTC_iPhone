//
//  HomeAdvertisement.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeAdvertisement.h"

@interface HomeAdvertisement ()

@end

@implementation HomeAdvertisement

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //副标题
    self.subTitle = [data objectForKey:@"subTitle"];
    
    //是否有标题视图
    self.hasCaption = YES;
    if ((!self.title || [self.title length] == 0) && (!self.subTitle || [self.subTitle length] == 0)) {
        self.hasCaption = NO;
    }
}

@end
