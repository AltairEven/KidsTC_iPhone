//
//  KTCArea.m
//  KidsTC
//
//  Created by 钱烨 on 8/5/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "KTCArea.h"

static KTCArea *_sharedInstance = nil;

static NSUInteger retryCount = 0;

@interface KTCArea ()

@property (nonatomic, strong) HttpRequestClient *loadAreaRqeuest;

@property (nonatomic, copy) NSString *md5String;

- (void)getCachedData;

- (void)loadAreaSucceed:(NSDictionary *)data;

- (void)loadAreaFailed:(NSError *)error;

- (void)setAreaItemsArrayWithRawDataArray:(NSArray *)dataArray;

@end

@implementation KTCArea

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getCachedData];
    }
    return self;
}

+ (instancetype)area {
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        _sharedInstance = [[KTCArea alloc] init];
    });
    return _sharedInstance;
}

- (void)synchronizeArea {
    if (!self.loadAreaRqeuest) {
        self.loadAreaRqeuest = [HttpRequestClient clientWithUrlAliasName:@"MAIN_GET_AGEANDAREA"];
    }
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.md5String forKey:@"md5"];
    
    __weak KTCArea *weakSelf = self;
    [weakSelf.loadAreaRqeuest startHttpRequestWithParameter:param success:^(HttpRequestClient *client, NSDictionary *responseData) {
        [weakSelf loadAreaSucceed:responseData];
    } failure:^(HttpRequestClient *client, NSError *error) {
        [weakSelf loadAreaFailed:error];
    }];
}

- (NSString *)md5String {
    if ([_md5String length] == 0) {
        _md5String = @"001";
    }
    return _md5String;
}

- (NSInteger)indexOfAreaIdentifier:(NSString *)identifier {
    NSInteger itemIndex = -1;
    if ([identifier length] > 0) {
        for (NSUInteger index = 0; index < [self.areaItems count]; index ++) {
            KTCAreaItem *item = [self.areaItems objectAtIndex:index];
            if ([item.identifier isEqualToString:identifier]) {
                itemIndex = index;
                break;
            }
        }
    }
    return itemIndex;
}

- (NSInteger)indexOfAreaItem:(KTCAreaItem *)item {
    NSInteger itemIndex = -1;
    if (item) {
        for (NSUInteger index = 0; index < [self.areaItems count]; index ++) {
            KTCAreaItem *areaItem = [self.areaItems objectAtIndex:index];
            if ([areaItem.identifier isEqualToString:item.identifier]) {
                itemIndex = index;
                break;
            }
        }
    }
    return itemIndex;
}

#pragma mark Private methods

- (void)getCachedData {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
    NSString *cachePath = FILE_CACHE_PATH(@"Area.plist");
    if ([GToolUtil copyFileFormBundlePath:bundlePath toFilePath:cachePath]) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:cachePath];
        if (dataDic) {
            self.md5String = [dataDic objectForKey:@"md5"];
            NSDictionary *localData = [dataDic objectForKey:@"data"];
            if (localData) {
                [self setAreaItemsArrayWithRawDataArray:[localData objectForKey:@"Addr"]];
                [[KTCAgeScope sharedAgeScope] setAgeItemsWithRawDataArray:[localData objectForKey:@"Age"]];
            }
        }
    }
}

- (void)loadAreaSucceed:(NSDictionary *)data {
    retryCount = 0;
    NSDictionary *sysData = [data objectForKey:@"data"];
    self.md5String = [data objectForKey:@"md5"];
    if (sysData) {
        [self setAreaItemsArrayWithRawDataArray:[sysData objectForKey:@"Addr"]];
        [[KTCAgeScope sharedAgeScope] setAgeItemsWithRawDataArray:[sysData objectForKey:@"Age"]];
    }
    [data writeToFile:FILE_CACHE_PATH(@"Area.plist") atomically:NO];
}

- (void)loadAreaFailed:(NSError *)error {
    if (error.code != -1002) {
        //不是因为MD5相同
        if (retryCount < 2) {
            retryCount ++;
            [self synchronizeArea];
        }
    }
}

- (void)setAreaItemsArrayWithRawDataArray:(NSArray *)dataArray {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempNamesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *areaDic in dataArray) {
        KTCAreaItem *item = [[KTCAreaItem alloc] init];
        item.name = [areaDic objectForKey:@"Name"];
        item.identifier = [areaDic objectForKey:@"Value"];
        [tempArray addObject:item];
        [tempNamesArray addObject:item.name];
    }
    _areaItems = [NSArray arrayWithArray:tempArray];
    _areaNames = [NSArray arrayWithArray:tempNamesArray];
}

@end

@implementation KTCAreaItem


@end
