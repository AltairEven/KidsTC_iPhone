//
//  ActivityFilterModel.m
//  KidsTC
//
//  Created by 钱烨 on 11/6/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "ActivityFilterModel.h"

@interface ActivityFilterModel ()

@property (nonatomic, strong) NSArray *cNames;

@property (nonatomic, strong) NSArray *aNames;

@end

@implementation ActivityFilterModel

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        //category
        NSArray *rawArray = [data objectForKey:@"cFilter"];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSMutableArray *nameArray = [[NSMutableArray alloc] init];
        if ([rawArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *singleEle in rawArray) {
                ActivityFiltItem *item = [[ActivityFiltItem alloc] initWithRawData:singleEle];
                if (item) {
                    [tempArray addObject:item];
                    [nameArray addObject:item.name];
                }
            }
        }
        _categoryFiltItems = [NSArray arrayWithArray:tempArray];
        self.cNames = [NSArray arrayWithArray:nameArray];
        
        //area
        rawArray = [data objectForKey:@"dFilter"];
        [tempArray removeAllObjects];
        [nameArray removeAllObjects];
        if ([rawArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *singleEle in rawArray) {
                ActivityFiltItem *item = [[ActivityFiltItem alloc] initWithRawData:singleEle];
                if (item) {
                    [tempArray addObject:item];
                    [nameArray addObject:item.name];
                }
            }
        }
        _areaFiltItems = [NSArray arrayWithArray:tempArray];
        self.aNames = [NSArray arrayWithArray:nameArray];
        //date
        _lastUpdateDate = [NSDate date];
    }
    return self;
}

- (BOOL)needRefresh {
    BOOL need = YES;
    if ([self.categoryFiltItems count] == 0 && [self.areaFiltItems count] == 0) {
        return need;
    }
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:self.lastUpdateDate];
    if (timeInterval < 600) {
        //十分钟以内，不刷新
        need = NO;
    }
    
    return need;
}

- (NSArray *)categotyNames {
    return [NSArray arrayWithArray:self.cNames];
}

- (NSArray *)areaNames {
    return [NSArray arrayWithArray:self.aNames];
}

@end

@implementation ActivityFiltItem

- (instancetype)initWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        if ([data objectForKey:@"id"]) {
            self.identifier = [NSString stringWithFormat:@"%@", [data objectForKey:@"id"]];
        }
        self.name = [data objectForKey:@"name"];
    }
    return self;
}

@end
