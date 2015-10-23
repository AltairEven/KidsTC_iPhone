//
//  ServiceDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailModel.h"

@implementation ServiceDetailModel

- (void)fillWithRawData:(NSDictionary *)data {
    if (!data || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *imageUrlStrings = [data objectForKey:@"imgUrl"];
    if ([imageUrlStrings isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSString *urlString in imageUrlStrings) {
            NSURL *url = [NSURL URLWithString:urlString];
            if (url) {
                [tempArray addObject:url];
            }
        }
        self.imageUrls = [NSArray arrayWithArray:tempArray];
    }
    
    self.serviceName = [data objectForKey:@"serveName"];
    self.commentsNumber = [[data objectForKey:@"evaluate"] integerValue];
    self.saleCount = [[data objectForKey:@"saleCount"] integerValue];
    self.price = [[data objectForKey:@"price"] floatValue];
    self.priceDescription = [data objectForKey:@"priceSortName"];
    self.countdownTime = [[data objectForKey:@"countDownTime"] integerValue];
    self.showCountdown = [[data objectForKey:@"showCountDown"] integerValue];
    self.supportedInsurances = [Insurance InsurancesWithRawData:[data objectForKey:@"insurance"]];
    
    self.notice = [data objectForKey:@"notice"];
    self.recommenderFaceImageUrl = [NSURL URLWithString:[data objectForKey:@"recommendImgUrl"]];
    self.recommenderName = [data objectForKey:@"recommendName"];
    self.recommendString = [data objectForKey:@"recommendContent"];
    
    self.notice  = @"购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知购买须知";
    self.recommenderFaceImageUrl = [self.imageUrls firstObject];
    self.recommenderName = @"小河马";
    self.recommendString = @"小河马爱洗澡，萌萌哒满地跑，一不小心摔一跤，呜啊呜啊哭又闹。河马妈妈来看到，二话不说拿棍捣，小河马被打屁了，哈哈哈哈真搞笑。";
    
    self.isFavourate = [[data objectForKey:@"isFavor"] boolValue];
    self.phoneNumber = [data objectForKey:@"phone"];
    
    self.stockNumber = [[data objectForKey:@"remainCount"] integerValue];
    self.maxLimit = [[data objectForKey:@"buyMaxNum"] integerValue];
    self.minLimit = [[data objectForKey:@"buyMinNum"] integerValue];
    
    NSArray *storesArray = [data objectForKey:@"store"];
    if ([storesArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *singleDic in storesArray) {
            StoreListItemModel *item = [[StoreListItemModel alloc] initWithRawData:singleDic];
            [tempArray addObject:item];
        }
        self.storeItemsArray = [NSArray arrayWithArray:tempArray];
    }
}


- (CGFloat)topCellHeight {
    //image
    CGFloat height = SCREEN_WIDTH * 0.7;
    //service name
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:17] topGap:10 bottomGap:10 maxLine:2 andText:self.serviceName];
    //service description
    height += [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:3 andText:self.serviceDescription];
    
    return height;
}

- (CGFloat)priceCellHeight {
    return 40;
}

- (CGFloat)insuranceCellHeight {
    return 30;
}

- (CGFloat)couponCellHeight {
    return 40;
}

- (CGFloat)noticeTitleCellHeight {
    return 40;
}

- (CGFloat)noticeCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.notice];
    return height;
}

- (CGFloat)recommendCellHeight {
    CGFloat height = [GConfig heightForLabelWithWidth:SCREEN_WIDTH - 10 LineBreakMode:NSLineBreakByCharWrapping Font:[UIFont systemFontOfSize:13] topGap:10 bottomGap:10 maxLine:0 andText:self.recommendString];
    if (height < 80) {
        height = 80;
    }
    
    return height;
}

@end
