//
//  UserCenterModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "UserCenterModel.h"

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
        self.age = [[data objectForKey:@"age"] integerValue];
        self.birthday = [data objectForKey:@"birthday"];
        self.faceImageUrl = [NSURL URLWithString:[data objectForKey:@"headUrl"]];
        self.phone = [data objectForKey:@"mobile"];
        NSUInteger userRoleIdentifier = [[data objectForKey:@"sex"] integerValue];
        self.userRole = [KTCUserRole instanceWithIdentifier:userRoleIdentifier];
        self.hasUnreadMessage = [[data objectForKey:@"hasNewMessage"] boolValue];
        self.appointmentOrderCount = [[data objectForKey:@"appointment_wait_arrive"] integerValue];
        self.waitingPaymentOrderCount = [[data objectForKey:@"order_wait_pay"] integerValue];
        self.waitingCommentOrderCount = [[data objectForKey:@"order_wait_evaluate"] integerValue];
    }
    return self;
}

@end
