//
//  OnlineCustomerService.h
//  KidsTC
//
//  Created by Altair on 12/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnlineCustomerService : NSObject

+ (BOOL)serviceIsOnline;

+ (NSString *)onlineCustomerServiceLinkUrlString;

@end
