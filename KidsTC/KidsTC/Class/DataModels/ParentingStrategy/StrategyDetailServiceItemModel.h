//
//  StrategyDetailServiceItemModel.h
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrategyDetailServiceItemModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSUInteger saleCount;

@property (nonatomic, assign) NSUInteger storeCount;

@property (nonatomic, copy) NSString *serviceDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
