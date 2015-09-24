//
//  LoginService.h
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

+ (instancetype)sharedService;

- (void)KTCLoginWithAccount:(NSString *)account
                   password:(NSString *)password
                    success:(void(^)(NSString *uid, NSString *sky))sucess
                    failure:(void(^)(NSError *error))failure;

@end
