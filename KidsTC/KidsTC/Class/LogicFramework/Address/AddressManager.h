//
//  AddressManager.h
//  ICSON
//
//  Created by 钱烨 on 2/7/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IcsonCountryAD.h"
#import "IcsonProvince.h"
#import "IcsonCity.h"
#import "IcsonCounty.h"
#import "IcsonTown.h"

@interface AddressManager : NSObject

@property (nonatomic, readonly) BOOL hasValidData;

/*
 *brief:AddressManager单例
 *return:实例或nil
 */
+ (instancetype)sharedManager;

/*
 *brief:地址数据有效化，会进行网络请求和本地数据存储等操作。调用该方法前，可以先查看hasValidData是否为YES，为YES一般请勿再调用。如果需要刷新地址数据，可以调用。
 *param:成功回调
 *param:失败回调
 *return:void
*/
- (void)validateADListDataWithSuccess:(void(^)(AddressManager *manager))success andFailure:(void(^)(NSError *error))failure;

/*
 *brief:根据匹配类型获取的地址的信息
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的地址信息
 */
- (AdministrativeDivision *)getADInfoWithMatchType:(MatchType)type matchData:(id)data andError:(NSError **)error;

/*
 *brief:根据匹配类型获取的不同级别地址的信息
 *param:地址级别
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的地址信息
 */
- (AdministrativeDivision *)getADInfoWithLevel:(AdminLevel)level matchType:(MatchType)type matchData:(id)data andError:(NSError **)error;

/*
 *brief:获取不同级别地址信息的数组
 *param:地址级别
 *param:抛出错误信息
 *return:返回地址信息的数组
 */
- (NSArray *)getADArrayWithLevel:(AdminLevel)level andError:(NSError **)error;


/*
 *brief:从服务端获取指定区县的下属乡镇地址
 *param:指定区县
 *param:成功回调
 *param:失败回调
 *return:void
 */
- (void)getTownsForCounty:(IcsonCounty *)county fromServerWithSuccess:(void(^)())success failed:(void(^)(NSError *error))failed;


/*
 *brief:从服务端获取指定乡镇的相关信息
 *param:指定乡镇的uniqueId
 *param:成功回调，相关信息
 *param:失败回调
 *return:void
 */
- (void)getADInfoWithTownUniqueId:(NSUInteger)uId fromServerWithSuccess:(void(^)(IcsonTown *town))success failed:(void(^)(NSError *error))failed;


@end
