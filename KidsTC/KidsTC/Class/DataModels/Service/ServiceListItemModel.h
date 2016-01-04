//
//  ServiceListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Insurance.h"
#import "ActivityLogoItem.h"
#import "PromotionLogoItem.h"

typedef enum {
    ServiceStatusReadyForSale = 1,
    ServiceStatusHasSoldOut = 2,
    ServiceStatusNoStore = 3,
    ServiceStatusNotBegin = 4,
    ServiceStatusHasTakenOff = 5
}ServiceStatus;

@interface ServiceListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) ServiceStatus status;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) CGFloat promotionPrice;

@property (nonatomic, assign) NSUInteger saledCount;

@property (nonatomic, strong) NSArray<Insurance *> *supportedInsurance;

@property (nonatomic, strong) NSArray<ActivityLogoItem *> *activityLogoItems;

@property (nonatomic, strong) NSArray<PromotionLogoItem *> *promotionLogoItems;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
