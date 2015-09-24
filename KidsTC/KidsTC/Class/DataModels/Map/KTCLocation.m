//
//  KTCLocation.m
//  KidsTC
//
//  Created by 钱烨 on 8/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCLocation.h"

@implementation KTCLocation

- (instancetype)initWithLocation:(CLLocation *)location locationDescription:(NSString *)description {
    self = [super init];
    if (self) {
        self.location = location;
        self.locationDescription = description;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    KTCLocation *location = [[KTCLocation allocWithZone:zone] init];
    location.location = [self.location copy];
    location.locationDescription = [self.locationDescription copy];
    location.moreDescription = [self.moreDescription copy];
    return location;
}

@end
