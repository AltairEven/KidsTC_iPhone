//
//  StoreDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/17/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "StoreDetailModel.h"
#import "NSDate+Helpers.h"

@implementation StoreDetailModel

- (void)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *imgUrls = [data objectForKey:@"imgUrl"];
    if ([imgUrls isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in imgUrls) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.imageUrls = [NSArray arrayWithArray:tempArray];
    }
    self.storeName = [data objectForKey:@"storeName"];
    self.starNumber = [[data objectForKey:@"level"] integerValue];
    self.appointmentNumber = [[data objectForKey:@"bookNum"] integerValue];
    self.commentNumber = [[data objectForKey:@"evaluateNum"] integerValue];
    self.phoneNumber = [data objectForKey:@"phone"];
    self.isFavourate = [[data objectForKey:@"favor"] boolValue];
    //appoint times
    NSDictionary *appointTime = [data objectForKey:@"appointTime"];
    if ([appointTime isKindOfClass:[NSDictionary class]]) {
        //date
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *start = [appointTime objectForKey:@"startTime"];
        NSString *end = [appointTime objectForKey:@"endTime"];
        self.appointmentStartDate = [dateFormatter dateFromString:start];
        self.appointmentEndDate = [dateFormatter dateFromString:end];
        NSArray *times = [appointTime objectForKey:@"dayTime"];
        if ([times isKindOfClass:[NSArray class]]) {
            self.appointmentTimes = [NSArray arrayWithArray:times];
        }
    }
    //loc
    NSDictionary *location = [data objectForKey:@"loc"];
    if ([location isKindOfClass:[NSDictionary class]]) {
        self.storeAddress = [location objectForKey:@"addr"];
        self.storeCoordinate = [GToolUtil coordinateFromString:[location objectForKey:@"mapAddr"]];
    }
    //active
    NSArray *activies = [data objectForKey:@"event"];
    if ([activies isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *activeDic in activies) {
            ActiveModel *model = [[ActiveModel alloc] init];
            model.type = (ActiveType)[[activeDic objectForKey:@"type"] integerValue];
            model.name = [activeDic objectForKey:@"name"];
            model.activeDescription = [activeDic objectForKey:@"des"];
            [tempArray addObject:model];
        }
        self.activeModelsArray = [NSArray arrayWithArray:tempArray];
    }
    //tuan
    NSArray *tuans = [data objectForKey:@"tuan"];
    if ([tuans isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tuanDic in tuans) {
            StoreTuanModel *model = [[StoreTuanModel alloc] initWithRawData:tuanDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.tuanModelsArray = [NSArray arrayWithArray:tempArray];
    }
    //service
    NSArray *services = [data objectForKey:@"serve"];
    if ([services isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:services];
        if ([services count] % 2 != 0) {
            //补齐
            NSDictionary *fixDic = [services lastObject];
            [tempArray addObject:fixDic];
        }
        services = [NSArray arrayWithArray:tempArray];
        [tempArray removeAllObjects];
        for (NSDictionary *serviceDic in services) {
            ServiceListItemModel *model = [[ServiceListItemModel alloc] initWithRawData:serviceDic];
            model.serviceName = [serviceDic objectForKey:@"title"];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.serviceModelsArray = [NSArray arrayWithArray:tempArray];
    }
    //brief
    self.storeBrief = [data objectForKey:@"breif"];
    //brothers
    NSArray *brothers = [data objectForKey:@"broStore"];
    if ([brothers isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *broDic in brothers) {
            StoreListItemModel *model = [[StoreListItemModel alloc] initWithRawData:broDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.brotherStores = [NSArray arrayWithArray:tempArray];
    } else {
        //没有
        StoreListItemModel *model = [[StoreListItemModel alloc] init];
        model.identifier = self.storeId;
        model.imageUrl = [self.imageUrls firstObject];
        model.storeName = self.storeName;
        model.activities = self.activeModelsArray;
        self.brotherStores = [NSArray arrayWithObject:model];
    }
}


@end
