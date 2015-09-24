//
//  UserCenterModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/25/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCenterModel : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, copy) NSString *levelTitle;

@property (nonatomic, assign) NSUInteger score;

@property (nonatomic, assign) BOOL hasUnreadMessage;

@property (nonatomic, assign) NSUInteger appointmentOrderCount;

@property (nonatomic, assign) NSUInteger waitingPaymentOrderCount;

@property (nonatomic, assign) NSUInteger waitingCommentOrderCount;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
