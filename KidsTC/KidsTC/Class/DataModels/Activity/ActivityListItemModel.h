//
//  ActivityListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/8/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListItemModel : UIView

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *activityContent;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, assign) NSUInteger leftNumber;

@property (nonatomic, assign) CGFloat ratio;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
