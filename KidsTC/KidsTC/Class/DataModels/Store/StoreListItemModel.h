//
//  StoreListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveModel.h"

@interface StoreListItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, copy) NSString *distanceDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
