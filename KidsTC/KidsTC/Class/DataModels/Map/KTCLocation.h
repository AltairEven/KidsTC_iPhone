//
//  KTCLocation.h
//  KidsTC
//
//  Created by 钱烨 on 8/28/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTCLocation : NSObject <NSCopying>

@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) NSString *locationDescription;

@property (nonatomic, copy) NSString *moreDescription;

- (instancetype)initWithLocation:(CLLocation *)location locationDescription:(NSString *)description;

@end
