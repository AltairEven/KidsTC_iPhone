//
//  StoreDetailNearbyModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreDetailNearbyItem;

@interface StoreDetailNearbyModel : NSObject

@property (nonatomic, assign) NSUInteger type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, strong) NSArray<StoreDetailNearbyItem *> *itemsArray;

@property (nonatomic, readonly) BOOL hasInfo;

@property (nonatomic, strong, readonly) NSArray<NSString *> *itemDescriptions;

@property (nonatomic, strong, readonly) NSArray<KTCLocation *> *locations;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end


@interface StoreDetailNearbyItem : NSObject

@property (nonatomic, strong) KTCLocation *location;

@property (nonatomic, copy) NSString *itemDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (BOOL)hasInfo;

@end