//
//  NSData+Json.m
//  iPhone51Buy
//
//  Created by alex tao on 12/6/13.
//  Copyright (c) 2013 icson. All rights reserved.
//

#import "NSData+Json.h"

@implementation NSObject (Json)

- (NSString *)stringFromJson {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        if (nil == registerData) {
            NSLog(@"Json encode error: %@", error);
            return nil;
        }
        return [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end




@implementation NSData (Json)

- (id)toJSONObject {
    return [self toJSONObject:0];
}

- (id)toJSONObject:(NSJSONReadingOptions)option {
    NSError * err1 = nil;
    id value = [NSJSONSerialization JSONObjectWithData:self options:option error:&err1];
    if (nil == value) {
        NSLog(@"Json parser error: %@", err1);
    }
    return value;
}

- (id)toJSONObjectFO {
    return [self toJSONObjectFO:0];
}

- (id)toJSONObjectFO:(NSJSONReadingOptions)option {
    NSString *tmpStr = GBSTR_FROM_DATA(self);
    return [[tmpStr dataUsingEncoding:NSUTF8StringEncoding] toJSONObject:option];
}

@end
