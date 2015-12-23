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

+ (NSArray *)InsurancesWithRawData:(NSDictionary *)data {
    NSMutableArray *tempInsArray = [[NSMutableArray alloc] init];
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        BOOL bSupport = [[data objectForKey:@"refund_anytime"] boolValue];
        if (bSupport) {
            Insurance *insReparation = [[Insurance alloc] initWithType:InsuranceTypeRefundAnyTime description:@"随时退"];
            [tempInsArray addObject:insReparation];
        }
        bSupport = [[data objectForKey:@"refund_outdate"] boolValue];
        if (bSupport) {
            Insurance *insReturn = [[Insurance alloc] initWithType:InsuranceTypeRefundOutOfDate description:@"过期退"];
            [tempInsArray addObject:insReturn];
        }
        bSupport = [[data objectForKey:@"refund_part"] boolValue];
        if (bSupport) {
            Insurance *insReturn = [[Insurance alloc] initWithType:InsuranceTypeRefundPartially description:@"部分退"];
            [tempInsArray addObject:insReturn];
        }
    }
    return [NSArray arrayWithArray:tempInsArray];
}

@end
