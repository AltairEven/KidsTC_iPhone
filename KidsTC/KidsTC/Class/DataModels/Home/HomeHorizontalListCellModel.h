//
//  HomeHorizontalListCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeHorizontalListElement;

@interface HomeHorizontalListCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeHorizontalListElement *> *elementsArray;

@end


@interface HomeHorizontalListElement : HomeElementBaseModel

@property (nonatomic, assign) CGFloat price;

@end