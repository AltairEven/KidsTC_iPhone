//
//  IcsonLevel1Category.m
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonLevel1Category.h"
#import "IcsonCategories.h"
#import "IcsonLevel2Category.h"
#import "IcsonCategoryManager.h"

@implementation IcsonLevel1Category

@dynamic level2Categories;
@dynamic categoryList;

- (NSArray *)nextLevel {
    NSArray *next = [self.level2Categories allObjects];
    return [[IcsonCategoryManager sharedManager] sortForIcsonCategoriesArray:next WithLevel:CategoryLevel2];
}

@end
