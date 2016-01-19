//
//  StoreDetailHotRecommendModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/26/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDetailHotRecommendModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) NSUInteger storeCount;

@property (nonatomic, copy) NSString *priceDescription;

@property (nonatomic, copy) NSString *serviceDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
