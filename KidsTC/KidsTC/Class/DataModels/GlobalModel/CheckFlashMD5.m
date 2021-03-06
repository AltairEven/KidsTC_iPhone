//
//  CheckFirstInstalDataManager.m
//  ICSON
//
//  Created by jiangshiyong on 15/3/19.
//  Copyright (c) 2015年 肖晓春. All rights reserved.
//

#import "CheckFlashMD5.h"

NSString *const MD5 = @"md5";


@implementation CheckFlashMD5

//设置检查是否第一次安装
+ (void)setMD5Value:(NSString*)value {
    
    NSString *path = [self getDocumentConfigFilePath];
    NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    BOOL isRemoved = [fileManager removeItemAtPath:path error:&error];
    if (isRemoved) {
        NSMutableDictionary *configMutabDic = [NSMutableDictionary dictionaryWithDictionary:configDic];
        [configMutabDic setValue:value forKey:MD5];
        [configMutabDic writeToFile:path atomically:YES];
    }else {
        NSLog(@"remove error %@\n",[error localizedDescription]);
    }
}

+ (NSString*)getMD5Value {
    
    NSString *path = [self getDocumentConfigFilePath];
    NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:path];
    return [configDic objectForKey:MD5];
}

+ (NSString	*)getConfigFilePath {
    
    NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"VersionProperty" ofType:@"plist"];
    return configFilePath;
}

+ (NSString	*)getDocumentConfigFilePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"VersionProperty.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:path];
    if (!isExist) {
        NSString *configFilePath = [self getConfigFilePath];
        NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
        [configDic writeToFile:path atomically:YES];
    }
    return path;
}

@end
