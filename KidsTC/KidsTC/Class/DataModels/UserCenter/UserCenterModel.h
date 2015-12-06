//
//  UserCenterModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserActivityModel;

@interface UserCenterModel : NSObject

@property (nonatomic, copy) NSString *userName; //用户名

@property (nonatomic, assign) NSInteger level; //用户级别

@property (nonatomic, copy) NSString *levelTitle; //用户级别描述

@property (nonatomic, assign) NSUInteger score; //积分

@property (nonatomic, assign) NSUInteger age; //年龄

@property (nonatomic, strong) KTCUserRole *userRole; //角色

@property (nonatomic, copy) NSString *birthday; //生日

@property (nonatomic, strong) NSURL *faceImageUrl; //头像

@property (nonatomic, copy) NSString *phone; //电话

@property (nonatomic, assign) BOOL hasUnreadMessage; //是否有未读信息

@property (nonatomic, assign) NSUInteger appointmentOrderCount; // 预约订单数

@property (nonatomic, assign) NSUInteger waitingPaymentOrderCount; // 待付款订单数

@property (nonatomic, assign) NSUInteger waitingCommentOrderCount; // 待评论订单数

@property (nonatomic, strong) UserActivityModel *activityModel;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)hasUserActivity;

@end

@interface UserActivityModel : NSObject

@property (nonatomic, copy) NSString *buttonTitle;

@property (nonatomic, copy) NSString *activityDescription;

@property (nonatomic, strong) NSURL *iconUrl;

@property (nonatomic, copy) NSString *linkUrlString;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
