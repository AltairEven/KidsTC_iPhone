//
//  ServiceMoreDetailHotSalesItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/15/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMoreDetailHotSalesItemModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) CGFloat originalPrice;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, assign) NSUInteger storeCount;

@property (nonatomic, copy) NSString *serviceDescription;

@property (nonatomic, copy) NSString *ageDescription;

@property (nonatomic, assign) NSUInteger saleCount;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
