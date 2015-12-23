//
//  Validator.m
//  iphone51buy
//
//  Created by icson apple on 12-4-27.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "GValidator.h"
#import "RegexKitLite.h"

@implementation GValidator

+ (BOOL)checkZip:(NSString *)zip
{
    if (!zip) {
        return YES;
    }

    if (![zip stringByMatching: @"^\\d{6}$"]) {
        return NO;
    }

    return YES;
}
+ (BOOL)checkMobilePhone:(NSString *)mobile
{
    if (!mobile) {
        return YES;
    }
    
    if (![mobile stringByMatching: @"^((\\(\\d{3}\\))|(\\d{3}\\-))?1\\d{10}$"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)checkTel:(NSString *)tel
{
	if (!tel) {
		return YES;
	}

	if (![tel stringByMatching: @"^([0-9]{3}|0[0-9]{3})-[1-9][0-9]{6,7}(-[0-9]{1,6})?$"]) {
		return NO;
	}

	return YES;
}

+ (BOOL)checkChars:(NSString *)string charType:(NSInteger)charType
{
	if (!string) {
		return YES;
	}
	
	if (!charType) {
		charType = GCHAR_TYPE_CHN | GCHAR_TYPE_EN | GCHAR_TYPE_NUM;
	}
	
	if (!(charType & GCHAR_TYPE_CHN) && !(charType & GCHAR_TYPE_EN) && !(charType & GCHAR_TYPE_NUM)) {
		return NO;
	}
	
	NSString *regx = [NSString stringWithFormat: @"^[%@%@%@]*$",
					  (charType & GCHAR_TYPE_CHN) ? @"\u4E00-\u9FA5" : @"",
					  (charType & GCHAR_TYPE_EN) ? @"a-zA-Z" : @"",
					  (charType & GCHAR_TYPE_NUM) ? @"0-9" : @""];
	if(![string stringByMatching: regx]){
		return NO;
	}
	
	return YES;
}
@end
