//
//  IcsonCity.m
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "IcsonCity.h"
#import "IcsonCounty.h"
#import "IcsonProvince.h"
#import "IcsonCountryAD.h"

#define AD_NAME_CITY (@"IcsonCity")


@implementation IcsonCity

@dynamic isMunicipality;
@dynamic countyList;
@dynamic province;


+ (instancetype)ADInstance
{
    NSEntityDescription *description = [NSEntityDescription entityForName:AD_NAME_CITY inManagedObjectContext:[AdministrativeDivision getManagedObjectContext]];
    
    if (description)
    {
        IcsonCity *ad = [[IcsonCity alloc] initWithEntity:description insertIntoManagedObjectContext:[AdministrativeDivision getManagedObjectContext]];
        return ad;
    }
    
    return nil;
}




- (BOOL)isInLocalFile {
    return NO;
}

+ (NSArray *)getADArrayWithError:(NSError *__autoreleasing *)error
{
    //先获取static context
    NSManagedObjectContext *context = [AdministrativeDivision getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];//[NSFetchRequest fetchRequestWithEntityName:name];
    NSEntityDescription *entity = [NSEntityDescription entityForName:AD_NAME_CITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //执行查询操作并返回
    return [context executeFetchRequest:fetchRequest error:error];
}



+ (IcsonCity *)getCityWithMatchType:(MatchType)type matchData:(id)data andError:(NSError *__autoreleasing *)error
{
    if (!data) {
        return nil;
    }
    //先获取static context
    NSManagedObjectContext *context = [AdministrativeDivision getManagedObjectContext];
    
    //初始化fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:AD_NAME_CITY inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //根据匹配类型，创建predicate
    NSPredicate *predicate = nil;
    switch (type) {
        case MatchTypeUniqueId:
        {
            predicate = [NSPredicate predicateWithFormat:@"%K = %@", ADKEY_UNIQUEID, data];
        }
            break;
        case MatchTypeGbAreaId:
        {
            predicate = [NSPredicate predicateWithFormat:@"%K = %@", ADKEY_GBAREAID, data];
        }
            break;
        case MatchTypeName:
        {
            predicate = [NSPredicate predicateWithFormat:@"%K = %@", ADKEY_NAME, data];
        }
            break;
        default:
            break;
    }
    [fetchRequest setPredicate:predicate];
    
    //执行查询操作并返回
    NSArray *array = [context executeFetchRequest:fetchRequest error:error];
    
    if (array && [array count] > 0) {
        return [array objectAtIndex:0];
    }
    
    return nil;
}



- (NSArray *)getNextLevelADWithError:(NSError *__autoreleasing *)error {
    NSArray *next = [self.countyList allObjects];
    
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



- (NSString *)getFullName {
    if (!self.province) {
        return @"";
    }
    NSMutableString *name = [NSMutableString stringWithFormat:@""];
    [name appendString:self.province.name];
    [name appendString:self.name];
    
    return [NSString stringWithString:name];
}


- (NSArray *)getUpperLevelADArrayWithError:(NSError *__autoreleasing *)error {
    NSArray *upper = [self.province.country.provinceList allObjects];
    
    if (upper) {
        upper = [upper sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            //按sort ID升序排列
            AdministrativeDivision *ad1 = obj1;
            AdministrativeDivision *ad2 = obj2;
            return [ad1.sortId compare:ad2.sortId];
        }];
    }
    
    return upper;
}



- (AdministrativeDivision *)getUpperLevelAD {
    return self.province;
}



- (NSNumber *)provinceId {
    return self.province.uniqueId;
}


@end
