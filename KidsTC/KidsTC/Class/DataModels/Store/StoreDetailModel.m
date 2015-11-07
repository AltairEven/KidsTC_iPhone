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
    self.bannerRatio = 1;
    self.storeName = [data objectForKey:@"storeName"];
    self.starNumber = [[data objectForKey:@"level"] integerValue];
    self.couponUrlString = [data objectForKey:@"couponLink"];
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
    NSDictionary *recommendDic = [data objectForKey:@"note"];
    if ([recommendDic isKindOfClass:[NSDictionary class]] && [recommendDic count] > 0) {
        self.recommenderFaceImageUrl = [NSURL URLWithString:[recommendDic objectForKey:@"imgUrl"]];
        self.recommenderName = [recommendDic objectForKey:@"name"];
        self.recommendString = [recommendDic objectForKey:@"note"];
    }
    //brief
    self.storeBrief = [data objectForKey:@"breif"];
    //comments
    NSArray *comments = [data objectForKey:@"commentList"];
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
    NSArray *nearbys = [data objectForKey:@"factilities"];
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
    //comments number
    NSDictionary *commentDic = [data objectForKey:@"comment"];
    if ([commentDic isKindOfClass:[NSDictionary class]] && [commentDic count] > 0) {
        self.commentAllNumber = [[commentDic objectForKey:@"all"] integerValue];
        self.commentGoodNumber = [[commentDic objectForKey:@"good"] integerValue];
        self.commentNormalNumber = [[commentDic objectForKey:@"normal"] integerValue];
        self.commentBadNumber = [[commentDic objectForKey:@"bad"] integerValue];
        self.commentPictureNumber = [[commentDic objectForKey:@"pic"] integerValue];
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

- (CGFloat)nearbyCellHeight {
    CGFloat gap = 0.5;
    CGFloat singleHeight = 30;
    
    NSUInteger itemCount = [self.nearbyFacilities count];
    CGFloat row = 0;
    if (itemCount > 0 && itemCount <= 3) {
        row = 1;
    } else {
        row = itemCount / 3;
        if (itemCount % 3 > 0) {
            row ++;
        }
    }
    
    CGFloat gapTotalHeight = 0;
    if (row > 1) {
        gapTotalHeight = (row - 1) * gap;
    }
    
    CGFloat cellHeight = row * singleHeight + gapTotalHeight;
    
    return cellHeight;
}

- (BOOL)hasCoupon {
    return ([self.couponUrlString length] > 0);
}

- (NSArray<NSString *> *)phoneNumbersArray {
    if ([self.phoneNumber length] == 0) {
        return nil;
    }
    self.phoneNumber = [self.phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self.phoneNumber componentsSeparatedByString:@","];
}

@end
