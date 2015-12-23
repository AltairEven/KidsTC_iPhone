//
//  HomeMoreTitleCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeMoreTitleCellModel.h"

@implementation HomeMoreTitleCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        self.type = HomeTitleCellTypeMoreTitle;
        cellHeight = 44;
    }
    return self;
}


- (void)parseRawData:(NSDictionary *)data {
    [super parseRawData:data];
    self.subTitle = [data objectForKey:@"subName"];
}


- (CGFloat)cellHeight {
    return cellHeight;
}

@end
