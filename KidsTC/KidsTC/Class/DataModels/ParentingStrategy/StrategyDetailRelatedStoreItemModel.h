//
//  StrategyDetailRelatedStoreItemModel.h
//  KidsTC
//
//  Created by Altair on 1/22/16.
//  Copyright © 2016 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrategyDetailRelatedStoreItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, strong) KTCLocation *location;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
