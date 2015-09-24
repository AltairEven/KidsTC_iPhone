//
//  HomeTwoColumnCellModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/14/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "HomeContentCellModel.h"
#import "HomeTwoColumnElement.h"

@interface HomeTwoColumnCellModel : HomeContentCellModel

@property (nonatomic, strong) NSArray *twoColumnElementsArray;

- (NSArray *)imageUrlsArray;

@end
