//
//  HomeThreeImageNewsCellModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeThreeImageNewsCellModel.h"

@implementation HomeThreeImageNewsCellModel

- (instancetype)initWithRawData:(NSArray *)dataArray {
    self = [super initWithRawData:dataArray];
    if (self) {
        if ([dataArray count] < 3) {
            return nil;
        }
        self.type = HomeContentCellTypeThreeImageNews;
    }
    return self;
}

- (void)parseRawData:(NSArray *)dataArray {
    [super parseRawData:dataArray];
    self.firstElement = [[HomeThreeImageNewsElement alloc] initWithHomeData:[dataArray objectAtIndex:0]];
    self.secondeElement = [[HomeThreeImageNewsElement alloc] initWithHomeData:[dataArray objectAtIndex:1]];
    self.thirdElement = [[HomeThreeImageNewsElement alloc] initWithHomeData:[dataArray objectAtIndex:2]];
}


- (CGFloat)cellHeight {
    cellHeight = self.ratio * (SCREEN_WIDTH / 3);
    return cellHeight;
}

@end


@implementation HomeThreeImageNewsElement

@end
