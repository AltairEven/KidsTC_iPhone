//
//  UserAddress.h
//  ICSON
//
//  Created by 钱烨 on 4/4/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INVALID_ID (-1)

@interface UserAddress : NSObject

@property (nonatomic, assign) NSInteger aID;                    // 地址ID
@property (nonatomic, assign) NSTimeInterval createTime;        // 创建时间
@property (nonatomic, assign) NSInteger districtId;             // 区域ID
@property (nonatomic, assign) NSTimeInterval lastUsedTime;      // 上次使用时间
@property (nonatomic, strong) NSString *mobile;                 // 收货人手机号码
@property (nonatomic, strong) NSString *phone;                  // 收货人电话
@property (nonatomic, strong) NSString *name;                   // 收货人姓名
@property (nonatomic, assign) NSInteger sortFactor;             // 用于排序
@property (nonatomic, assign) NSTimeInterval updateTime;        // 更新时间
@property (nonatomic, strong) NSString *zipCode;                // 邮编
@property (nonatomic, strong) NSString *fullArea;               // 完整区域信息
@property (nonatomic, strong) NSString *detailAddress;          // 详细地址信息
@property (nonatomic, strong) NSString *fullAddress;          // 完整地址信息
@property (nonatomic, assign) NSInteger gbAreaId;               // 区县ID，用于查询乡镇列表
@property (nonatomic, strong) NSString *workPlace;              // for Qiang

- (id)initWithRemoteData:(NSDictionary *)data;

- (id)initWithUserAddress:(UserAddress *)address;

- (void)checkValidation:(NSError **)error;

- (id)initWithOrderDetailInfo:(NSDictionary *)orderDetailInfo;
@end
