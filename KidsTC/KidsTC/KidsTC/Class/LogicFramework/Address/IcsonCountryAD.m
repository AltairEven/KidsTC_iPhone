//
//  IcsonCountryAD.m
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonCountryAD.h"
#import "IcsonProvince.h"
#import "IcsonCity.h"
#import "IcsonCounty.h"
#import "IcsonTown.h"


@implementation IcsonCountryAD

@dynamic md5;
@dynamic provinceList;


+ (instancetype)ADInstance
{
    NSEntityDescription *description = [NSEntityDescription entityForName:AD_NAME_COUNTRYAD inManagedObjectContext:[AdministrativeDivision getManagedObjectContext]];
    
    if (description)
    {
        IcsonCountryAD *ad = [[IcsonCountryAD alloc] initWithEntity:description insertIntoManagedObjectContext:[AdministrativeDivision getManagedObjectContext]];
        return ad;
    }
    
    return nil;
}




- (BOOL)isInLocalFile {
    return NO;
}



+ (NSString *)getLocalMd5String
{
    //先获取static context
    NSManagedObjectContext *context = [AdministrativeDivision getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:AD_NAME_COUNTRYAD inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //执行查询操作并返回
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    
    if (array && [array count] > 0) {
        IcsonCountryAD *country = [array objectAtIndex:0];
        //读取md5值
        return country.md5;
    }
    
    return nil;
}


+ (void)parseAndSaveServerData:(NSDictionary *)dataDic withError:(NSError *__autoreleasing *)error
{
    if (!dataDic || [dataDic count] == 0) {
        //服务端数据为空
        *error = [NSError errorWithDomain:@"ADList" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"No data." forKey:@"errorMsg"]];
        return;
    }
    
    NSDictionary * districtDic = [dataDic objectForKey:@"fullDistrict"];
    if(!districtDic || [districtDic count] == 0)
    {
        //地址数据为空
        *error = [NSError errorWithDomain:@"ADList" code:-1 userInfo:[NSDictionary dictionaryWithObject:@"Unrecognized data." forKey:@"errorMsg"]];
        return;
    }
    
    //此处需要重置存储
    [AdministrativeDivision resetManagedObjectContext];
    
    //创建ADList存储实例
    IcsonCountryAD *countryAD = [IcsonCountryAD ADInstance];
    //赋值md5
    NSString * md5String = [dataDic objectForKey:ADKEY_MD5];
    [countryAD setValue:md5String forKey:ADKEY_MD5];
    [countryAD setValue:[NSNumber numberWithInteger:AdminLevelCountry] forKey:ADKEY_ADMINLEVEL];
    [countryAD setValue:@"中国" forKey:ADKEY_NAME];
    
    NSMutableSet *provinceSet = [[NSMutableSet alloc] init];
    //遍历省份
    for (id pid in districtDic)
    {
        NSDictionary *tmpProvince = [districtDic objectForKey: pid];
        NSString *provinceName = [tmpProvince objectForKey:@"gn"];
        NSNumber *provinceId = [NSNumber numberWithInteger:[[tmpProvince objectForKey:@"y"] integerValue]];
        NSNumber *gbAreaId = [NSNumber numberWithInteger:[[tmpProvince objectForKey:@"g"] integerValue]];
        NSNumber *sortId = [NSNumber numberWithInteger:[[tmpProvince objectForKey:@"g"] integerValue]];
        
        IcsonProvince *singleProvince = [IcsonProvince ADInstance];
        [singleProvince setValue:[NSNumber numberWithInteger:AdminLevelProvince] forKey:ADKEY_ADMINLEVEL];
        [singleProvince setValue:provinceName forKey:ADKEY_NAME];
        [singleProvince setValue:provinceId forKey:ADKEY_UNIQUEID];
        [singleProvince setValue:gbAreaId forKey:ADKEY_GBAREAID];
        [singleProvince setValue:sortId forKey:ADKEY_SORTID];
        [singleProvince setValue:countryAD forKey:ADKEY_COUNTRY_PROVINCE];
        
        NSDictionary*tmpCityList = [tmpProvince objectForKey:@"l"];
        NSDictionary *tmpCity = nil;
        NSMutableSet *citySet = [[NSMutableSet alloc] init];
        
        if (tmpCityList && [tmpCityList count] > 0) {
            //判断是否有二级
            NSInteger gId = [[[tmpCityList allKeys] objectAtIndex:0] integerValue];
            NSInteger judge = gId % 100;
            //任何judge不等于0，说明没有二级地址，直接把省一级赋值给二级，并且为直辖市
            if (judge != 0) {
                [singleProvince setValue:[NSNumber numberWithBool:YES] forKey:ADKEY_ISMUNICIPALITY_PROVINCE];
                
                tmpCity = [NSDictionary dictionaryWithDictionary:tmpProvince];
                tmpCityList = [NSDictionary dictionaryWithObject:tmpCity forKey:[NSString stringWithFormat:@"%ld", (long)[provinceId integerValue]]];    //重置list
            }
        }
        
        
        if (tmpCityList)
        {
            //遍历城市
            for (id cid in tmpCityList)
            {
                tmpCity  = [tmpCityList objectForKey: cid];
                NSString *cityName = [tmpCity objectForKey:@"gn"];
                NSNumber *cityId = [NSNumber numberWithInteger:[[tmpCity objectForKey:@"y"] integerValue]];
                NSNumber *gId = [NSNumber numberWithInteger:[[tmpCity objectForKey:@"g"] integerValue]];
                NSNumber *sId = [NSNumber numberWithInteger:[[tmpCity objectForKey:@"g"] integerValue]];
                
                IcsonCity *singleCity = [IcsonCity ADInstance];
                [singleCity setValue:[NSNumber numberWithInteger:AdminLevelCity] forKey:ADKEY_ADMINLEVEL];
                [singleCity setValue:cityName forKey:ADKEY_NAME];
                [singleCity setValue:cityId forKey:ADKEY_UNIQUEID];
                [singleCity setValue:gId forKey:ADKEY_GBAREAID];
                [singleCity setValue:sId forKey:ADKEY_SORTID];
                [singleCity setValue:singleProvince forKey:ADKEY_PROVINCE_CITY];
                
                
                NSDictionary* tmpCountyList = [tmpCity objectForKey:@"l"];
                NSDictionary *tmpCounty = nil;
                NSMutableSet *countySet = [[NSMutableSet alloc] init];
                if (tmpCountyList)
                {
                    //遍历区县
                    for (id did in tmpCountyList)
                    {
                        tmpCounty = [tmpCountyList objectForKey: did];
                        NSString *countyName = [tmpCounty objectForKey:@"gn"];
                        NSNumber *countyId = [NSNumber numberWithInteger:[[tmpCounty objectForKey:@"y"] integerValue]];
                        NSNumber *gbId = [NSNumber numberWithInteger:[[tmpCounty objectForKey:@"g"] integerValue]];
                        NSNumber *stId = [NSNumber numberWithInteger:[[tmpCounty objectForKey:@"g"] integerValue]];
                        NSNumber *hasTowns = [NSNumber numberWithBool:[[tmpCounty objectForKey:@"d"] boolValue]];
                        
                        IcsonCounty *singleCounty = [IcsonCounty ADInstance];
                        [singleCounty setValue:[NSNumber numberWithInteger:AdminLevelCounty] forKey:ADKEY_ADMINLEVEL];
                        [singleCounty setValue:countyName forKey:ADKEY_NAME];
                        [singleCounty setValue:countyId forKey:ADKEY_UNIQUEID];
                        [singleCounty setValue:gbId forKey:ADKEY_GBAREAID];
                        [singleCounty setValue:stId forKey:ADKEY_SORTID];
                        [singleCounty setValue:hasTowns forKey:ADKEY_HASTOWNS];
                        [singleCounty setValue:singleCity forKey:ADKEY_CITY_COUNTY];
                        
                        //把单个县加入集合
                        [countySet addObject:singleCounty];
                    }
                    //把县集合赋给上级市
                    if ([countySet count] > 0) {
                        [(IcsonCity *)singleCity addCountyList:countySet];
                    }
                }
                //把单个市加入集合
                [citySet addObject:singleCity];
            }
            //把市集合赋给上级省
            if ([citySet count] > 0) {
                [(IcsonProvince*)singleProvince addCityList:citySet];
            }
        }
        //把单个省加入集合
        [provinceSet addObject:singleProvince];
    }
    //把省集合赋给地址列表
    if ([provinceSet count] > 0) {
        [countryAD addProvinceList:provinceSet];
    }
    
    //保存到本地
    [countryAD save];
}



- (NSArray *)getNextLevelADWithError:(NSError *__autoreleasing *)error {
    NSArray *next = [self.provinceList allObjects];
    
    if (next) {
        next = [next sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //按sort ID升序排列
            AdministrativeDivision *ad1 = obj1;
            AdministrativeDivision *ad2 = obj2;
            return [ad1.sortId compare:ad2.sortId];
        }];
    }
    
    return next;
}


- (NSNumber *)provinceId {
    return nil;
}

@end
