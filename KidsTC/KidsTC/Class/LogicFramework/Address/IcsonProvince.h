//
//  IcsonProvince.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AdministrativeDivision.h"

#define ADKEY_ISMUNICIPALITY_PROVINCE    (@"isMunicipality")
#define ADKEY_COUNTRY_PROVINCE    (@"country")

@class IcsonCity, IcsonCountryAD;

@interface IcsonProvince : AdministrativeDivision

@property (nonatomic, retain) NSNumber * isMunicipality;
@property (nonatomic, retain) NSSet *cityList;
@property (nonatomic, retain) IcsonCountryAD *country;


/*
 *brief:根据匹配类型获取的省份
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的省份
 */
+ (IcsonProvince *)getProvinceWithMatchType:(MatchType)type matchData:(id)data andError:(NSError **)error;


@end

@interface IcsonProvince (CoreDataGeneratedAccessors)

- (void)addCityListObject:(IcsonCity *)value;
- (void)removeCityListObject:(IcsonCity *)value;
- (void)addCityList:(NSSet *)values;
- (void)removeCityList:(NSSet *)values;

@end
