//
//  ServiceListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/11/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Insurance.h"

@interface ServiceListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *serviceName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, assign) CGFloat promotionPrice;

@property (nonatomic, assign) NSUInteger saledCount;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
