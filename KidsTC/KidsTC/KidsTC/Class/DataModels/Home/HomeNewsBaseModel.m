//
//  HomeNewsBaseModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeNewsBaseModel.h"

@implementation HomeNewsBaseModel

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super initWithHomeData:data];
    if (self) {
        
    }
    return self;
}


- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    self.title = [data objectForKey:@"title"];
    NSDictionary *articleDic = [data objectForKey:@"articleParam"];
    if ([articleDic isKindOfClass:[NSDictionary class]]) {
        self.isHot = [[articleDic objectForKey:@"isHot"] boolValue];
        self.isRecommend = [[articleDic objectForKey:@"isRecommend"] boolValue];
        self.viewCount = [[articleDic objectForKey:@"viewTimes"] integerValue];
        self.commentCount = [[articleDic objectForKey:@"commentCount"] integerValue];
    }
}

@end
