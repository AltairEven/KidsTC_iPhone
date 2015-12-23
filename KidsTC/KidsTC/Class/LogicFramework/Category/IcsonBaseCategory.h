//
//  IcsonBaseCategory.h
//  ICSON
//
//  Created by 钱烨 on 2/27/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, CategoryLevel) {
    CategoryLevel1 = 1,
    CategoryLevel2,
    CategoryLevel3
};

#define ICKEY_ID            (@"identifier")
#define ICKEY_NAME          (@"name")
#define ICKEY_TYPE          (@"type")
#define ICKEY_PARENTID      (@"parentId")
#define ICKEY_URL      (@"url")

@class IcsonCategoryCondition;

@interface IcsonBaseCategory : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *conditions;


/*
 *brief:根据类目级别实例化
 *param:类目级别
 *return:返回指定级别存储实例
 */
+ (instancetype)categoryInstanceWithLevel:(CategoryLevel)level;

/*
 *brief:获取不同类目级别的存储实例名称
 *param:类目级别
 *return:返回类目名称
 */
+ (NSString *)getEntityNameWithLevel:(CategoryLevel)level;


/*
 *brief:获取coredata操作context
 *return:返回context
 */
+ (NSManagedObjectContext *)getManagedObjectContext;

/*
 *brief:重设coredata操作的context
 *return:void
 */
+ (void)resetManagedObjectContext;

- (NSArray *)nextLevel;

@end

@interface IcsonBaseCategory (CoreDataGeneratedAccessors)

- (void)addConditionsObject:(IcsonCategoryCondition *)value;
- (void)removeConditionsObject:(IcsonCategoryCondition *)value;
- (void)addConditions:(NSSet *)values;
- (void)removeConditions:(NSSet *)values;

@end
