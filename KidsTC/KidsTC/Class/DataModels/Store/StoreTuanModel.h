//
//  StoreTuanModel.h
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreTuanModel : NSObject

@property (nonatomic, copy) NSString *serviceId;

@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *tuanName;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) CGFloat price;

@property (nonatomic, assign) NSUInteger tuanCount;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
