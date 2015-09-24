//
//  StoreDetailModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveModel.h"
#import "StoreTuanModel.h"
#import "ServiceListItemModel.h"
#import "StoreListItemModel.h"

@interface StoreDetailModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) NSUInteger appointmentNumber;

@property (nonatomic, assign) NSUInteger commentNumber;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) BOOL isFavourate;

@property (nonatomic, strong) NSDate *appointmentStartDate;

@property (nonatomic, strong) NSDate *appointmentEndDate;

@property (nonatomic, strong) NSArray *appointmentTimes;

@property (nonatomic, assign) CLLocationCoordinate2D storeCoordinate;

@property (nonatomic, copy) NSString *storeAddress;

@property (nonatomic, strong) NSArray *activeModelsArray;

@property (nonatomic, strong) NSArray *tuanModelsArray;

@property (nonatomic, strong) NSArray *serviceModelsArray;

@property (nonatomic, copy) NSString *storeBrief;

@property (nonatomic, strong) NSArray *brotherStores;

- (void)fillWithRawData:(NSDictionary *)data;

@end
