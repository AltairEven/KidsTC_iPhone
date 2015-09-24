//
//  HomeNormalTitleCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeNormalTitleCellModel.h"

@implementation HomeNormalTitleCellModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    self = [super initWithRawData:data];
    if (self) {
        self.type = HomeTitleCellTypeNormalTitle;
        cellHeight = 44;
    }
    return self;
}


- (CGFloat)cellHeight {
    return cellHeight;
}

@end
