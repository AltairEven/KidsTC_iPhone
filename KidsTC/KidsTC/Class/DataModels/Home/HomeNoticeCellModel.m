//
//  HomeNoticeCellModel.m
//  KidsTC
//
//  Created by Altair on 12/22/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeNoticeCellModel.h"

@implementation HomeNoticeCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        self.type = HomeContentCellTypeNotice;
        cellHeight = 50;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *singleData in dataArray) {
        HomeNoticeItem *item = [[HomeNoticeItem alloc] initWithHomeData:singleData];
        if (item) {
            [tempArray addObject:item];
        }
        NSString *imageUrlString = [singleData objectForKey:@"imageUrl"];
        if ([imageUrlString isKindOfClass:[NSString class]] && [imageUrlString length] > 0) {
            self.imageUrl = [NSURL URLWithString:imageUrlString];
        }
    }
    self.noticeItemsArray = [NSArray arrayWithArray:tempArray];
}


- (CGFloat)cellHeight {
    return cellHeight;
}

- (NSArray *)elementModelsArray {
    return self.noticeItemsArray;
}

@end

@implementation HomeNoticeItem

- (void)parseHomeData:(NSDictionary *)data {
    [super parseHomeData:data];
    
    self.content = [NSString stringWithFormat:@"%@", [data objectForKey:@"title"]];
}

@end
