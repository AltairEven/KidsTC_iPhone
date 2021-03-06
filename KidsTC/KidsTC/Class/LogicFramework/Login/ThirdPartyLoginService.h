//
//  ThirdPartyLoginService.h
//  KidsTC
//
//  Created by Altair on 11/16/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ThirdPartyLoginTypeWechat,
    ThirdPartyLoginTypeQQ,
    ThirdPartyLoginTypeWeibo
}ThirdPartyLoginType;

@interface ThirdPartyLoginService : NSObject

@property (nonatomic, readonly) ThirdPartyLoginType currentLoginType;

@property (nonatomic, strong, readonly) NSString *currentOpenId;

@property (nonatomic, strong, readonly) NSString *currentAccessToken;

+ (instancetype)sharedService;

+ (BOOL)isOnline:(ThirdPartyLoginType)type;

- (BOOL)startThirdPartyLoginWithType:(ThirdPartyLoginType)type succeed:(void(^)(NSDictionary *respData))succeed failure:(void(^)(NSError *error))failure;

@end
