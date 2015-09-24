//
//  NewsRecommendListModel.m
//  KidsTC
//
//  Created by 钱烨 on 9/23/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "NewsRecommendListModel.h"

@implementation NewsRecommendListModel

- (CGFloat)cellHeight {
    CGFloat height = 0;
    NSUInteger count = [self.cellModelsArray count];
    if (count > 0) {
        height = 150 + (count - 1) * 60;
    }
    
    return height;
}

@end