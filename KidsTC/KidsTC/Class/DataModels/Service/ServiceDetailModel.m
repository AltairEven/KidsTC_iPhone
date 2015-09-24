//
//  ServiceDetailModel.m
//  KidsTC
//
//  Created by 钱烨 on 8/8/15.
//  Copyright (c) 2015 KidsTC. All rights reserved.
//

#import "ServiceDetailModel.h"
#import "Insurance.h"

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
    self.starNumber = [[data objectForKey:@"level"] integerValue];
    self.commentsNumber = [[data objectForKey:@"evaluate"] integerValue];
    self.saleCount = [[data objectForKey:@"saleCount"] integerValue];
    self.price = [[data objectForKey:@"price"] floatValue];
    self.priceType = [[data objectForKey:@"priceSort"] integerValue];
    self.priceDescription = [data objectForKey:@"priceSortName"];
    self.countdownTime = [[data objectForKey:@"countDownTime"] integerValue];
    self.showCountdown = [[data objectForKey:@"showCountDown"] integerValue];
    self.supportedInsurances = [Insurance InsurancesWithRawData:[data objectForKey:@"insurance"]];
    self.promotionDescription = [data objectForKey:@"promote"];
    
    NSArray *ageArray = [data objectForKey:@"age"];
    if ([ageArray isKindOfClass:[NSArray class]]) {
        NSMutableString *string = [NSMutableString stringWithFormat:@""];
        for (NSString *age in ageArray) {
            [string appendString:age];
            [string appendString:@" "];
        }
        self.ageDescription = [NSString stringWithString:string];
    }
    
    self.timeDescription = [data objectForKey:@"dateTime"];
    
    NSArray *storeArray = [data objectForKey:@"store"];
    if ([storeArray isKindOfClass:[NSArray class]]) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in storeArray) {
            ServiceOwnerStoreModel *model = [[ServiceOwnerStoreModel alloc] initWithRawData:dic];
            if (model) {
                [tempArray addObject:model];
            }
        }
        self.storeItemsArray = [NSArray arrayWithArray:tempArray];
        if ([self.storeItemsArray count] > 0) {
            self.currentStoreModel = [self.storeItemsArray firstObject];
        }
    }
    
    self.stockNumber = [[data objectForKey:@"remainCount"] integerValue];
    self.maxLimit = [[data objectForKey:@"buyMaxNum"] integerValue];
    self.minLimit = [[data objectForKey:@"buyMinNum"] integerValue];
    self.isFavourate = [[data objectForKey:@"isFavor"] boolValue];
    
    if ([self.storeItemsArray count] > 0) {
        ServiceOwnerStoreModel *model = [self.storeItemsArray firstObject];
        self.phoneNumber = model.phoneNumber;
    }

}

@end
