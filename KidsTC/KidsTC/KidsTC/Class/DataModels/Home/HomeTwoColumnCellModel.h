//
//  HomeTwoColumnCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"

@class HomeTwoColumnElement;

@interface HomeTwoColumnCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray<HomeTwoColumnElement *> *twoColumnElementsArray;

- (NSArray *)imageUrlsArray;

@end


@interface HomeTwoColumnElement : HomeElementBaseModel

@end