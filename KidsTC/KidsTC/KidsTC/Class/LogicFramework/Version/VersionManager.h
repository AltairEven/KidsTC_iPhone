//
//  VersionManager.h
//  ICSON
//
//  Created by 钱烨 on 2/26/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionManager : NSObject

@property (nonatomic, strong, readonly) NSString *version;

/*
 *brief:VersionManager实例
 *return:VersionManager实例
 */
+ (instancetype)sharedManager;

/*
 *brief:检查app版本
 *param:回调target
 *param:成功回调
 *param:失败回调
 *return:void
 */
- (void)checkAppVersionWithSuccess:(void(^)(NSDictionary *result))success failure:(void(^)(NSError *error))failure;

/*
 *brief:前往app store更新
 *return:void
 */
- (void)goToUpdateViaItunes;

@end
