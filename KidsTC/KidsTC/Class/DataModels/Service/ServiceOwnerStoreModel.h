//
//  ServiceOwnerStoreModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceOwnerStoreModel : NSObject

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, assign) NSUInteger hotSaleCount;

@property (nonatomic, assign) NSUInteger favourateCount;

@property (nonatomic, copy) NSString *distanceDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
