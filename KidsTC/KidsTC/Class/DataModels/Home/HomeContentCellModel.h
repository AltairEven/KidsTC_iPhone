//
//  HomeContentCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeCellModel.h"

typedef enum {
    HomeContentCellTypeBanner = 1,
    HomeContentCellTypeTwinklingElf,
    HomeContentCellTypeHorizontalList,
    HomeContentCellTypeThree,
    HomeContentCellTypeTwoColumn
}HomeContentCellType;

@interface HomeContentCellModel : HomeCellModel

@property (nonatomic, assign) HomeContentCellType type;

@property (nonatomic, assign) CGFloat ratio;

- (instancetype)initWithRawData:(NSArray *)dataArray;

- (void)parseRawData:(NSArray *)dataArray;

@end
