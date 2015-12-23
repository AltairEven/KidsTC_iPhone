//
//  IcsonCity.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AdministrativeDivision.h"

#define ADKEY_ISMUNICIPALITY_CITY    (@"isMunicipality")
#define ADKEY_PROVINCE_CITY    (@"province")

@class IcsonCounty, IcsonProvince;

@interface IcsonCity : AdministrativeDivision

@property (nonatomic, retain) NSNumber * isMunicipality;
@property (nonatomic, retain) NSSet *countyList;
@property (nonatomic, retain) IcsonProvince *province;


/*
 *brief:根据匹配类型获取的城市
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的城市
 */
+ (IcsonCity *)getCityWithMatchType:(MatchType)type matchData:(id)data andError:(NSError **)error;

@end

@interface IcsonCity (CoreDataGeneratedAccessors)

- (void)addCountyListObject:(IcsonCounty *)value;
- (void)removeCountyListObject:(IcsonCounty *)value;
- (void)addCountyList:(NSSet *)values;
- (void)removeCountyList:(NSSet *)values;

@end
