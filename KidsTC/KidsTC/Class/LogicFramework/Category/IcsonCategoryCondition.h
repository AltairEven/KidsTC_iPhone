//
//  IcsonCategoryCondition.h
//  ICSON
//
//  Created by 钱烨 on 3/30/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define ICKEY_CONDITIONITEM         (@"conditionItem")
#define ICKEY_CONDITIONKEY          (@"key")
#define ICKEY_CONDITIONCATEGORY     (@"category")


extern NSString *const kCategoryConditionKeyPath;
extern NSString *const kCategoryConditionKeyOption;
extern NSString *const kCategoryConditionKeyAreaCode;
extern NSString *const kCategoryConditionKeyQ;
extern NSString *const kCategoryConditionKeyClassId;
extern NSString *const kCategoryConditionKeySort;
extern NSString *const kCategoryConditionKeyP;
extern NSString *const kCategoryConditionKeyPP;
extern NSString *const kCategoryConditionKeyPrice;

@class IcsonBaseCategory;

@interface IcsonCategoryCondition : NSManagedObject

@property (nonatomic, retain) NSString * conditionItem;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) IcsonBaseCategory *category;

/*
 *brief:IcsonCategoryCondition实例化方法
 *return:返回IcsonCategoryCondition实例，无效则为nil
 */
+ (instancetype)conditionInstance;

/*
 *brief:根据类目搜索condition的index，获得相应的key
 *param:类目搜索condition的index
 *return:返回相应的key，没有则为@""
 */
+ (NSString *)getConditionKeyForConditionIndex:(NSUInteger)index;

@end
