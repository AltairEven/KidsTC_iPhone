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
    self.bannerRatio = 0.7;
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
    //hot recommend
    NSArray *tuans = [data objectForKey:@"tuan"];
    if ([tuans isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *tuanDic in tuans) {
            StoreDetailHotRecommendModel *model = [[StoreDetailHotRecommendModel alloc] initWithRawData:tuanDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.hotRecommendServiceArray = [NSArray arrayWithArray:tempArray];
    }
    //recommend
    self.recommenderFaceImageUrl = [NSURL URLWithString:[data objectForKey:@"recommendImgUrl"]];
    self.recommenderName = [data objectForKey:@"recommendName"];
    self.recommendString = [data objectForKey:@"recommendContent"];
    self.recommenderFaceImageUrl = [self.imageUrls firstObject];
    self.recommenderName = @"小河马";
    self.recommendString = @"小河马爱洗澡，萌萌哒满地跑，一不小心摔一跤，呜啊呜啊哭又闹。河马妈妈来看到，二话不说拿棍捣，小河马被打屁了，哈哈哈哈真搞笑。";
    //brief
    self.storeBrief = [data objectForKey:@"breif"];
    //comments
    NSArray *comments = [data objectForKey:@"comment"];
    if ([comments isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *commentDic in comments) {
            CommentListItemModel *model = [[CommentListItemModel alloc] initWithRawData:commentDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.commentItemsArray = [NSArray arrayWithArray:tempArray];
    }
    //nearby
    NSArray *nearbys = [data objectForKey:@"nearby"];
    if ([nearbys isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *nearbyDic in nearbys) {
            StoreDetailNearbyModel *model = [[StoreDetailNearbyModel alloc] initWithRawData:nearbyDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.nearbyFacilities = [NSArray arrayWithArray:tempArray];
    }
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
    //services
    NSArray *services = [data objectForKey:@"serve"];
    if ([services isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *serviceDic in services) {
            StoreOwnedServiceModel *model = [[StoreOwnedServiceModel alloc] initWithRawData:serviceDic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.serviceModelsArray = [NSArray arrayWithArray:tempArray];
    }
}

- (CGFloat)topCellHeight {
    CGFloat height = self.bannerRatio * SCREEN_WIDTH;
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 20 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:17] topGap:10 bottomGap:10 maxLine:2 andText:self.storeName];
    height += 40;
    return height;
}

- (CGFloat)recommendCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.recommendString];
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

- (CGFloat)briefCellHeight {
    return [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.storeBrief];
}


@end
