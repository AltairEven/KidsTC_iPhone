//
//  Insurance.h
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    InsuranceTypeReturnAnyTime,
    InsuranceTypeReturnOutOfDate
}InsuranceType;

@interface Insurance : NSObject

@property (nonatomic, assign) InsuranceType type;

@property (nonatomic, copy) NSString *InsuranceDescription;

- (instancetype)initWithType:(InsuranceType)ensType description:(NSString *)description;

+ (NSArray *)InsurancesWithRawData:(NSArray *)dataArray;

@end
