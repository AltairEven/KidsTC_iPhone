//
//  HospitalListItemModel.h
//  KidsTC
//
//  Created by 钱烨 on 10/14/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HospitalLoadType (1)

@interface HospitalListItemModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *hospitalDescription;

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, copy) NSString *phoneNumber;

@property (nonatomic, copy) NSString *distanceDescription;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initWithRawData:(NSDictionary *)data;

- (CGFloat)cellHeight;

@end
