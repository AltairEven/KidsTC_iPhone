//
//  StoreDetailNearbyModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/27/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreDetailNearbyModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *imageUrl;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
