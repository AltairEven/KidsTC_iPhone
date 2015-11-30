//
//  NotificationCenterViewModel.h
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "BaseViewModel.h"
#import "NotificationCenterView.h"
#import "PushNotificationModel.h"

@interface NotificationCenterViewModel : BaseViewModel

- (void)getMoreDataWithSucceed:(void (^)(NSDictionary *data))succeed failure:(void (^)(NSError *error))failure;

- (NSArray *)resultArray;

@end
