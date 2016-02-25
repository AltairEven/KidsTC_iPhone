//
//  HomeSegueModel.m
//  KidsTC
//
//  Created by 钱烨 on 10/10/15.
//  Copyright © 2015 KidsTC. All rights reserved.
//

#import "HomeSegueModel.h"

//H5
NSString *const kHomeSegueParameterKeyLinkUrl = @"kHomeSegueParameterKeyLinkUrl";
//资讯列表
NSString *const kHomeSegueParameterKeyNewsKind = @"kHomeSegueParameterKeyNewsKind";
NSString *const kHomeSegueParameterKeyNewsTag = @"kHomeSegueParameterKeyNewsTag";
NSString *const kHomeSegueParameterKeyNewsType = @"kHomeSegueParameterKeyNewsType";
//搜索
NSString *const kHomeSegueParameterKeySearchKeyWord = @"kHomeSegueParameterKeySearchKeyWord";
NSString *const kHomeSegueParameterKeySearchArea = @"kHomeSegueParameterKeySearchArea";
NSString *const kHomeSegueParameterKeySearchAge = @"kHomeSegueParameterKeySearchAge";
NSString *const kHomeSegueParameterKeySearchCategory = @"kHomeSegueParameterKeySearchCategory";
NSString *const kHomeSegueParameterKeySearchSort = @"kHomeSegueParameterKeySearchSort";

@interface HomeSegueModel ()

- (void)fillSegueParamWithData:(NSDictionary *)data;

@end

@implementation HomeSegueModel

- (instancetype)initWithDestination:(HomeSegueDestination)destination {
    self = [super init];
    if (self) {
        _destination = destination;
    }
    return self;
}

- (instancetype)initWithDestination:(HomeSegueDestination)destination paramRawData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _destination = destination;
        [self fillSegueParamWithData:data];
    }
    return self;
}


- (void)fillSegueParamWithData:(NSDictionary *)data {
    switch (self.destination) {
        case HomeSegueDestinationH5:
        {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSString *linkUrlString = [data objectForKey:@"linkurl"];
                if (linkUrlString && [linkUrlString isKindOfClass:[NSString class]]) {
                    _segueParam = [NSDictionary dictionaryWithObject:linkUrlString forKey:kHomeSegueParameterKeyLinkUrl];
                } else {
                    _destination = HomeSegueDestinationNone;
                }
            } else {
                _destination = HomeSegueDestinationNone;
            }
        }
            break;
        case HomeSegueDestinationNone:
        case HomeSegueDestinationNewsRecommend:
        case HomeSegueDestinationActivity:
        case HomeSegueDestinationLoveHouse:
        case HomeSegueDestinationHospital:
        case HomeSegueDestinationStrategyList:
            break;
        case HomeSegueDestinationNewsList:
        case HomeSegueDestinationServiceList:
        case HomeSegueDestinationStoreList:
        case HomeSegueDestinationServiceDetail:
        case HomeSegueDestinationStoreDetail:
        case HomeSegueDestinationStrategyDetail:
        case HomeSegueDestinationCouponList:
        case HomeSegueDestinationOrderDetail:
        case HomeSegueDestinationOrderList:
        case HomeSegueDestinationNewsFilter:
        case HomeSegueDestinationNewsListView:
        case HomeSegueDestinationFlashDetail:
        {
            if ([data isKindOfClass:[NSDictionary class]]) {
                _segueParam = [NSDictionary dictionaryWithDictionary:data];
            } else {
                _destination = HomeSegueDestinationNone;
            }
        }
            break;
        default:
            break;
    }
}

@end
