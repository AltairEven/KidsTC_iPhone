//
//  FavouriteStoreItemModel.h
//  KidsTC
//
//  Created by Altair on 12/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavouriteStoreItemModel : NSObject

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) NSUInteger starNumber;

@property (nonatomic, copy) NSString *distanceDescription;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
