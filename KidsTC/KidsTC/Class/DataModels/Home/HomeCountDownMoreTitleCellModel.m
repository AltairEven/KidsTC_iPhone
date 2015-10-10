//
//  HomeCountDownMoreTitleCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeCountDownMoreTitleCellModel.h"

@implementation HomeCountDownMoreTitleCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        self.type = HomeTitleCellTypeCountDownMoreTitle;
        cellHeight = 44;
    }
    return self;
}

- (void)parseRawData:(NSDictionary *)data {
    [super parseRawData:data];
    self.timeLeft = [[data objectForKey:@"remainTime"] integerValue];
    self.subTitle = [data objectForKey:@"subName"];
}


- (CGFloat)cellHeight {
    return cellHeight;
}

@end
