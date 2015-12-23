//
//  UserAddress.m
//  ICSON
//
//  Created by 钱烨 on 4/4/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "UserAddress.h"
#import "RegexKitLite.h"

@implementation UserAddress

- (id)initWithOrderDetailInfo:(NSDictionary *)orderDetailInfo
{
    self = [super init];
    if (self) {
        if ([orderDetailInfo isKindOfClass:[NSDictionary class]]) {
            if ([orderDetailInfo[@"receiver_addr_input"] isKindOfClass:[NSString class]] && ![orderDetailInfo[@"receiver_addr_input"] isEqualToString:@""]) {
                self.fullAddress = [orderDetailInfo[@"receiver_addr_input"] copy];
            }
            else {
                self.fullAddress = @"";
            }
            
            _aID = INVALID_ID;
            
            if ([orderDetailInfo[@"receiver_addr_id"] isKindOfClass:[NSString class]] || [orderDetailInfo[@"receiver_addr_id"] isKindOfClass:[NSNumber class]]) {
                self.districtId = [orderDetailInfo[@"receiver_addr_id"] integerValue];
            }
            else {
                self.districtId = 0;
            }
            
            if ([orderDetailInfo[@"receiver_mobile"] isKindOfClass:[NSString class]] && ![orderDetailInfo[@"receiver_mobile"] isEqualToString:@""]) {
                _mobile = [orderDetailInfo[@"receiver_mobile"] copy];
            }
            else {
                _mobile = @"";
            }
            
            if ([orderDetailInfo[@"receiver"] isKindOfClass:[NSString class]] && ![orderDetailInfo[@"receiver"] isEqualToString:@""]) {
                _name = [orderDetailInfo[@"receiver"] copy];
            }
            else {
                _name = @"";
            }
            
            if ([orderDetailInfo[@"receiver_zip"] isKindOfClass:[NSString class]] && ![orderDetailInfo[@"receiver_zip"] isEqualToString:@""]) {
                _zipCode = [orderDetailInfo[@"receiver_zip"] copy];
            }
            else {
                _zipCode = @"";
            }
        }
    }
    return self;
}


- (id)initWithRemoteData:(NSDictionary *)data
{
    if (self = [super init])
    {
        if (data && [data count] > 0) {
            self.aID = [[data objectForKey:@"aid"] intValue];
            self.createTime = [[data objectForKey:@"createTime"] doubleValue];
            self.districtId = [[data objectForKey:@"district"] intValue];
            self.lastUsedTime = [[data objectForKey:@"lastUsedTime"] doubleValue];
            self.mobile = [data objectForKey:@"mobile"];
            self.phone = [data objectForKey:@"phone"];
            self.name = [data objectForKey:@"name"];
            self.sortFactor = [[data objectForKey:@"sortFactor"] intValue];
            self.updateTime = [[data objectForKey:@"updateTime"] doubleValue];
            self.zipCode = [data objectForKey:@"zipcode"];
            self.detailAddress = [data objectForKey:@"address"];
            self.fullAddress = [data objectForKey:@"fullarea"];
            NSRange range = [self.fullAddress rangeOfString:self.detailAddress];
            self.fullArea = [self.fullAddress substringToIndex:range.location];
            self.gbAreaId = [[data objectForKey:@"gbAreaId"] floatValue];
            self.workPlace = [data objectForKey:@"recvWorkPlace"];
        }
    }
    
    return self;
}

- (id)initWithUserAddress:(UserAddress *)address
{
    if (self = [super init])
    {
        if (address)
        {
            _fullArea = [address.fullArea copy];
            _aID = address.aID;
            _createTime = address.createTime;
            _districtId = address.districtId;
            _lastUsedTime = address.lastUsedTime;
            _mobile = [address.mobile copy];
            _phone = [address.phone copy];
            _name = [address.name copy];
            _sortFactor = address.sortFactor;
            _updateTime = address.updateTime;
            _zipCode = [address.zipCode copy];
            _detailAddress = [address.detailAddress copy];
            _fullAddress = [address.fullAddress copy];
            _gbAreaId = address.gbAreaId;
            _gbAreaId = address.gbAreaId;
            _workPlace = address.workPlace;
        } else {
            _aID = INVALID_ID;
            _districtId = INVALID_ID;
            _gbAreaId = INVALID_ID;
            self.name = @"";
            self.fullArea = @"";
            self.mobile = @"";
            self.detailAddress = @"";
            self.workPlace = @"";
            self.fullAddress = @"";
        }
    }
    
    return self;
}


- (BOOL)isEqual:(id)object
{
    if (!object)
    {
        return NO;
    }
    
    UserAddress *other = (UserAddress *)object;
    return ([self.detailAddress isEqualToString:other.detailAddress] &&
            self.aID == other.aID &&
            self.districtId == other.districtId &&
            [self.mobile isEqualToString:other.mobile] &&
            [self.name isEqualToString:other.name]);
}



- (void)checkValidation:(NSError *__autoreleasing *)error {
    NSString *errorMsg = @"";
    if ([self.name length] == 0) {
        errorMsg = @"收货人不能为空";
    }
    if ([self.name length] > 10) {
        errorMsg = @"收货人不能超过10个字符";
    }
    if ([self.mobile length] == 0) {
        errorMsg = @"手机号码不能为空";
    }
    if (![self.mobile stringByMatching: @"^((\\(\\d{3}\\))|(\\d{3}\\-))?1\\d{10}$"]) {
        errorMsg = @"手机号码填写有误，格式：13612345678";
    }
    if ([self.fullArea length] == 0 || self.districtId <= 0) {
        errorMsg = @"请选择地区";
    }
    if ([self.detailAddress length] == 0) {
        errorMsg = @"详细地址不能为空";
    }
    if ([self.detailAddress length] > 50) {
        errorMsg = @"详细地址不能超过50个字符";
    }
    
    if ([errorMsg isEqualToString:@""]) {
        *error = nil;
        return;
    } else {
        *error = [NSError errorWithDomain:@"User Address Validation" code:-1 userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:@"errorMsg"]];
        return;
    }
}


@end
