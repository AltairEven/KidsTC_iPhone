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
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dataDic in dataArray) {
        HomeNewsBaseModel *newsModel = [[HomeNewsBaseModel alloc] initWithHomeData:dataDic];
        if (newsModel) {
            [tempArray addObject:newsModel];
        }
    }
    self.newsModels = [NSArray arrayWithArray:tempArray];
}

- (void)setRatio:(CGFloat)ratio {
    [super setRatio:ratio];
}


- (CGFloat)cellHeight {
    cellHeight = cellRatio * SCREEN_WIDTH;
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return self.newsModels;
}

@end
