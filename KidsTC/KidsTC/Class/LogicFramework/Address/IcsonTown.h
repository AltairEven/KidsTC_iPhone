//
//  IcsonTown.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AdministrativeDivision.h"

#define ADKEY_COUNTY_TOWN    (@"county")

@class IcsonCounty;

@interface IcsonTown : AdministrativeDivision

@property (nonatomic, retain) IcsonCounty *county;


/*
 *brief:根据匹配类型获取的乡镇
 *param:匹配类型
 *param:匹配数据
 *param:抛出错误信息
 *return:返回匹配的乡镇
 */
+ (IcsonTown *)getTownWithMatchType:(MatchType)type matchData:(id)data andError:(NSError **)error;

@end
