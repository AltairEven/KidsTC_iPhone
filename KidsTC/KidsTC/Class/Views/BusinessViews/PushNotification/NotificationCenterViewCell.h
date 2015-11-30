//
//  NotificationCenterViewCell.h
//  KidsTC
//
//  Created by Altair on 11/30/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushNotificationModel.h"

@interface NotificationCenterViewCell : UITableViewCell

- (void)configWithModel:(PushNotificationModel *)model;

@end
