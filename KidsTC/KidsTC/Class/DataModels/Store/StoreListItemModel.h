//
//  StoreListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityLogoItem.h"
#import "PromotionLogoItem.h"

@interface StoreListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) NSUInteger commentCount;

@property (nonatomic, copy) NSString *distanceDescription;

@property (nonatomic, copy) NSString *feature;

@property (nonatomic, copy) NSString *businessZone;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, strong) NSArray <PromotionLogoItem *> *promotionLogoItems;

@property (nonatomic, strong) NSArray <ActivityLogoItem *> *activityLogoItems;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
