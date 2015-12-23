//
//  IcsonCountryAD.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AdministrativeDivision.h"



#define AD_NAME_COUNTRYAD (@"IcsonCountryAD")

#define ADKEY_MD5    (@"md5")

@class IcsonProvince;

@interface IcsonCountryAD : AdministrativeDivision

@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSSet *provinceList;

/*
 *brief:获取本地地址md5
 *return:md5字符串
 */
+ (NSString *)getLocalMd5String;


/*
 *brief:解析并存储从服务端下载的地址列表数据
 *param:数据字典，包括地址信息(fullDistrict)和md5;
 *param:抛出错误信息
 *return:void
 */
+ (void)parseAndSaveServerData:(NSDictionary *)dataDic withError:(NSError **)error;

@end

@interface IcsonCountryAD (CoreDataGeneratedAccessors)

- (void)addProvinceListObject:(IcsonProvince *)value;
- (void)removeProvinceListObject:(IcsonProvince *)value;
- (void)addProvinceList:(NSSet *)values;
- (void)removeProvinceList:(NSSet *)values;

@end
