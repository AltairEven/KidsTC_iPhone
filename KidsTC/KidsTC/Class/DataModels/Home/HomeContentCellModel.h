//
//  HomeContentCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeCellModel.h"
#import "HomeNewsBaseModel.h"

typedef enum {
    HomeContentCellTypeBanner = 1,
    HomeContentCellTypeTwinklingElf = 2,
    HomeContentCellTypeHorizontalList = 3,
    HomeContentCellTypeThree = 4,
    HomeContentCellTypeTwoColumn = 5,
    HomeContentCellTypeNews = 6,
    HomeContentCellTypeImageNews = 7,
    HomeContentCellTypeThreeImageNews = 8,
    HomeContentCellTypeWholeImageNews = 11,
    HomeContentCellTypeNotice = 12,
    HomeContentCellTypeBigImageTwoDesc = 13,
    HomeContentCellTypeTwoThreeFour = 14
}HomeContentCellType;

@interface HomeContentCellModel : HomeCellModel

@property (nonatomic, assign) HomeContentCellType type;

- (instancetype)initWithRawData:(NSArray *)dataArray;

- (void)parseRawData:(NSArray *)dataArray;

- (NSArray *)elementModelsArray;

@end
