//
//  KTCSearchCondition.m
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchCondition.h"
#import "IcsonBaseCategory.h"

@implementation KTCSearchCondition

+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category {
    return nil;
}

@end


@implementation KTCSearchServiceCondition
/*
 a,c,k,s,st
*/
+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category {
    if (!category) {
        return nil;
    }
    NSArray *conditions = [category.conditions allObjects];
    KTCSearchServiceCondition *serviceCondition = [[KTCSearchServiceCondition alloc] init];
    for (NSDictionary *conditionDic in conditions) {
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"a"]) {
            serviceCondition.age = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"c"]) {
            serviceCondition.categoryIdentifier = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"k"]) {
            serviceCondition.keyWord = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"s"]) {
            serviceCondition.area = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"st"]) {
            serviceCondition.sortType = (KTCSearchResultServiceSortType)[[[conditionDic allValues] firstObject] integerValue];
        }
    }
    
    return serviceCondition;
}

@end


@implementation KTCSearchStoreCondition
/*
 a,c,k,s,st
 */
+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category {
    if (!category) {
        return nil;
    }
    NSArray *conditions = [category.conditions allObjects];
    KTCSearchStoreCondition *storeCondition = [[KTCSearchStoreCondition alloc] init];
    for (NSDictionary *conditionDic in conditions) {
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"a"]) {
            storeCondition.age = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"c"]) {
            storeCondition.categoryIdentifier = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"k"]) {
            storeCondition.keyWord = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"s"]) {
            storeCondition.area = [[conditionDic allValues] firstObject];
        }
        if ([[[conditionDic allKeys] firstObject] isEqualToString:@"st"]) {
            storeCondition.sortType = (KTCSearchResultStoreSortType)[[[conditionDic allValues] firstObject] integerValue];
        }
    }
    
    return storeCondition;
}

@end