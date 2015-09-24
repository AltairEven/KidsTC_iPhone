//
//  HomeElementBaseModel.m
//  ICSON
//
//  Created by 钱烨 on 4/11/15.
//  Copyright (c) 2015 肖晓春. All rights reserved.
//

#import "HomeElementBaseModel.h"

NSString *const kParameterKeyLinkUrl = @"kParameterKeyLinkUrl";
NSString *const kParameterKeyServiceId = @"kParameterKeyServiceId";
NSString *const kParameterKeyServiceChannelId = @"kParameterKeyServiceChannelId";
NSString *const kParameterKeyStoreId = @"kParameterKeyStoreId";
NSString *const kParameterKeySearchKeyWord = @"kParameterKeySearchKeyWord";
NSString *const kParameterKeySearchArea = @"kParameterKeySearchArea";
NSString *const kParameterKeySearchAge = @"kParameterKeySearchAge";
NSString *const kParameterKeySearchCategory = @"kParameterKeySearchCategory";
NSString *const kParameterKeySearchSort = @"kParameterKeySearchSort";

@implementation HomeElementBaseModel

- (instancetype)initWithHomeData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if (!data || [data count] == 0 || ![data isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        [self parseHomeData:data];
    }
    return self;
}

- (void)parseHomeData:(NSDictionary *)data {
    
    //链接地址，在跳转网页时使用
    self.linkUrlString = [data objectForKey:@"linkUrl"];
    
    //跳转目的地
    self.segueDestination = (HomeSegueDestination)[[data objectForKey:@"linkType"] integerValue];
    
    self.pictureUrlString = [data objectForKey:@"imgUrl"];
    
    self.paramString = [data objectForKey:@"params"];
}


- (NSDictionary *)parametersFromParamString {
    NSDictionary *param = nil;
    if ([self.paramString length] > 0) {
        switch (self.segueDestination) {
            case HomeViewSegueDestinationH5:
            {
                param = [NSDictionary dictionaryWithObject:self.paramString forKey:kParameterKeyLinkUrl];
            }
                break;
            case HomeViewSegueDestinationServiceDetail:
            {
                NSArray *elementArray = [self.paramString componentsSeparatedByString:@","];
                if ([elementArray count] == 2) {
                    NSString *serviceId = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:0]];
                    NSString *channelId = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:1]];
                    serviceId = [serviceId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    channelId = [channelId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    param = [NSDictionary dictionaryWithObjectsAndKeys:serviceId, kParameterKeyServiceId, channelId, kParameterKeyServiceChannelId, nil];
                }
            }
                break;
            case HomeViewSegueDestinationStoreDetail:
            {
                NSString *storeId = [self.paramString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                param = [NSDictionary dictionaryWithObject:storeId forKey:kParameterKeyStoreId];
            }
                break;
            case HomeViewSegueDestinationServiceList:
            case HomeViewSegueDestinationStoreList:
            {
                NSArray *elementArray = [self.paramString componentsSeparatedByString:@","];
                if ([elementArray count] == 5) {
                    NSString *k = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:0]];
                    NSString *s = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:1]];
                    NSString *a = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:2]];
                    NSString *c = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:3]];
                    NSString *st = [NSString stringWithFormat:@"%@", [elementArray objectAtIndex:4]];
                    k = [k stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    a = [a stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    c = [c stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    st = [st stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    param = [NSDictionary dictionaryWithObjectsAndKeys:
                             k, kParameterKeySearchKeyWord,
                             s, kParameterKeySearchArea,
                             a, kParameterKeySearchAge,
                             c, kParameterKeySearchCategory,
                             st, kParameterKeySearchSort, nil];
                }
            }
                break;
            case HomeViewSegueDestinationTuanList:
            {
                
            }
                break;
            default:
                break;
        }
    }
    return param;
}

@end
