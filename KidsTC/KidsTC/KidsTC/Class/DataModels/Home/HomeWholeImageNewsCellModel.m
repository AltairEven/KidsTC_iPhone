//
//  HomeWholeImageNewsCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeWholeImageNewsCellModel.h"

@implementation HomeWholeImageNewsCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeWholeImageNews;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    self.newsModel = [[HomeNewsBaseModel alloc] initWithHomeData:[dataArray firstObject]];
    self.newsModels = [NSArray arrayWithObject:self.newsModel];
}


- (CGFloat)cellHeight {
    cellHeight = self.ratio * SCREEN_WIDTH;
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return [NSArray arrayWithObject:self.newsModel];
}

@end
