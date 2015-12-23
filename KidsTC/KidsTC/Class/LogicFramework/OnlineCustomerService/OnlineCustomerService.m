//
//  OnlineCustomerService.m
//  KidsTC
//
//  Created by Altair on 12/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "OnlineCustomerService.h"

@implementation OnlineCustomerService

+ (BOOL)serviceIsOnline {
    NSString *link = [OnlineCustomerService onlineCustomerServiceLinkUrlString];
    if (![link isKindOfClass:[NSString class]] || [link length] == 0) {
        return NO;
    }
    return YES;
}

+ (NSString *)onlineCustomerServiceLinkUrlString {
    NSString *urlString = [[GConfig sharedConfig] getURLStringWithAliasName:@"KEFU_URL"];
    return urlString;
}

@end
