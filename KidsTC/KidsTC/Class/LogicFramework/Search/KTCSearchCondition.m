//
//  KTCSearchCondition.m
//  KidsTC
//
//  Created by 钱烨 on 8/7/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCSearchCondition.h"
#import "IcsonBaseCategory.h"
#import "IcsonCategoryCondition.h"

@implementation KTCSearchCondition

+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category {
    return nil;
}

+ (instancetype)conditionFromRawData:(NSDictionary *)data {
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
    for (IcsonCategoryCondition *condition in conditions) {
        if ([condition.key isEqualToString:@"a"]) {
            serviceCondition.age = [KTCAgeItem ageItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
        if ([condition.key isEqualToString:@"c"]) {
            serviceCondition.categoryIdentifier = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"k"]) {
            serviceCondition.keyWord = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"s"]) {
            serviceCondition.area = [KTCAreaItem areaItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
        if ([condition.key isEqualToString:@"st"]) {
            serviceCondition.sortType = (KTCSearchResultServiceSortType)[condition.conditionItem integerValue];
            continue;
        }
    }
    
    return serviceCondition;
}

+ (instancetype)conditionFromRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KTCSearchServiceCondition *condition = [[KTCSearchServiceCondition alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data objectForKey:@"a"]) {
            KTCAgeItem *ageItem = [[KTCAgeItem alloc] init];
            ageItem.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"a"]];
            condition.age = ageItem;
        }
        if ([data objectForKey:@"c"]) {
            condition.categoryIdentifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"c"]];
        }
        if ([data objectForKey:@"k"]) {
            condition.keyWord = [NSString stringWithFormat:@"%@", [data objectForKey:@"k"]];
        }
        if ([data objectForKey:@"s"]) {
            KTCAreaItem *areaItem = [[KTCAreaItem alloc] init];
            areaItem.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"s"]];
            condition.area = areaItem;
        }
        if ([data objectForKey:@"st"]) {
            condition.sortType = (KTCSearchResultServiceSortType)[[data objectForKey:@"st"] integerValue];
        }
    }
    
    return condition;
}

//@property (nonatomic, copy) NSString *keyWord;
//
//@property (nonatomic, strong) KTCAreaItem *area;
//
//@property (nonatomic, strong) KTCAgeItem *age;
//
//@property (nonatomic, copy) NSString *categoryIdentifier;

+ (KTCSearchServiceCondition *)conditionFromStoreCondition:(KTCSearchStoreCondition *)condition {
    if (!condition) {
        return nil;
    }
    KTCSearchServiceCondition *serviceCondition = [[KTCSearchServiceCondition alloc] init];
    serviceCondition.sortType = KTCSearchResultServiceSortTypeSmart;
    serviceCondition.keyWord = condition.keyWord;
    serviceCondition.area = condition.area;
    serviceCondition.age = condition.age;
    serviceCondition.categoryIdentifier = condition.categoryIdentifier;
    
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
    for (IcsonCategoryCondition *condition in conditions) {
        if ([condition.key isEqualToString:@"a"]) {
            storeCondition.age = [KTCAgeItem ageItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
        if ([condition.key isEqualToString:@"c"]) {
            storeCondition.categoryIdentifier = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"k"]) {
            storeCondition.keyWord = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"s"]) {
            storeCondition.area = [KTCAreaItem areaItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
        if ([condition.key isEqualToString:@"st"]) {
            storeCondition.sortType = (KTCSearchResultStoreSortType)[condition.conditionItem integerValue];
            continue;
        }
    }
    
    return storeCondition;
}

+ (instancetype)conditionFromRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KTCSearchStoreCondition *condition = [[KTCSearchStoreCondition alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data objectForKey:@"a"]) {
            KTCAgeItem *ageItem = [[KTCAgeItem alloc] init];
            ageItem.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"a"]];
            condition.age = ageItem;
        }
        if ([data objectForKey:@"c"]) {
            condition.categoryIdentifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"c"]];
        }
        if ([data objectForKey:@"k"]) {
            condition.keyWord = [NSString stringWithFormat:@"%@", [data objectForKey:@"k"]];
        }
        if ([data objectForKey:@"s"]) {
            KTCAreaItem *areaItem = [[KTCAreaItem alloc] init];
            areaItem.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"s"]];
            condition.area = areaItem;
        }
        if ([data objectForKey:@"st"]) {
            condition.sortType = (KTCSearchResultStoreSortType)[[data objectForKey:@"st"] integerValue];
        }
        if ([data objectForKey:@"mapaddr"]) {
            condition.coordinateString = [data objectForKey:@"mapaddr"];
        }
    }
    
    return condition;
}

+ (KTCSearchStoreCondition *)conditionFromServiceCondition:(KTCSearchServiceCondition *)condition {
    if (!condition) {
        return nil;
    }
    KTCSearchStoreCondition *storeCondition = [[KTCSearchStoreCondition alloc] init];
    storeCondition.sortType = KTCSearchResultStoreSortTypeSmart;
    storeCondition.keyWord = condition.keyWord;
    storeCondition.area = condition.area;
    storeCondition.age = condition.age;
    storeCondition.categoryIdentifier = condition.categoryIdentifier;
    storeCondition.coordinateString = [[GConfig sharedConfig] currentLocationCoordinateString];
    
    return storeCondition;
}

@end


@implementation KTCSearchNewsCondition

+ (instancetype)conditionFromCategory:(IcsonBaseCategory *)category {
    if (!category) {
        return nil;
    }
    NSArray *conditions = [category.conditions allObjects];
    KTCSearchNewsCondition *newsCondition = [[KTCSearchNewsCondition alloc] init];
    for (IcsonCategoryCondition *condition in conditions) {
        if ([condition.key isEqualToString:@"a"]) {
            newsCondition.age = [KTCAgeItem ageItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
        if ([condition.key isEqualToString:@"c"]) {
            newsCondition.categoryIdentifier = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"k"]) {
            newsCondition.keyWord = condition.conditionItem;
            continue;
        }
        if ([condition.key isEqualToString:@"s"]) {
            newsCondition.area = [KTCAreaItem areaItemWithName:@"" identifier:condition.conditionItem];
            continue;
        }
//        if ([condition.key isEqualToString:@"st"]) {
//            newsCondition.sortType = (KTCSearchResultStoreSortType)[condition.conditionItem integerValue];
//            continue;
//        }
    }
    
    return newsCondition;
}

+ (instancetype)conditionFromRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    KTCSearchNewsCondition *condition = [[KTCSearchNewsCondition alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data objectForKey:@"a"]) {
            condition.authorId = [NSString stringWithFormat:@"%@", [data objectForKey:@"a"]];
        }
        if ([data objectForKey:@"p"]) {
            condition.populationType = [[data objectForKey:@"p"] integerValue];
        }
        if ([data objectForKey:@"k"]) {
            condition.keyWord = [NSString stringWithFormat:@"%@", [data objectForKey:@"k"]];
        }
        if ([data objectForKey:@"t"]) {
            condition.tagId = [NSString stringWithFormat:@"%@", [data objectForKey:@"t"]];
        }
        if ([data objectForKey:@"ak"]) {
            condition.articleKind = [[data objectForKey:@"ak"] integerValue];
        }
//        if ([data objectForKey:@"mapaddr"]) {
//            condition.coordinateString = [data objectForKey:@"mapaddr"];
//        }
    }
    
    return condition;
}

@end