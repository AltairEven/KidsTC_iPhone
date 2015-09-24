//
//  Insurance.m
//  KidsTC
//
//  Created by 钱烨 on 7/13/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "Insurance.h"

@implementation Insurance

- (instancetype)initWithType:(InsuranceType)ensType description:(NSString *)description {
    self = [super init];
    if (self) {
        _type = ensType;
        _InsuranceDescription = description;
    }
    return self;
}

+ (NSArray *)InsurancesWithRawData:(NSArray *)dataArray {
    NSMutableArray *tempInsArray = [[NSMutableArray alloc] init];
    if (dataArray && [dataArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary *singleInsurance in dataArray) {
            NSString *key = [[singleInsurance allKeys] firstObject];
            if ([key isEqualToString:@"refund_anytime"]) {
                BOOL bSupport = [[singleInsurance objectForKey:key] boolValue];
                if (bSupport) {
                    Insurance *insReparation = [[Insurance alloc] initWithType:InsuranceTypeReturnAnyTime description:@"随时退"];
                    [tempInsArray addObject:insReparation];
                }
            }
            if ([key isEqualToString:@"refund_outdate"]) {
                BOOL bSupport = [[singleInsurance objectForKey:key] boolValue];
                if (bSupport) {
                    Insurance *insReturn = [[Insurance alloc] initWithType:InsuranceTypeReturnOutOfDate description:@"过期退"];
                    [tempInsArray addObject:insReturn];
                }
            }
        }
    }
    return [NSArray arrayWithArray:tempInsArray];
}

@end
