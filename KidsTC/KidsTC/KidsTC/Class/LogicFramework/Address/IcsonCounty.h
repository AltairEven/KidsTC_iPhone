//
//  IcsonCounty.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AdministrativeDivision.h"


#define ADKEY_HASTOWNS    (@"hasTowns")
#define ADKEY_CITY_COUNTY    (@"city")

@class IcsonCity, IcsonTown;

@interface IcsonCounty : AdministrativeDivision

@property (nonatomic, retain) NSNumber * hasTowns;
@property (nonatomic, retain) NSSet *townList;
@property (nonatomic, retain) IcsonCity *city;


/*
 *brief:根据匹配类型获取的区县
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的区县
 */
+ (IcsonCounty *)getCountyWithMatchType:(MatchType)type matchData:(id)data andError:(NSError **)error;


@end

@interface IcsonCounty (CoreDataGeneratedAccessors)

- (void)addTownListObject:(IcsonTown *)value;
- (void)removeTownListObject:(IcsonTown *)value;
- (void)addTownList:(NSSet *)values;
- (void)removeTownList:(NSSet *)values;

@end
