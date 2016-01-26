//
//  CheckFirstInstalDataManager.h
//  ICSON
//
//  Created by jiangshiyong on 15/3/19.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//  设定和检查第一次安装

#import <Foundation/Foundation.h>

extern NSString *const kKidsTCIsFirstInstal;

@interface CheckFirstInstalDataManager : NSObject

//设定和检查是否第一次安装
+ (void)setHasLaunchedValue:(BOOL)value;
+ (BOOL)getHasLaunchedValue;

+ (NSString	*)getConfigFilePath;
+ (NSString	*)getDocumentConfigFilePath;
@end
