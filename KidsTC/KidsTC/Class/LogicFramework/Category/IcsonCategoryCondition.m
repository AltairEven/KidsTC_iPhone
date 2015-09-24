//
//  IcsonCategoryCondition.m
//  ICSON
//
//  Created by 钱烨 on 3/30/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonCategoryCondition.h"
#import "IcsonBaseCategory.h"

#define IC_NAME_CONDITION (@"IcsonCategoryCondition")

NSString *const kCategoryConditionKeyPath = @"path";
NSString *const kCategoryConditionKeyOption = @"option";
NSString *const kCategoryConditionKeyAreaCode = @"areacode";
NSString *const kCategoryConditionKeyQ = @"q";
NSString *const kCategoryConditionKeyClassId = @"classid";
NSString *const kCategoryConditionKeySort = @"sort";
NSString *const kCategoryConditionKeyP = @"p";
NSString *const kCategoryConditionKeyPP = @"pp";
NSString *const kCategoryConditionKeyPrice = @"price";


@implementation IcsonCategoryCondition

@dynamic conditionItem;
@dynamic key;
@dynamic category;


+ (instancetype)conditionInstance
{
    NSEntityDescription *description = [NSEntityDescription entityForName:IC_NAME_CONDITION inManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
    
    if (description)
    {
        IcsonCategoryCondition *icc = [[IcsonCategoryCondition alloc] initWithEntity:description insertIntoManagedObjectContext:[IcsonBaseCategory getManagedObjectContext]];
        return icc;
    }
    
    return nil;
}


+ (NSString *)getConditionKeyForConditionIndex:(NSUInteger)index {
    NSString *key = @"";
    switch (index) {
        case 0:
        {
            key = kCategoryConditionKeyPath;
        }
            break;
        case 1:
        {
            key = kCategoryConditionKeyOption;
        }
            break;
        case 2:
        {
            key = kCategoryConditionKeyAreaCode;
        }
            break;
        case 3:
        {
            key = kCategoryConditionKeyQ;
        }
            break;
        case 4:
        {
            key = kCategoryConditionKeyClassId;
        }
            break;
        case 5:
        {
            key = kCategoryConditionKeySort;
        }
            break;
        case 6:
        {
            key = kCategoryConditionKeyP;
        }
            break;
        case 7:
        {
            key = kCategoryConditionKeyPP;
        }
            break;
        case 8:
        {
            key = kCategoryConditionKeyPrice;
        }
            break;
        default:
            
            break;
    }
    
    return key;
}


@end
