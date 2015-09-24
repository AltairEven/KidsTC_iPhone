//
//  AddressValidator.m
//  iphone51buy
//
//  Created by icson apple on 12-4-26.
//  Copyright (c) 2012年 icson. All rights reserved.
//

#import "AddressValidator.h"

@implementation AddressValidator
@synthesize address;

- (id)initWithAddress:(NSDictionary *)_address
{
    if (self = [super init]) {
        address = _address;

        error = nil;
    }
    return self;
}

- (void)setError:(NSError *)_error
{

    error = _error;
}

- (BOOL)validate
{
#define GADDRESS_CHECK_EMPTY(var, field, msg) if([GToolUtil isEmpty:[var objectForKey: (field)]]) {\
    [self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_ADDRESS, ERRCODE_FIELD_EMPTY, (msg))];\
    return NO;\
}
    
#define GADDRESS_CHECK_LENGTHTOOLONG(var, field, maxlength, msg) if([[var objectForKey: (field)] length] > (maxlength)) {\
[self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_ADDRESS, ERRCODE_FIELD_TOOLONG, (msg))];\
return NO;\
}

    //GADDRESS_CHECK_EMPTY(address, @"workplace", @"地址标注不能为空");
    //GADDRESS_CHECK_LENGTHTOOLONG(address, @"workplace", 8, @"地址标注不能超过4个汉字或者8个字母");
    GADDRESS_CHECK_EMPTY(address, @"name", @"收货人不能为空");
    GADDRESS_CHECK_LENGTHTOOLONG(address, @"name", 10, @"收货人不能超过10个字符");
    // NOTE:和PC不一样
    GADDRESS_CHECK_EMPTY(address, @"mobile", @"手机号码不能为空");
    if (![self checkMobilePhone: [address objectForKey: @"mobile"]]) {
        [self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_ADDRESS, ERRCODE_MOBILE_INVALID, @"手机号码填写有误，格式：13612345678")];
        return NO;
    }
    
    #define INVALID_ID -1
    GADDRESS_CHECK_EMPTY(address, @"district", @"请选择地区");
    if ([[address objectForKey:@"district"] intValue] == INVALID_ID)
    {
        [self setError:ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_ADDRESS, ERRCODE_MOBILE_INVALID, @"请选择地区")];
        return NO;
    }
    
    GADDRESS_CHECK_EMPTY(address, @"address", @"详细地址不能为空");
    GADDRESS_CHECK_LENGTHTOOLONG(address, @"address", 50, @"详细地址不能超过50个字符");

    if (![GToolUtil isEmpty: [address objectForKey: @"zipcode"]] && ![self checkZip: [address objectForKey: @"zipcode"]]) {
        [self setError: ERROR_WITH_TYPE_AND_CODE_AND_MESSAGE(ERR_ADDRESS, ERRCODE_ZIP_INVALID, @"邮政编码填写有误，格式：200000")];
        return NO;
    }

    return YES;
#undef GADDRESS_CHECK_EMPTY
#undef GADDRESS_CHECK_LENGTHTOOLONG
}

- (NSError *)lastError
{
    return error;
}

@end
