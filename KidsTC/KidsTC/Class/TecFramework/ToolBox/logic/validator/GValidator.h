//
//  Validator.h
//  iphone51buy
//
//  Created by icson apple on 12-4-27.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	GCHAR_TYPE_CHN = 1 << 0,
	GCHAR_TYPE_EN = 1 << 1,
	GCHAR_TYPE_NUM = 1 << 2,
} GCHAR_TYPE;

@protocol GValidatorDelegate <NSObject>

- (BOOL)validate;
- (NSError *)lastError;

@end

@interface GValidator : NSObject

+ (BOOL)checkZip:(NSString *)zip;
+ (BOOL)checkMobilePhone:(NSString *)mobile;
+ (BOOL)checkTel:(NSString *)tel;
+ (BOOL)checkChars:(NSString *)string charType:(NSInteger)_charType;
@end
