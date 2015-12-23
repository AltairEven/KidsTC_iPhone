//
//  AdministrativeDivision.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef NS_ENUM(NSUInteger, AdminLevel) {
    AdminLevelCountry = 0,  //国家级行政区划
    AdminLevelProvince = 1, //省级行政区划
    AdminLevelCity,         //市级行政区划
    AdminLevelCounty,       //县级行政区划
    AdminLevelTown,         //乡级行政区划
    AdminLevelVillage       //村级行政区划
};



#define ADKEY_ADMINLEVEL    (@"adminLevel")
#define ADKEY_NAME          (@"name")
#define ADKEY_UNIQUEID      (@"uniqueId")
#define ADKEY_GBAREAID      (@"gbAreaId")
#define ADKEY_SORTID        (@"sortId")



typedef NS_ENUM(NSUInteger, MatchType) {
    MatchTypeUniqueId,
    MatchTypeGbAreaId,
    MatchTypeName
};


@interface AdministrativeDivision : NSManagedObject

@property (nonatomic, retain) NSNumber * adminLevel;  //行政级别
@property (nonatomic, retain) NSString * name;        //名称
@property (nonatomic, retain) NSNumber * uniqueId;    //唯一ID
@property (nonatomic, retain) NSNumber * gbAreaId;    //国标ID
@property (nonatomic, retain) NSNumber * sortId;     //排序ID

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

/*
 *brief:AdministrativeDivision实例化方法
 *return:返回AdministrativeDivision实例，无效则为nil
 */
+ (instancetype)ADInstance;

/*
 *brief:是否在本地文件中已存在
 *return:是否已存在
 */
- (BOOL)isInLocalFile;

/*
 *brief:保存内存中的信息到本地
 *return:保存成功或失败
 */
- (BOOL)save;

/*
 *brief:获取某个存储实体的信息
 *param:error载体
 *return:AdministrativeDivision子类的实例数组
 */
+ (NSArray *)getADArrayWithError:(NSError **)error;


/*
 *brief:获取下个AD LEVEL存储实体的信息
 *param:error载体
 *return:AdministrativeDivision子类的实例数组
 */
- (NSArray *)getNextLevelADWithError:(NSError **)error;


/*
 *brief:获取区域全名
 *return:全名
 */
- (NSString *)getFullName;


/*
 *brief:获取上级AD LEVEL存储实体的信息
 *param:error载体
 *return:AdministrativeDivision子类的实例数组
 */
- (NSArray *)getUpperLevelADArrayWithError:(NSError **)error;


/*
 *brief:获取上级AD
 *return:上级AD
 */
- (AdministrativeDivision *)getUpperLevelAD;


/*
 *brief:获取省id
 *return:省id
 */
- (NSNumber *)provinceId;


@end
