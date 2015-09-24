//
//  HomeTimeBuyModel.m
//  ICSON
//
//  Created by 钱烨 on 4/15/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeTimeBuyModel.h"

NSString *const kHomeTimeBuyQiangModel = @"qiangModel";
NSString *const kHomeTimeBuyTuanModel = @"tuanModel";
NSString *const kHomeTimeBuyMarketModel = @"marketModel";

@implementation HomeTimeBuyModel

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    //活动ID
    NSArray *channels = [data objectForKey:@"channels"];
    if (channels && [channels count] > 0) {
        NSDictionary *timeBuyDic = [channels objectAtIndex:0];
        self.segueDestination = [[timeBuyDic objectForKey:@"mod"] integerValue];
        NSString *picUrl = [timeBuyDic objectForKey:@"picUrl"];
        self.imageName = [picUrl substringFromIndex:[picUrl rangeOfString:@"local://"].length];
        //title
        self.title = [timeBuyDic objectForKey:@"title"];
        //description
        self.descriptionText = [timeBuyDic objectForKey:@"promotion"];
        //time
        self.time = [timeBuyDic objectForKey:@"hint"];
    }
    
}

@end
