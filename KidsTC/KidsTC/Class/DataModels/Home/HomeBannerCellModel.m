//
//  HomeBannerCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 7/22/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeBannerCellModel.h"

@implementation HomeBannerCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeBanner;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeBanner *item = [[HomeBanner alloc] initWithHomeData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
    }
    self.homeBannersArray = [NSArray arrayWithArray:tempArray];
}


- (CGFloat)cellHeight {
    cellHeight = self.ratio * SCREEN_WIDTH;
    return cellHeight;
}

- (NSArray *)imageUrlsArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (HomeBanner *singleEle in self.homeBannersArray) {
        if (singleEle.imageUrl) {
            [tempArray addObject:singleEle.imageUrl];
        }
    }
    return [NSArray arrayWithArray:tempArray];
}

- (NSArray *)elementModelsArray {
    return self.homeBannersArray;
}

@end

@implementation HomeBanner

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
}

@end
