//
//  HomeCountDownTitleCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeCountDownTitleCellModel.h"

@implementation HomeCountDownTitleCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        self.type = HomeTitleCellTypeCountDownTitle;
        cellHeight = 44;
    }
    return self;
}

- (void)parseRawData:(NSDictionary *)data {
    [super parseRawData:data];
    self.timeLeft = [[data objectForKey:@"remainTime"] integerValue];
}


- (CGFloat)cellHeight {
    return cellHeight;
}

@end
