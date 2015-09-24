/*
 * Copyright (c) 2012,腾讯科技有限公司
 * All rights reserved.
 *
 * 文件名称：GPageCache.h
 * 文件标识：
 * 摘 要：
 *
 * 当前版本：1.0
 * 作 者：tomtctang
 * 完成日期：12-12-11
 */

#import <Foundation/Foundation.h>
#import "SqliteStorageWrapper.h"

@interface GPageCache : NSObject{

}

+(int)errCode;
+(NSString *)errMsg;
+(BOOL)set:(NSString*)key forValue:(NSString *)value forExpireTime:(int)expireTime;
+(BOOL)set:(NSString*)key forValue:(NSString *)value;
+(NSString *)get:(NSString *)key;
+(BOOL)removeByLeftLike:(NSString *)key;
+(BOOL)remove:(NSString *)key;
	
@end
