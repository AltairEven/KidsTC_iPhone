//
//  LoveHouseListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/13/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoveHouseListItemModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *houseDescription;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *distanceDescription;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithRawData:(NSDictionary *)data;

@end
