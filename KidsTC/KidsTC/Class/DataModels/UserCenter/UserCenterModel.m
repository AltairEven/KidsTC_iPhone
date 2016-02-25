//
//  UserCenterModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterModel.h"
#import "KTCPushNotificationService.h"

@implementation UserCenterModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.userName = [data objectForKey:@"usrName"];
        self.level = [[data objectForKey:@"level"] integerValue];
        self.levelTitle = [data objectForKey:@"levelName"];
        self.score = [[data objectForKey:@"score_num"] integerValue];
        self.carrotCount = [[data objectForKey:@"userRadishNum"] integerValue];
        self.age = [[data objectForKey:@"age"] integerValue];
        self.birthday = [data objectForKey:@"birthday"];
        self.faceImageUrl = [NSURL URLWithString:[data objectForKey:@"headUrl"]];
        self.phone = [data objectForKey:@"mobile"];
        NSUInteger userRoleIdentifier = [[data objectForKey:@"sex"] integerValue];
        self.userRole = [KTCUserRole instanceWithIdentifier:userRoleIdentifier];
        self.appointmentOrderCount = [[data objectForKey:@"appointment_wait_arrive"] integerValue];
        self.waitingPaymentOrderCount = [[data objectForKey:@"order_wait_pay"] integerValue];
        self.waitingCommentOrderCount = [[data objectForKey:@"order_wait_evaluate"] integerValue];
        self.activityModel = [[UserActivityModel alloc] initWithRawData:[data objectForKey:@"invite"]];
        if ([KTCPushNotificationService sharedService].unreadCount > 0) {
            self.hasUnreadMessage = YES;
            self.unreadMessageCount = [KTCPushNotificationService sharedService].unreadCount;
        }
        NSDictionary *flashDic = [data objectForKey:@"fsList"];
        if ([flashDic isKindOfClass:[NSDictionary class]]) {
            NSString *link = [flashDic objectForKey:@"linkUrl"];
            if ([link isKindOfClass:[NSString class]] && [link length] > 0) {
                _hasFlashOrder = YES;
                self.flashLink = link;
            }
        }
        NSDictionary *carrotDic = [data objectForKey:@"fsList"];
        if ([carrotDic isKindOfClass:[NSDictionary class]]) {
            NSString *link = [carrotDic objectForKey:@"linkUrl"];
            if ([link isKindOfClass:[NSString class]] && [link length] > 0) {
                _hasCarrotExchangeHistory = YES;
                self.carrotExchangeLink = link;
            }
        }
        self.carrotExchangeLink = @"www.baidu.com";
        NSDictionary *signDic = [data objectForKey:@"radish"];
        if ([signDic isKindOfClass:[NSDictionary class]]) {
            NSString *link = [signDic objectForKey:@"linkUrl"];
            if ([link isKindOfClass:[NSString class]] && [link length] > 0) {
                self.signLink = link;
            }
        }
    }
    return self;
}

- (BOOL)hasUserActivity {
    if (!self.activityModel) {
        return NO;
    }
    return YES;
}

@end

@implementation UserActivityModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (self) {
        self.buttonTitle = [data objectForKey:@"btnDesc"];
        self.activityDescription = [data objectForKey:@"desc"];
        self.iconUrl = [NSURL URLWithString:[data objectForKey:@"icon"]];
        self.linkUrlString = [data objectForKey:@"linkUrl"];
    }
    return self;
}

@end
