//
//  KTCAgeScope.m
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCAgeScope.h"

static KTCAgeScope *_sharedInstance = nil;

@implementation KTCAgeScope

+ (instancetype)sharedAgeScope {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCAgeScope alloc] init];
    });
    return _sharedInstance;
}


- (void)setAgeItemsWithRawDataArray:(NSArray *)dataArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary *areaDic in dataArray) {
        KTCAgeItem *item = [[KTCAgeItem alloc] init];
        item.name = [areaDic objectForKey:@"Name"];
        item.identifier = [areaDic objectForKey:@"Value"];
        [tempArray addObject:item];
    }
    _ageItems = [NSArray arrayWithArray:tempArray];
}

@end


@implementation KTCAgeItem

+ (instancetype)ageItemWithName:(NSString *)name identifier:(NSString *)identifier {
    if (name && ![name isKindOfClass:[NSString class]]) {
        return nil;
    }
    if (identifier && ![identifier isKindOfClass:[NSString class]]) {
        return nil;
    }
    KTCAgeItem *item = [[KTCAgeItem alloc] init];
    item.name = name;
    item.identifier = identifier;
    return item;
}

@end