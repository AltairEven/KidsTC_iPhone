//
//  errcode.h
//  iphone
//
//  Created by icson apple on 12-2-17.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#ifndef iphone_errcode_h
#define iphone_errcode_h

enum {
    ERRCODE_USERPASSWD_INVALID = 66,
    ERRCODE_USERNAME_INVALID = 67,
    ERRCODE_FORBIDDEN_CUSTOM_PHONE = 100005,
    ERRCODE_COUPON_UNAVAILABIE = 99999,
	UNKNOWN = 1000,
    ERRCODE_DATA_INVALID,
    ERRCODE_JSON_INVALID,
    ERRCODE_FIELD_EMPTY,
    ERRCODE_FIELD_TOOLONG,
    ERRCODE_ZIP_INVALID,
    ERRCODE_MOBILE_INVALID,
};

enum ENUM_ERR_TYPE {
    ERR_COMMON = 2000,
    ERR_SEARCH,
    ERR_ADDRESS,
    ERR_PAYMENT,
    ERR_INVOICE,
    ERR_LOGIN,
};

typedef enum ENUM_ERR_TYPE ERR_TYPE;

#define ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(type, ecode, userinfo) ([NSError errorWithDomain: ([NSString stringWithFormat:@"51buy_%d", (type)]) code:(ecode) userInfo: (userinfo)])

#define ERROR_WITH_TYPE_AND_CODE(type, code) ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(type, code, nil)
#define ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(type, code, msg) ERROR_WITH_TYPE_AND_CODE_AND_USERINFO(type, code, ([NSDictionary dictionaryWithObjectsAndKeys:(msg), @"message", nil]))

#endif
