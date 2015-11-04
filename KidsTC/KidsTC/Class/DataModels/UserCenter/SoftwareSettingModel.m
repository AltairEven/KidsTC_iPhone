//
//  SoftwareSettingModel.m
//  KidsTC
//
//  Created by 钱烨 on 11/3/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "SoftwareSettingModel.h"

@implementation SoftwareSettingModel

- (NSString *)cacheLengthDescription {
    NSUInteger length = self.cacheLength / 8;
    NSUInteger k = 1024;
    NSUInteger m = 1024 * 1024;
    CGFloat result = 0;
    NSString *tail = @"B";
    if (length >= k && length < m) {
        result = length / k;
        tail = @"K";
    } else if (length > m) {
        result = length / m;
        tail = @"M";
    }
    
    NSString *des = [NSString stringWithFormat:@"%.2f%@", result, tail];
    return des;
}

@end
